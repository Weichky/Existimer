import { useState } from 'react';
import { motion } from 'framer-motion';
import { GlassCard } from '../GlassCard';
import { SWISS_RED } from '../../constants/timer';
import { useTimerStore } from '../../store/timerStore';

interface EditModalProps {
  onClose: () => void;
}

export function EditModal({ onClose }: EditModalProps) {
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
      <GlassCard
        className="mx-4 p-6 rounded-3xl w-full max-w-xs"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-lg font-medium text-black/60 uppercase tracking-[0.2em]">
            编辑
          </h2>
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
                className="flex-1 py-2.5 rounded-full text-xs tracking-widest uppercase transition-colors"
                style={{
                  background: type === 'countdown' ? SWISS_RED : 'transparent',
                  color: type === 'countdown' ? 'white' : 'rgba(0,0,0,0.4)',
                }}
              >
                倒计时
              </button>
              <button
                onClick={() => setType('countup')}
                className="flex-1 py-2.5 rounded-full text-xs tracking-widest uppercase transition-colors"
                style={{
                  background: type === 'countup' ? SWISS_RED : 'transparent',
                  color: type === 'countup' ? 'white' : 'rgba(0,0,0,0.4)',
                }}
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