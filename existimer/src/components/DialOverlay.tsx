import { motion } from 'framer-motion';
import { SWISS_RED } from '../constants/timer';

interface DialOverlayProps {
  progress: number;
  visible: boolean;
}

export function DialOverlay({ progress, visible }: DialOverlayProps) {
  const size = 300;
  const ringR = 112;
  const circumference = 2 * Math.PI * ringR;
  const strokeDashoffset = circumference * (1 - progress);

  return (
    <>
      <div
        className="absolute pointer-events-none rounded-full"
        style={{
          width: size,
          height: size,
          left: '50%',
          top: '50%',
          transform: 'translate(-50%, -50%)',
          zIndex: 0,
          background: 'rgba(255, 255, 255, 0.4)',
          backdropFilter: 'blur(16px)',
        }}
      />
      
      <motion.svg
        className="absolute pointer-events-none"
        style={{
          width: size,
          height: size,
          left: '50%',
          top: '50%',
          transform: 'translate(-50%, -50%)',
          zIndex: 1,
        }}
        viewBox={`0 0 ${size} ${size}`}
      >
        <defs>
          <filter id="glow" x="-30%" y="-30%" width="160%" height="160%">
            <feGaussianBlur stdDeviation="4" result="coloredBlur" />
            <feMerge>
              <feMergeNode in="coloredBlur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>
        </defs>

        <motion.circle
          cx={size / 2}
          cy={size / 2}
          r={ringR}
          fill="none"
          stroke={SWISS_RED}
          strokeWidth="5"
          strokeLinecap="round"
          strokeDasharray={circumference}
          strokeDashoffset={strokeDashoffset}
          filter="url(#glow)"
          animate={{ opacity: visible ? 1 : 0 }}
          transition={{ duration: 0.2 }}
        />
      </motion.svg>
    </>
  );
}