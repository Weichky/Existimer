import { create } from "zustand";
import {
  getSetting,
  setSetting,
  saveSession,
  generateId,
  Session,
  Preset,
} from "../lib/db";

type TimerStatus = "idle" | "running" | "paused" | "completed";

interface TimerState {
  timerType: "countdown" | "countup";
  status: TimerStatus;
  targetSeconds: number;
  elapsedSeconds: number;
  pauseCount: number;
  totalPauseSeconds: number;
  defaultCountdownMinutes: number;
  sessionId: string | null;
  sessionStartTime: string | null;
  pauseStartTime: number | null;

  init: () => Promise<void>;
  applyPreset: (preset: Preset) => void;
  setDefaultCountdownMinutes: (minutes: number) => Promise<void>;
  start: () => void;
  pause: () => void;
  resume: () => void;
  reset: () => Promise<void>;
  tick: () => void;
}

export const useTimerStore = create<TimerState>((set, get) => ({
  timerType: "countdown",
  status: "idle",
  targetSeconds: 35 * 60,
  elapsedSeconds: 0,
  pauseCount: 0,
  totalPauseSeconds: 0,
  defaultCountdownMinutes: 35,
  sessionId: null,
  sessionStartTime: null,
  pauseStartTime: null,

  init: async () => {
    const savedMinutes = await getSetting("defaultCountdownMinutes");
    const minutes = savedMinutes ? parseInt(savedMinutes, 10) : 35;
    set({
      defaultCountdownMinutes: minutes,
      targetSeconds: minutes * 60,
    });
  },

  applyPreset: (preset: Preset) => {
    set({
      timerType: preset.timer_type,
      targetSeconds: preset.target_seconds,
      status: "idle",
      elapsedSeconds: 0,
      pauseCount: 0,
      totalPauseSeconds: 0,
      pauseStartTime: null,
    });
  },

  setDefaultCountdownMinutes: async (minutes) => {
    await setSetting("defaultCountdownMinutes", minutes.toString());
    const state = get();
    set({
      defaultCountdownMinutes: minutes,
      targetSeconds: state.timerType === "countdown" ? minutes * 60 : state.targetSeconds,
    });
  },

  start: () => {
    const state = get();
    if (state.status !== "idle") return;

    set({
      status: "running",
      sessionId: generateId(),
      sessionStartTime: Date.now().toString(),
    });
  },

  pause: () => {
    const state = get();
    if (state.status !== "running") return;

    set({
      status: "paused",
      pauseCount: state.pauseCount + 1,
      pauseStartTime: Date.now(),
    });
  },

  resume: () => {
    const state = get();
    if (state.status !== "paused") return;

    let additionalPauseSeconds = 0;
    if (state.pauseStartTime) {
      additionalPauseSeconds = Math.floor((Date.now() - state.pauseStartTime) / 1000);
    }

    set({
      status: "running",
      totalPauseSeconds: state.totalPauseSeconds + additionalPauseSeconds,
      pauseStartTime: null,
    });
  },

  reset: async () => {
    const state = get();

    let finalPauseSeconds = state.totalPauseSeconds;
    if (state.status === "paused" && state.pauseStartTime) {
      finalPauseSeconds += Math.floor((Date.now() - state.pauseStartTime) / 1000);
    }

    if (state.sessionId && state.sessionStartTime) {
      const session: Session = {
        id: state.sessionId,
        start_time: parseInt(state.sessionStartTime, 10),
        end_time: Date.now(),
        duration: state.elapsedSeconds,
        pause_count: state.pauseCount,
        pause_duration: finalPauseSeconds,
        timer_type: state.timerType,
        target_duration: state.timerType === "countdown" ? state.targetSeconds : 0,
        is_completed: state.status === "completed" ? 1 : 0,
      };
      await saveSession(session);
    }

    set({
      status: "idle",
      elapsedSeconds: 0,
      pauseCount: 0,
      totalPauseSeconds: 0,
      sessionId: null,
      sessionStartTime: null,
      pauseStartTime: null,
    });
  },

  tick: () => {
    const state = get();
    if (state.status !== "running") return;

    const newElapsed = state.elapsedSeconds + 1;

    if (state.timerType === "countdown") {
      const remaining = state.targetSeconds - newElapsed;
      if (remaining <= 0) {
        set({ elapsedSeconds: state.targetSeconds, status: "completed" });
        return;
      }
    }

    set({ elapsedSeconds: newElapsed });
  },
}));