import { useState, useEffect, useCallback, useMemo } from 'react';
import { useTranslation } from 'react-i18next';
import { motion, AnimatePresence } from 'framer-motion';

interface TimerPageProps {
  presetName: string;
}

type TimerMode = 'countdown' | 'countup';
type TimerStatus = 'idle' | 'running' | 'paused' | 'completed';

interface TimerState {
  mode: TimerMode;
  status: TimerStatus;
  targetSeconds: number;
  elapsedSeconds: number;
  pauseCount: number;
  totalPauseSeconds: number;
}

const SWISS_RED = '#E63946';

const GlassCard = ({ children, className = '' }: { children: React.ReactNode; className?: string }) => (
  <div 
    className={`backdrop-blur-xl ${className}`}
    style={{
      background: 'rgba(255, 255, 255, 0.92)',
      border: '1px solid rgba(0, 0, 0, 0.06)',
      boxShadow: '0 4px 20px rgba(0,0,0,0.06), inset 0 1px 0 rgba(255,255,255,0.9)',
    }}
  >
    {children}
  </div>
);

function TickMarks() {
  const ticks = useMemo(() => {
    const result = [];
    for (let i = 0; i < 60; i++) {
      const angle = (i * 6 - 90) * (Math.PI / 180);
      const isHour = i % 5 === 0;
      const r1 = isHour ? 95 : 100;
      const r2 = 108;
      result.push({
        x1: 128 + r1 * Math.cos(angle),
        y1: 128 + r1 * Math.sin(angle),
        x2: 128 + r2 * Math.cos(angle),
        y2: 128 + r2 * Math.sin(angle),
        isHour,
        key: i,
      });
    }
    return result;
  }, []);

  return (
    <svg className="absolute inset-0 w-full h-full -rotate-90" viewBox="0 0 256 256">
      {ticks.map((tick) => (
        <line
          key={tick.key}
          x1={tick.x1}
          y1={tick.y1}
          x2={tick.x2}
          y2={tick.y2}
          stroke={tick.isHour ? 'rgba(0,0,0,0.15)' : 'rgba(0,0,0,0.06)'}
          strokeWidth={tick.isHour ? 2 : 1}
          strokeLinecap="round"
        />
      ))}
    </svg>
  );
}

function ProgressRing({ progress, status }: { progress: number; status: TimerStatus }) {
  const circumference = 2 * Math.PI * 110;
  const strokeDashoffset = circumference * (1 - progress / 100);
  
  const strokeColor = useMemo(() => {
    switch (status) {
      case 'completed': return '#10b981';
      case 'paused': return 'rgba(230, 57, 70, 0.5)';
      default: return SWISS_RED;
    }
  }, [status]);

  return (
    <svg className="absolute w-full h-full -rotate-90" style={{ width: 288, height: 288 }} viewBox="0 0 256 256">
      <circle
        cx="128"
        cy="128"
        r="110"
        fill="none"
        stroke="rgba(0,0,0,0.04)"
        strokeWidth="6"
      />
      <motion.circle
        cx="128"
        cy="128"
        r="110"
        fill="none"
        stroke={strokeColor}
        strokeWidth="6"
        strokeLinecap="round"
        strokeDasharray={circumference}
        initial={{ strokeDashoffset: circumference }}
        animate={{ strokeDashoffset }}
        transition={{ 
          type: 'spring', 
          stiffness: 60, 
          damping: 15,
          mass: 1
        }}
      />
    </svg>
  );
}

function PulsingGlow({ status, children }: { status: TimerStatus; children: React.ReactNode }) {
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
        ease: 'easeInOut' 
      }}
    >
      {children}
    </motion.div>
  );
}

