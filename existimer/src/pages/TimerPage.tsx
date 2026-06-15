import { useState, useEffect, useMemo, useRef, useCallback } from 'react';
import { useTimerStore } from '../store/timerStore';
import { Preset } from '../lib/db';
import { motion, AnimatePresence } from 'framer-motion';

const SWISS_RED = '#E63946';

const GlassCard = ({ children, className = '', onClick }: { children: React.ReactNode; className?: string; onClick?: (e: React.MouseEvent) => void }) => (
  <div
    className={`backdrop-blur-xl ${className}`}
    onClick={onClick}
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
      const r1 = isHour ? 83 : 88;
      const r2 = 96;
      result.push({
        x1: 112 + r1 * Math.cos(angle),
        y1: 112 + r1 * Math.sin(angle),
        x2: 112 + r2 * Math.cos(angle),
        y2: 112 + r2 * Math.sin(angle),
        isHour,
        key: i,
      });
    }
    return result;
  }, []);

  return (
    <svg className="absolute inset-0 w-full h-full -rotate-90" viewBox="0 0 224 224">
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

function ProgressRing({ progress, status }: { progress: number; status: string }) {
  const r = 96;
  const circumference = 2 * Math.PI * r;
  const strokeDashoffset = circumference * (1 - progress / 100);

  const strokeColor = useMemo(() => {
    switch (status) {
      case 'completed': return '#10b981';
      case 'paused': return 'rgba(230, 57, 70, 0.5)';
      default: return SWISS_RED;
    }
  }, [status]);

  return (
    <svg className="absolute inset-0 w-full h-full -rotate-90" viewBox="0 0 224 224">
      <circle
        cx="112"
        cy="112"
        r={r}
        fill="none"
        stroke="rgba(0,0,0,0.04)"
        strokeWidth="5"
      />
      <motion.circle
        cx="112"
        cy="112"
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

function PulsingGlow({ status, children }: { status: string; children: React.ReactNode }) {
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

function formatTime(seconds: number): string {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
}

interface TimerPageProps {
  preset: Preset;
  onInsertAfter: () => void;
}

interface StatsPageProps {
  onClose: () => void;
  onInsert: () => void;
}

function StatsPage({ onClose, onInsert }: StatsPageProps) {
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/20"
      onClick={onClose}
    >
      <GlassCard className="mx-4 p-6 rounded-3xl w-full max-w-xs" onClick={e => e.stopPropagation()}>
        <h2 className="text-lg font-medium text-black/60 uppercase tracking-[0.2em] text-center">今日统计</h2>
        <div className="mt-6 space-y-4">
          <div className="flex justify-between items-center">
            <span className="text-sm text-black/40">完成次数</span>
            <span className="text-lg font-semibold text-black/60">-</span>
          </div>
          <div className="flex justify-between items-center">
            <span className="text-sm text-black/40">累计计时</span>
            <span className="text-lg font-semibold text-black/60">-</span>
          </div>
          <div className="flex justify-between items-center">
            <span className="text-sm text-black/40">暂停次数</span>
            <span className="text-lg font-semibold text-black/60">-</span>
          </div>
        </div>
        <div className="mt-8 flex flex-col gap-2">
          <button
            onClick={onInsert}
            className="w-full py-3 rounded-full font-medium text-sm text-white tracking-widest uppercase"
            style={{ background: SWISS_RED }}
          >
            插入新预设
          </button>
          <button
            onClick={onClose}
            className="w-full py-3 rounded-full font-medium text-sm text-black/40 tracking-widest uppercase"
          >
            关闭
          </button>
        </div>
      </GlassCard>
    </motion.div>
  );
}

interface EditModalProps {
  onClose: () => void;
}

function EditModal({ onClose }: EditModalProps) {
  const { timerType, targetSeconds, setDefaultCountdownMinutes } = useTimerStore();
  const [type, setType] = useState<'countdown' | 'countup'>(timerType);
  const [minutes, setMinutes] = useState(Math.floor(targetSeconds / 60).toString());
  const [isDefault, setIsDefault] = useState(false);

  const handleSave = async () => {
    const mins = parseInt(minutes, 10);
    if (mins > 0) {
      await setDefaultCountdownMinutes(mins);
    }
    onClose();
  };

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/20"
      onClick={onClose}
    >
      <GlassCard className="mx-4 p-6 rounded-3xl w-full max-w-xs" onClick={e => e.stopPropagation()}>
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-lg font-medium text-black/60 uppercase tracking-[0.2em]">编辑</h2>
          <button onClick={onClose} className="text-black/30 hover:text-black/50">
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <div className="space-y-5">
          <div>
            <label className="text-xs text-black/40 uppercase tracking-widest">类型</label>
            <div className="mt-2 flex gap-2">
              <button
                onClick={() => setType('countdown')}
                className={`flex-1 py-2.5 rounded-full text-xs tracking-widest uppercase transition-colors ${
                  type === 'countdown'
                    ? 'text-white'
                    : 'text-black/40 bg-black/5'
                }`}
                style={{ background: type === 'countdown' ? SWISS_RED : 'transparent' }}
              >
                倒计时
              </button>
              <button
                onClick={() => setType('countup')}
                className={`flex-1 py-2.5 rounded-full text-xs tracking-widest uppercase transition-colors ${
                  type === 'countup'
                    ? 'text-white'
                    : 'text-black/40 bg-black/5'
                }`}
                style={{ background: type === 'countup' ? SWISS_RED : 'transparent' }}
              >
                正计时
              </button>
            </div>
          </div>

          <div>
            <label className="text-xs text-black/40 uppercase tracking-widest">时长 (分钟)</label>
            <input
              type="number"
              value={minutes}
              onChange={(e) => setMinutes(e.target.value)}
              className="mt-2 w-full py-3 px-4 rounded-xl text-center text-lg bg-black/5 outline-none focus:bg-black/10 transition-colors"
            />
          </div>

          <label className="flex items-center gap-3 cursor-pointer">
            <div
              className={`w-5 h-5 rounded-full border-2 flex items-center justify-center transition-colors ${
                isDefault ? 'border-transparent' : 'border-black/20'
              }`}
              style={{ background: isDefault ? SWISS_RED : 'transparent' }}
              onClick={() => setIsDefault(!isDefault)}
            >
              {isDefault && (
                <svg className="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                </svg>
              )}
            </div>
            <span className="text-sm text-black/60">设为默认</span>
          </label>
        </div>

        <div className="mt-8">
          <button
            onClick={handleSave}
            className="w-full py-3 rounded-full font-medium text-sm text-white tracking-widest uppercase"
            style={{ background: SWISS_RED }}
          >
            保存
          </button>
        </div>
      </GlassCard>
    </motion.div>
  );
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

  const longPressTimer = useRef<number | null>(null);
  const longPressDuration = 1000;
  const clickTimer = useRef<number | null>(null);
  const clickDelay = 300;
  const spaceDownTime = useRef<number>(0);
  const lastSpaceTap = useRef<number>(0);

  useEffect(() => {
    init();
  }, [init]);

  useEffect(() => {
    if (preset) {
      applyPreset(preset);
    }
  }, [preset, applyPreset]);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.code !== 'Space' || showStats || showEdit) return;
      e.preventDefault();

      if (e.repeat) return;
      spaceDownTime.current = Date.now();

      longPressTimer.current = window.setTimeout(() => {
        if (status === 'idle') {
          setShowStats(true);
        } else if (status === 'running' || status === 'paused') {
          reset();
        }
        spaceDownTime.current = 0;
      }, longPressDuration);
    };

    const handleKeyUp = (e: KeyboardEvent) => {
      if (e.code !== 'Space') return;
      e.preventDefault();

      if (longPressTimer.current) {
        clearTimeout(longPressTimer.current);
        longPressTimer.current = null;
      }

      const holdDuration = Date.now() - spaceDownTime.current;
      spaceDownTime.current = 0;

      if (holdDuration >= longPressDuration) return;

      const now = Date.now();
      if (now - lastSpaceTap.current < clickDelay) {
        if (clickTimer.current) {
          clearTimeout(clickTimer.current);
          clickTimer.current = null;
        }
        if (status === 'idle') {
          setShowEdit(true);
        }
        lastSpaceTap.current = 0;
        return;
      }
      lastSpaceTap.current = now;

      clickTimer.current = window.setTimeout(() => {
        clickTimer.current = null;
        triggerClick();
      }, clickDelay);
    };

    window.addEventListener('keydown', handleKeyDown);
    window.addEventListener('keyup', handleKeyUp);
    return () => {
      window.removeEventListener('keydown', handleKeyDown);
      window.removeEventListener('keyup', handleKeyUp);
    };
  }, [showStats, showEdit, status, reset]);

  useEffect(() => {
    let interval: number | null = null;
    if (status === 'running') {
      interval = window.setInterval(() => {
        tick();
      }, 1000);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [status, tick]);

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

  const triggerClick = () => {
    if (status === 'idle') {
      start();
    } else if (status === 'running') {
      pause();
    } else if (status === 'paused') {
      resume();
    }
  };

  const handleClick = () => {
    if (clickTimer.current) {
      clearTimeout(clickTimer.current);
      clickTimer.current = null;
    }
    clickTimer.current = window.setTimeout(() => {
      clickTimer.current = null;
      triggerClick();
    }, clickDelay);
  };

  const handleDoubleClick = () => {
    if (clickTimer.current) {
      clearTimeout(clickTimer.current);
      clickTimer.current = null;
    }
    if (status === 'idle') {
      setShowEdit(true);
    }
  };

  const handleLongPressStart = useCallback(() => {
    longPressTimer.current = window.setTimeout(() => {
      if (status === 'idle') {
        setShowStats(true);
      } else if (status === 'running') {
        reset();
      } else if (status === 'paused') {
        reset();
      }
    }, longPressDuration);
  }, [status, reset]);

  const handleLongPressEnd = useCallback(() => {
    if (longPressTimer.current) {
      clearTimeout(longPressTimer.current);
      longPressTimer.current = null;
    }
    if (clickTimer.current) {
      clearTimeout(clickTimer.current);
      clickTimer.current = null;
    }
  }, []);

  const isMinimalMode = status === 'running' || status === 'paused';

  return (
    <div className="min-h-screen bg-[#f5f5f5] flex flex-col">
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div
          className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px]"
          style={{
            background: 'radial-gradient(circle, rgba(230,57,70,0.06) 0%, transparent 70%)',
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
            onClick={handleClick}
            onDoubleClick={handleDoubleClick}
            onMouseDown={handleLongPressStart}
            onMouseUp={handleLongPressEnd}
            onMouseLeave={handleLongPressEnd}
            onTouchStart={handleLongPressStart}
            onTouchEnd={handleLongPressEnd}
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
          <h2 className="text-sm font-medium text-black/40 uppercase tracking-[0.3em]">{preset?.name || 'Timer'}</h2>
          <p className="text-xs text-black/25 mt-0.5 tracking-widest text-center">
            {timerType === 'countdown' ? '倒计时' : '正计时'}
          </p>
        </GlassCard>
      </div>

      <AnimatePresence>
        {showStats && (
          <StatsPage
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
          <EditModal
            onClose={() => setShowEdit(false)}
          />
        )}
      </AnimatePresence>
    </div>
  );
}