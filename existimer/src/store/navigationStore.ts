import { create } from 'zustand';
import { Preset, initPresetsIfNeeded } from '../lib/db';

type PageName = 'Timer' | 'History' | 'Settings';

const verticalPages: PageName[] = ['Timer', 'History', 'Settings'];

interface CurrentPage {
  axis: 'horizontal' | 'vertical';
  index: number;
  name: string;
}

interface NavigationState {
  presets: Preset[];
  horizontalIndex: number;
  verticalIndex: number;
  currentPage: CurrentPage;
  initialized: boolean;
  init: () => Promise<void>;
  navigateHorizontal: (delta: number) => void;
  navigateVertical: (delta: number) => void;
  insertPresetAfterCurrent: (preset: Preset) => Promise<void>;
}

export const useNavigationStore = create<NavigationState>((set, get) => ({
  presets: [],
  horizontalIndex: 0,
  verticalIndex: 0,
  currentPage: { axis: 'horizontal', index: 0, name: 'Countdown' },
  initialized: false,

  init: async () => {
    const presets = await initPresetsIfNeeded();
    set({
      presets,
      initialized: true,
    });
  },

  navigateHorizontal: (delta: number) => {
    const state = get();
    if (state.presets.length === 0) return;

    const mod = (n: number, m: number) => ((n % m) + m) % m;
    const newIndex = mod(state.horizontalIndex + delta, state.presets.length);
    const presetName = state.presets[newIndex]?.name || 'Countdown';
    set({
      horizontalIndex: newIndex,
      currentPage: { axis: 'horizontal', index: newIndex, name: presetName },
    });
  },

  navigateVertical: (delta: number) => {
    const state = get();
    const mod = (n: number, m: number) => ((n % m) + m) % m;
    const newIndex = mod(state.verticalIndex + delta, verticalPages.length);
    const pageName = verticalPages[newIndex];
    set({
      verticalIndex: newIndex,
      currentPage: { axis: 'vertical', index: newIndex, name: pageName },
    });
  },

  insertPresetAfterCurrent: async (preset: Preset) => {
    const state = get();
    const currentPosition = state.presets[state.horizontalIndex]?.position ?? 0;
    const newPreset = {
      ...preset,
      id: preset.id || crypto.randomUUID(),
      position: currentPosition + 1,
      created_at: Date.now(),
      updated_at: Date.now(),
    };
    await import('../lib/db').then(db => db.insertPresetAfter(currentPosition, newPreset));
    const presets = await import('../lib/db').then(db => db.getPresets());
    set({ presets });
  },
}));