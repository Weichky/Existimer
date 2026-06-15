import { useMemo } from 'react';
import { COLORS } from '../constants/timer';

const TICK_RADIUS = {
  HOUR: 95,
  MINUTE: 100,
  OUTER: 108,
  CENTER: 128,
};

export function TickMarks() {
  const ticks = useMemo(() => {
    const result = [];
    const cx = TICK_RADIUS.CENTER;
    for (let i = 0; i < 60; i++) {
      const angle = (i * 6 - 90) * (Math.PI / 180);
      const isHour = i % 5 === 0;
      const r1 = isHour ? TICK_RADIUS.HOUR : TICK_RADIUS.MINUTE;
      const r2 = TICK_RADIUS.OUTER;
      result.push({
        x1: cx + r1 * Math.cos(angle),
        y1: cx + r1 * Math.sin(angle),
        x2: cx + r2 * Math.cos(angle),
        y2: cx + r2 * Math.sin(angle),
        isHour,
        key: i,
      });
    }
    return result;
  }, []);

  return (
    <svg
      className="absolute inset-0 w-full h-full -rotate-90"
      viewBox="0 0 256 256"
    >
      {ticks.map((tick) => (
        <line
          key={tick.key}
          x1={tick.x1}
          y1={tick.y1}
          x2={tick.x2}
          y2={tick.y2}
          stroke={tick.isHour ? COLORS.tickHour : COLORS.tickMinute}
          strokeWidth={tick.isHour ? 2 : 1}
          strokeLinecap="round"
        />
      ))}
    </svg>
  );
}