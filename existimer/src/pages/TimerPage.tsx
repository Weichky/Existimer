import { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useTimerStore } from '../store/timerStore';
import { Preset } from '../lib/db';
import { COLORS } from '../constants/timer';
import { GlassCard } from '../components/GlassCard';
import { TickMarks } from '../components/TickMarks';
import { ProgressRing } from '../components/ProgressRing';
import { PulsingGlow } from '../components/PulsingGlow';
import { StatsModal } from '../components/modals/StatsModal';
import { EditModal } from '../components/modals/EditModal';
import { useDialInteraction } from '../hooks/useDialInteraction';
import { formatTime } from '../utils/time';

interface TimerPageProps {
  preset: Preset;
  onInsertAfter: () => void;
}

export function TimerPage({ preset, onInsertAfter }: TimerPageProps) {
  const {
    timerType,
    status,
    targetSeconds,
    elapsedSeconds,
    init,
    applyPreset,
    start,
    pause,
    resume,
    reset,
    tick,
  } = useTimerStore();

  const [showStats, setShowStats] = useState(false);
  const [showEdit, setShowEdit] = useState(false);

  useEffect(() => {
    init();
  }, [init]);

  useEffect(() => {
    if (preset) {
      applyPreset(preset);
    }
  }, [preset, applyPreset]);

  useEffect(() => {
    let interval: number | null = null;
    if (status === 'running') {
      interval = window.setInterval(() => tick(), 1000);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [status, tick]);

  const triggerClick = () => {
    if (status === 'idle') {
      start();
    } else if (status === 'running') {
      pause();
    } else if (status === 'paused') {
      resume();
    }
  };

  const handleLongPress = () => {
    if (status === 'idle') {
      setShowStats(true);
    } else {
      reset();
    }
  };

  const handleDoubleTap = () => {
    if (status === 'idle') {
      setShowEdit(true);
    }
  };

  const { handlers, clearTimers } = useDialInteraction(
    {
      onSingleTap: triggerClick,
      onDoubleTap: handleDoubleTap,
      onLongPress: handleLongPress,
    },
    {}
  );

  useEffect(() => {
    if (showEdit) {
      clearTimers();
    }
  }, [showEdit, clearTimers]);

  const getDisplayTime = () => {
    if (timerType === 'countdown') {
      const remaining = targetSeconds - elapsedSeconds;
      return formatTime(Math.max(0, remaining));
    }
    return formatTime(elapsedSeconds);
  };

  const progress = timerType === 'countdown'
    ? Math.max(0, (targetSeconds - elapsedSeconds) / targetSeconds * 100)
    : 100;

  const isMinimalMode = status === 'running' || status === 'paused';

  return (
    <div className="min-h-screen bg-[#f5f5f5] flex flex-col">
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div
          className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px]"
          style={{
            background: `radial-gradient(circle, ${COLORS.radialGradient} 0%, transparent 70%)`,
          }}
        />
      </div>

      <div className="flex-1 flex flex-col items-center justify-center p-4">
        <div className="relative z-10 flex-shrink-0">
          <motion.div
            className="relative w-56 h-56 mx-auto cursor-pointer"
            initial={{ scale: 0.95, opacity: 0.8 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ duration: 0.5, ease: 'easeOut' }}
            {...handlers}
          >
            <div
              className="absolute inset-0 rounded-full"
              style={{
                background: 'linear-gradient(145deg, #fafafa 0%, #ffffff 50%, #f8f8f8 100%)',
                boxShadow: '0 8px 24px rgba(0,0,0,0.08), 0 2px 8px rgba(0,0,0,0.04)',
              }}
            />

            <div
              className="absolute inset-[14px] rounded-full"
              style={{
                background: 'linear-gradient(145deg, #ffffff 0%, #fafafa 100%)',
                boxShadow: 'inset 0 2px 4px rgba(0,0,0,0.04), inset 0 -2px 4px rgba(255,255,255,0.9)',
              }}
            >
              <TickMarks />

              <div className="absolute inset-0 flex flex-col items-center justify-center">
                <div className="text-5xl font-mono font-bold tracking-tight text-black/80 flex items-center">
                  <span>{getDisplayTime().split(':')[0]}</span>
                  <motion.span
                    animate={{ opacity: [1, 0.3, 1] }}
                    transition={{ duration: 1, repeat: Infinity, ease: 'easeInOut' }}
                  >
                    :
                  </motion.span>
                  <span>{getDisplayTime().split(':')[1]}</span>
                </div>

                <AnimatePresence>
                  {status === 'completed' && (
                    <motion.div
                      initial={{ opacity: 0, scale: 0.8 }}
                      animate={{ opacity: 1, scale: 1 }}
                      exit={{ opacity: 0, scale: 0.8 }}
                      className="mt-2 flex items-center gap-1 text-emerald-500"
                    >
                      <svg className="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                      </svg>
                      <span className="text-xs font-medium tracking-wider uppercase">完成</span>
                    </motion.div>
                  )}
                </AnimatePresence>
              </div>
            </div>

            {timerType === 'countdown' && status !== 'idle' && (
              <ProgressRing progress={progress} status={status} />
            )}

            {status === 'running' && (
              <PulsingGlow status={status}>
                <div />
              </PulsingGlow>
            )}
          </motion.div>
        </div>

        {!isMinimalMode && (
          <div className="relative z-10 mt-6 w-full max-w-xs">
            <AnimatePresence>
              {status === 'idle' && (
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  className="flex justify-center"
                >
                  <span className="text-xs text-black/30 tracking-widest">
                    点击开始 · 长按统计 · 双击编辑
                  </span>
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        )}
      </div>

      <div className="relative z-10 pb-6 flex justify-center">
        <GlassCard className="px-5 py-2.5 rounded-full">
          <h2 className="text-sm font-medium text-black/40 uppercase tracking-[0.3em]">
            {preset?.name || 'Timer'}
          </h2>
          <p className="text-xs text-black/25 mt-0.5 tracking-widest text-center">
            {timerType === 'countdown' ? '倒计时' : '正计时'}
          </p>
        </GlassCard>
      </div>

      <AnimatePresence>
        {showStats && (
          <StatsModal
            onClose={() => setShowStats(false)}
            onInsert={() => {
              setShowStats(false);
              onInsertAfter();
            }}
          />
        )}
      </AnimatePresence>

      <AnimatePresence>
        {showEdit && (
          <EditModal onClose={() => setShowEdit(false)} />
        )}
      </AnimatePresence>
    </div>
  );
}