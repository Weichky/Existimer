export const SWISS_RED = '#E63946';
export const COMPLETED_GREEN = '#10b981';
export const GLASS_BLUR = 'blur(12px)';

export const TIMING = {
  CLICK_DELAY: 300,
  LONG_PRESS_DURATION: 1000,
} as const;

export const DIAL = {
  SIZE: 224,
  INNER_SIZE: 196,
  FACE_SIZE: 168,
  PROGRESS_RADIUS: 96,
  TICK_OUTER: 96,
  TICK_INNER_HOUR: 83,
  TICK_INNER_MINUTE: 88,
} as const;

export const COLORS = {
  background: '#f5f5f5',
  radialGradient: 'rgba(230,57,70,0.06)',
  glassBackground: 'rgba(255, 255, 255, 0.92)',
  glassBorder: 'rgba(0, 0, 0, 0.06)',
  glassShadow: '0 4px 20px rgba(0,0,0,0.06), inset 0 1px 0 rgba(255,255,255,0.9)',
  tickHour: 'rgba(0,0,0,0.15)',
  tickMinute: 'rgba(0,0,0,0.06)',
  progressBackground: 'rgba(0,0,0,0.04)',
  pausedStroke: 'rgba(230, 57, 70, 0.5)',
} as const;