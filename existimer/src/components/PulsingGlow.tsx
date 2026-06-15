import { motion } from 'framer-motion';

type TimerStatus = 'idle' | 'running' | 'paused' | 'completed';

interface PulsingGlowProps {
  status: TimerStatus;
  children: React.ReactNode;
}

export function PulsingGlow({ status, children }: PulsingGlowProps) {
  const shouldPulse = status === 'running' || status === 'paused';

  return (
    <motion.div
      className="absolute inset-0 rounded-full flex items-center justify-center"
      animate={shouldPulse ? {
        boxShadow: [
          '0 0 20px rgba(230,57,70,0.15), 0 0 40px rgba(230,57,70,0.1)',
          '0 0 30px rgba(230,57,70,0.25), 0 0 60px rgba(230,57,70,0.15)',
          '0 0 20px rgba(230,57,70,0.15), 0 0 40px rgba(230,57,70,0.1)',
        ],
      } : {}}
      transition={{
        duration: 2,
        repeat: Infinity,
        ease: 'easeInOut',
      }}
    >
      {children}
    </motion.div>
  );
}