export function TimerPage({ presetName }: TimerPageProps) {
  const { t } = useTranslation();
  const [timerState, setTimerState] = useState<TimerState>({
    mode: 'countdown',
    status: 'idle',
    targetSeconds: 35 * 60,
    elapsedSeconds: 0,
    pauseCount: 0,
    totalPauseSeconds: 0,
  });

  const [pauseStartTime, setPauseStartTime] = useState<number | null>(null);

  useEffect(() => {
    let interval: number | null = null;

    if (timerState.status === 'running') {
      interval = window.setInterval(() => {
        setTimerState((prev) => {
          const newElapsed = prev.elapsedSeconds + 1;

          if (prev.mode === 'countdown') {
            const remaining = prev.targetSeconds - newElapsed;
            if (remaining <= 0) {
              return { ...prev, elapsedSeconds: prev.targetSeconds, status: 'completed' };
            }
          }

          return { ...prev, elapsedSeconds: newElapsed };
        });
      }, 1000);
    }

    return () => {
      if (interval) clearInterval(interval);
    };
  }, [timerState.status, timerState.mode, timerState.targetSeconds]);

  const formatTime = useCallback((seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }, []);

  const getDisplayTime = useCallback(() => {
    if (timerState.mode === 'countdown') {
      const remaining = timerState.targetSeconds - timerState.elapsedSeconds;
      return formatTime(Math.max(0, remaining));
    }
    return formatTime(timerState.elapsedSeconds);
  }, [timerState, formatTime]);

  const handleStart = () => {
    setTimerState((prev) => ({ ...prev, status: 'running' }));
  };

  const handlePause = () => {
    setTimerState((prev) => ({
      ...prev,
      status: 'paused',
      pauseCount: prev.pauseCount + 1,
    }));
    setPauseStartTime(Date.now());
  };

  const handleResume = () => {
    if (pauseStartTime) {
      const pauseDuration = Math.floor((Date.now() - pauseStartTime) / 1000);
      setTimerState((prev) => ({
        ...prev,
        status: 'running',
        totalPauseSeconds: prev.totalPauseSeconds + pauseDuration,
      }));
      setPauseStartTime(null);
    } else {
      setTimerState((prev) => ({ ...prev, status: 'running' }));
    }
  };

  const handleReset = () => {
    setTimerState((prev) => ({
      ...prev,
      status: 'idle',
      elapsedSeconds: 0,
      pauseCount: 0,
      totalPauseSeconds: 0,
    }));
    setPauseStartTime(null);
  };

  const toggleMode = () => {
    setTimerState((prev) => ({
      ...prev,
      mode: prev.mode === 'countdown' ? 'countup' : 'countdown',
      status: 'idle',
      elapsedSeconds: 0,
    }));
  };

  const countdownProgress = useMemo(() => {
    if (timerState.mode !== 'countdown') return 100;
    const remaining = timerState.targetSeconds - timerState.elapsedSeconds;
    return Math.max(0, (remaining / timerState.targetSeconds) * 100);
  }, [timerState.mode, timerState.elapsedSeconds, timerState.targetSeconds]);

  return (
    <div className="min-h-screen bg-[#f5f5f5] flex flex-col items-center justify-center p-8">
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div 
          className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px]"
          style={{
            background: 'radial-gradient(circle, rgba(230,57,70,0.06) 0%, transparent 70%)',
          }}
        />
      </div>

      <div className="relative z-10 mb-10">
        <GlassCard className="rounded-2xl px-6 py-3 inline-block">
          <h2 className="text-sm font-medium text-black/40 uppercase tracking-[0.4em]">{presetName}</h2>
          <p className="text-xs text-black/25 mt-1 tracking-widest">
            {timerState.mode === 'countdown' ? t('timer.countdown') : t('timer.countup')}
          </p>
        </GlassCard>
      </div>

      <div className="relative z-10">
        <motion.div 
          className="relative w-72 h-72"
          initial={{ scale: 0.95, opacity: 0.8 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 0.5, ease: 'easeOut' }}
        >
          <div 
            className="absolute inset-0 rounded-full"
            style={{
              background: 'linear-gradient(145deg, #fafafa 0%, #ffffff 50%, #f8f8f8 100%)',
              boxShadow: '0 12px 40px rgba(0,0,0,0.1), 0 4px 12px rgba(0,0,0,0.05)',
            }}
          />
          
          <div 
            className="absolute inset-[18px] rounded-full"
            style={{
              background: 'linear-gradient(145deg, #ffffff 0%, #fafafa 100%)',
              boxShadow: 'inset 0 2px 6px rgba(0,0,0,0.04), inset 0 -2px 4px rgba(255,255,255,0.9)',
            }}
          >
            <TickMarks />
            
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <div className="text-6xl font-mono font-bold tracking-tight text-black/80 flex items-center">
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
                {timerState.status === 'completed' && (
                  <motion.div 
                    initial={{ opacity: 0, scale: 0.8 }}
                    animate={{ opacity: 1, scale: 1 }}
                    exit={{ opacity: 0, scale: 0.8 }}
                    className="mt-3 flex items-center gap-1.5 text-emerald-500"
                  >
                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                    </svg>
                    <span className="text-xs font-medium tracking-wider uppercase">{t('timer.complete')}</span>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          </div>
          
          {timerState.mode === 'countdown' && timerState.status !== 'idle' && (
            <ProgressRing progress={countdownProgress} status={timerState.status} />
          )}
          
          {timerState.status === 'running' && (
            <PulsingGlow status={timerState.status}>
              <div />
            </PulsingGlow>
          )}
        </motion.div>
      </div>

      <div className="flex gap-3 mt-12 z-10">
        <AnimatePresence mode="wait">
          {timerState.status === 'idle' && (
            <motion.button
              key="start"
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.9 }}
              onClick={handleStart}
              className="px-10 py-3 rounded-full font-medium text-sm text-white tracking-widest uppercase"
              style={{
                background: SWISS_RED,
                boxShadow: '0 4px 16px rgba(230,57,70,0.35)',
              }}
            >
              {t('timer.start')}
            </motion.button>
          )}
          {timerState.status === 'running' && (
            <motion.button
              key="pause"
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.9 }}
              onClick={handlePause}
              className="px-10 py-3 rounded-full font-medium text-sm tracking-widest uppercase text-black/80"
              style={{
                background: 'rgba(255,255,255,0.92)',
                backdropFilter: 'blur(12px)',
                border: '1px solid rgba(0,0,0,0.06)',
                boxShadow: '0 4px 16px rgba(0,0,0,0.06)',
              }}
            >
              {t('timer.pause')}
            </motion.button>
          )}
          {timerState.status === 'paused' && (
            <motion.button
              key="resume"
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.9 }}
              onClick={handleResume}
              className="px-10 py-3 rounded-full font-medium text-sm tracking-widest uppercase"
              style={{
                background: SWISS_RED,
                color: 'white',
                boxShadow: '0 4px 16px rgba(230,57,70,0.35)',
              }}
            >
              {t('timer.resume')}
            </motion.button>
          )}
          {timerState.status === 'completed' && (
            <motion.button
              key="reset"
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.9 }}
              onClick={handleReset}
              className="px-10 py-3 rounded-full font-medium text-sm tracking-widest uppercase"
              style={{
                background: '#10b981',
                color: 'white',
              }}
            >
              {t('timer.reset')}
            </motion.button>
          )}
        </AnimatePresence>
        
        {(timerState.status === 'running' || timerState.status === 'paused') && (
          <motion.button
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            onClick={handleReset}
            className="px-8 py-3 rounded-full font-medium text-sm text-black/30 hover:text-black/50 tracking-widest uppercase transition-colors"
            style={{
              background: 'rgba(255,255,255,0.92)',
              backdropFilter: 'blur(12px)',
              border: '1px solid rgba(0,0,0,0.06)',
            }}
          >
            {t('timer.reset')}
          </motion.button>
        )}
      </div>

      <GlassCard className="mt-8 px-6 py-2 rounded-full z-10">
        <button
          onClick={toggleMode}
          className="text-xs text-black/30 hover:text-black/50 transition-colors tracking-widest uppercase"
        >
          {t('timer.switchMode', { mode: timerState.mode === 'countdown' ? t('timer.countup') : t('timer.countdown') })}
        </button>
      </GlassCard>

      <AnimatePresence>
        {timerState.status !== 'idle' && (
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 10 }}
            className="mt-10 z-10"
          >
            <GlassCard className="px-8 py-4 rounded-2xl">
              <div className="flex gap-10 text-sm text-black/30">
                <div className="flex flex-col items-center">
                  <span className="text-xl font-semibold text-black/60">{timerState.pauseCount}</span>
                  <span className="text-xs text-black/25 mt-1.5 tracking-widest uppercase">{t('timer.pauseCount')}</span>
                </div>
                <div className="w-px h-8 bg-black/10" />
                <div className="flex flex-col items-center">
                  <span className="text-xl font-semibold text-black/60">{formatTime(timerState.totalPauseSeconds)}</span>
                  <span className="text-xs text-black/25 mt-1.5 tracking-widest uppercase">{t('timer.pauseDuration')}</span>
                </div>
              </div>
            </GlassCard>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
