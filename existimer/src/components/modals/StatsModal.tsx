import { motion } from 'framer-motion';
import { GlassCard } from '../GlassCard';
import { SWISS_RED } from '../../constants/timer';

interface StatsModalProps {
  onClose: () => void;
  onInsert: () => void;
}

export function StatsModal({ onClose, onInsert }: StatsModalProps) {
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
        <h2 className="text-lg font-medium text-black/60 uppercase tracking-[0.2em] text-center">
          今日统计
        </h2>
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