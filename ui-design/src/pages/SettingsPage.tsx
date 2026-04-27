import { useTranslation } from 'react-i18next';

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

export function SettingsPage() {
  const { t } = useTranslation();

  return (
    <div className="min-h-screen bg-[#f5f5f5]">
      <div className="absolute inset-0 overflow-hidden">
        <div 
          className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px]"
          style={{
            background: 'radial-gradient(circle, rgba(230,57,70,0.06) 0%, transparent 70%)',
          }}
        />
      </div>

      <div className="relative z-10 p-4">
        <div className="p-6 mb-4">
          <GlassCard className="rounded-2xl p-6">
            <h1 className="text-2xl font-bold tracking-tight text-black">{t('settings.title')}</h1>
            <p className="text-sm text-black/40 mt-1 tracking-wider">{t('settings.subtitle')}</p>
          </GlassCard>
        </div>

        <div className="p-4 space-y-4 max-w-lg mx-auto">
          <section>
            <h3 className="text-xs font-semibold text-black/30 uppercase tracking-widest mb-3 px-2">{t('settings.dataManagement')}</h3>
            <div className="space-y-2">
              <GlassCard className="rounded-xl p-4 cursor-pointer hover:bg-white/80 transition-colors">
                <span className="font-medium text-black tracking-wide">{t('settings.exportJson')}</span>
                <p className="text-xs text-black/30 mt-1">{t('settings.exportJsonDesc')}</p>
              </GlassCard>
              <GlassCard className="rounded-xl p-4 cursor-pointer hover:bg-white/80 transition-colors">
                <span className="font-medium text-black tracking-wide">{t('settings.exportCsv')}</span>
                <p className="text-xs text-black/30 mt-1">{t('settings.exportCsvDesc')}</p>
              </GlassCard>
            </div>
          </section>

          <section>
            <h3 className="text-xs font-semibold text-black/30 uppercase tracking-widest mb-3 px-2">{t('settings.statistics')}</h3>
            <GlassCard className="rounded-xl p-5 space-y-4">
              <div className="flex justify-between items-center">
                <span className="text-black/50 text-sm tracking-wide">{t('settings.totalSessions')}</span>
                <span className="font-semibold text-black">42</span>
              </div>
              <div className="h-px bg-black/5" />
              <div className="flex justify-between items-center">
                <span className="text-black/50 text-sm tracking-wide">{t('settings.totalDuration')}</span>
                <span className="font-semibold text-black">48.5h</span>
              </div>
              <div className="h-px bg-black/5" />
              <div className="flex justify-between items-center">
                <span className="text-black/50 text-sm tracking-wide">{t('settings.longestSession')}</span>
                <span className="font-semibold text-black">120min</span>
              </div>
            </GlassCard>
          </section>

          <section>
            <h3 className="text-xs font-semibold text-black/30 uppercase tracking-widest mb-3 px-2">{t('settings.about')}</h3>
            <GlassCard className="rounded-xl p-5">
              <p className="text-black/50 text-sm leading-relaxed tracking-wide">
                {t('settings.aboutDesc')}
              </p>
              <p className="text-black/20 text-xs mt-4 tracking-widest">
                v0.1.0
              </p>
            </GlassCard>
          </section>
        </div>
      </div>
    </div>
  );
}
