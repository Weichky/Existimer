import { create } from 'zustand';

type AxisType = 'horizontal' | 'vertical';

type PageName = 
  | 'Timer35' | 'Timer90' | 'TimerCountup' | 'TimerCustom1' | 'TimerCustom2'
  | 'Timer' | 'History' | 'Settings';

interface Page {
  axis: AxisType;
  index: number;
  name: PageName;
}

interface NavigationState {
  horizontalIndex: number;
  verticalIndex: number;
  currentPage: Page;
  navigate: (action: { type: AxisType; delta: number }) => Page;
}

const horizontalPages: PageName[] = ['Timer35', 'Timer90', 'TimerCountup', 'TimerCustom1', 'TimerCustom2'];
const verticalPages: PageName[] = ['Timer', 'History', 'Settings'];

function getPageName(axis: AxisType, index: number): PageName {
  const mod = (n: number, m: number) => ((n % m) + m) % m;
  if (axis === 'horizontal') {
    return horizontalPages[mod(index, horizontalPages.length)];
  } else {
    return verticalPages[mod(index, verticalPages.length)];
  }
}

export const useNavigationStore = create<NavigationState>((set, get) => ({
  horizontalIndex: 0,
  verticalIndex: 0,
  currentPage: { axis: 'horizontal', index: 0, name: 'Timer35' },

  navigate: (action: { type: AxisType; delta: number }) => {
    const state = get();
    let page: Page;

    if (action.type === 'horizontal') {
      const newIndex = state.horizontalIndex + action.delta;
      page = { axis: 'horizontal', index: newIndex, name: getPageName('horizontal', newIndex) };
      set({ horizontalIndex: newIndex, currentPage: page });
    } else {
      const newIndex = state.verticalIndex + action.delta;
      page = { axis: 'vertical', index: newIndex, name: getPageName('vertical', newIndex) };
      set({ verticalIndex: newIndex, currentPage: page });
    }

    return page;
  },
}));