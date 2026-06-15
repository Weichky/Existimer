import { COLORS } from '../constants/timer';

interface GlassCardProps {
  children: React.ReactNode;
  className?: string;
  onClick?: (e: React.MouseEvent) => void;
}

export function GlassCard({ children, className = '', onClick }: GlassCardProps) {
  return (
    <div
      className={`backdrop-blur-xl ${className}`}
      onClick={onClick}
      style={{
        background: COLORS.glassBackground,
        border: `1px solid ${COLORS.glassBorder}`,
        boxShadow: COLORS.glassShadow,
      }}
    >
      {children}
    </div>
  );
}