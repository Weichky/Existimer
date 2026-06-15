import { useMemo } from 'react';
import { motion } from 'framer-motion';
import { DIAL, COLORS, SWISS_RED, COMPLETED_GREEN } from '../constants/timer';

type TimerStatus = 'idle' | 'running' | 'paused' | 'completed';

interface ProgressRingProps {
  progress: number;
  status: TimerStatus;
  size?: number;
}

export function ProgressRing({ progress, status, size = DIAL.SIZE }: ProgressRingProps) {
  const r = DIAL.PROGRESS_RADIUS;
  const circumference = 2 * Math.PI * r;
  const strokeDashoffset = circumference * (1 - progress / 100);

  const strokeColor = useMemo(() => {
    switch (status) {
      case 'completed': return COMPLETED_GREEN;
      case 'paused': return COLORS.pausedStroke;
      default: return SWISS_RED;
    }
  }, [status]);

  return (
    <svg
      className="absolute inset-0 w-full h-full -rotate-90"
      viewBox={`0 0 ${size} ${size}`}
    >
      <circle
        cx={size / 2}
        cy={size / 2}
        r={r}
        fill="none"
        stroke={COLORS.progressBackground}
        strokeWidth="5"
      />
      <motion.circle
        cx={size / 2}
        cy={size / 2}
        r={r}
        fill="none"
        stroke={strokeColor}
        strokeWidth="5"
        strokeLinecap="round"
        strokeDasharray={circumference}
        initial={{ strokeDashoffset: circumference }}
        animate={{ strokeDashoffset }}
        transition={{
          type: 'spring',
          stiffness: 60,
          damping: 15,
          mass: 1,
        }}
      />
    </svg>
  );
}