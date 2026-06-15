import { useMemo } from 'react';
import { DIAL, COLORS } from '../constants/timer';

interface TickMarksProps {
  size?: number;
}

export function TickMarks({ size = DIAL.FACE_SIZE }: TickMarksProps) {
  const ticks = useMemo(() => {
    const result = [];
    const cx = size / 2;
    for (let i = 0; i < 60; i++) {
      const angle = (i * 6 - 90) * (Math.PI / 180);
      const isHour = i % 5 === 0;
      const r1 = isHour ? DIAL.TICK_INNER_HOUR : DIAL.TICK_INNER_MINUTE;
      const r2 = DIAL.TICK_OUTER;
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
  }, [size]);

  return (
    <svg
      className="absolute inset-0 w-full h-full -rotate-90"
      viewBox={`0 0 ${size} ${size}`}
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