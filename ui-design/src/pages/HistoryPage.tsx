import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, Cell } from 'recharts';

interface Session {
  id: string;
  date: string;
  duration: number;
  eventName: string;
}

const mockSessions: Session[] = [
  { id: '1', date: '2024-01-15', duration: 35 * 60, eventName: 'Writing' },
  { id: '2', date: '2024-01-15', duration: 90 * 60, eventName: 'Reading' },
  { id: '3', date: '2024-01-16', duration: 35 * 60, eventName: 'Coding' },
  { id: '4', date: '2024-01-17', duration: 45 * 60, eventName: 'Writing' },
  { id: '5', date: '2024-01-18', duration: 60 * 60, eventName: 'Reading' },
  { id: '6', date: '2024-01-18', duration: 35 * 60, eventName: 'Coding' },
  { id: '7', date: '2024-01-19', duration: 90 * 60, eventName: 'Writing' },
  { id: '8', date: '2024-01-20', duration: 35 * 60, eventName: 'Coding' },
  { id: '9', date: '2024-01-21', duration: 120 * 60, eventName: 'Reading' },
  { id: '10', date: '2024-01-22', duration: 35 * 60, eventName: 'Writing' },
];

type ViewMode = 'heatmap' | 'barchart';

const SWISS_RED = '#E63946';
const SWISS_RED_RGB = '230, 57, 70';

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

function HeatmapView({ sessions }: { sessions: Session[] }) {
  const weeks = 12;
  const daysPerWeek = 7;
  const cellSize = 14;

  const getIntensity = (dateStr: string) => {
    const daySessions = sessions.filter((s) => s.date === dateStr);
    const totalMinutes = daySessions.reduce((sum, s) => sum + s.duration / 60, 0);
    if (totalMinutes === 0) return 0;
    if (totalMinutes < 30) return 1;
    if (totalMinutes < 60) return 2;
    if (totalMinutes < 120) return 3;
    return 4;
  };

  const getDateString = (weekIndex: number, dayIndex: number) => {
    const today = new Date();
    const startDate = new Date(today);
    startDate.setDate(today.getDate() - (weeks * 7 - 1) + weekIndex * 7 + dayIndex);
    return startDate.toISOString().split('T')[0];
  };

  const intensityColors = [
    'rgba(0,0,0,0.04)', 
    `rgba(${SWISS_RED_RGB},0.25)`, 
    `rgba(${SWISS_RED_RGB},0.45)`, 
    `rgba(${SWISS_RED_RGB},0.7)`, 
    SWISS_RED
  ];

  const dayLabels = ['', 'M', '', 'W', '', 'F', ''];

  return (
    <div className="p-6">
      <div className="flex items-start gap-3">
        <div className="flex flex-col gap-1 text-xs text-black/40 pt-4">
          {dayLabels.map((label, i) => (
            <div key={i} className="h-[14px] flex items-center">
              {label}
            </div>
          ))}
        </div>
        <div>
          <div className="flex gap-[3px] mb-1">
            {Array.from({ length: weeks }).map((_, weekIndex) => (
              <div key={weekIndex} className="w-[14px]" />
            ))}
          </div>
          <div className="flex gap-[3px]">
            {Array.from({ length: weeks }).map((_, weekIndex) => (
              <div key={weekIndex} className="flex flex-col gap-[3px]">
                {Array.from({ length: daysPerWeek }).map((_, dayIndex) => {
                  const dateStr = getDateString(weekIndex, dayIndex);
                  const intensity = getIntensity(dateStr);
                  return (
                    <div
                      key={dayIndex}
                      className="rounded-[3px] transition-all duration-200 cursor-pointer hover:ring-1 hover:ring-black/20"
                      style={{
                        width: cellSize,
                        height: cellSize,
                        backgroundColor: intensityColors[intensity],
                      }}
                      title={`${dateStr}: ${intensity > 0 ? 'Recorded' : 'No records'}`}
                    />
                  );
                })}
              </div>
            ))}
          </div>
        </div>
      </div>
      <div className="flex items-center gap-3 mt-6 ml-8">
        <span className="text-xs text-black/30">Less</span>
        {intensityColors.map((color, i) => (
          <div
            key={i}
            className="w-3.5 h-3.5 rounded-[3px]"
            style={{ backgroundColor: color }}
          />
        ))}
        <span className="text-xs text-black/30">More</span>
      </div>
    </div>
  );
}

function BarChartView({ sessions }: { sessions: Session[] }) {
  const { t } = useTranslation();

  const dailyData = sessions.reduce((acc, session) => {
    const existing = acc.find((d) => d.date === session.date);
    if (existing) {
      existing.duration += session.duration;
    } else {
      acc.push({ date: session.date, duration: session.duration });
    }
    return acc;
  }, [] as { date: string; duration: number }[]);

  const chartData = dailyData.slice(-7).map((d) => ({
    date: new Date(d.date).toLocaleDateString('en', { weekday: 'short', month: 'short', day: 'numeric' }),
    minutes: Math.round(d.duration / 60),
  }));

  return (
    <div className="p-6">
      <div className="h-64">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={chartData} margin={{ top: 10, right: 10, left: -20, bottom: 10 }}>
            <XAxis
              dataKey="date"
              tick={{ fontSize: 10, fill: 'rgba(0,0,0,0.4)' }}
              axisLine={{ stroke: 'rgba(0,0,0,0.08)' }}
              tickLine={false}
            />
            <YAxis
              tick={{ fontSize: 10, fill: 'rgba(0,0,0,0.4)' }}
              axisLine={false}
              tickLine={false}
              tickFormatter={(value) => `${value}m`}
            />
            <Tooltip
              contentStyle={{
                backgroundColor: 'rgba(255,255,255,0.95)',
                backdropFilter: 'blur(12px)',
                border: '1px solid rgba(0,0,0,0.06)',
                borderRadius: '12px',
                color: '#1a1a1a',
                fontSize: '12px',
                boxShadow: '0 4px 16px rgba(0,0,0,0.08)',
              }}
              formatter={(value) => [t('history.minutes', { count: value as number }), 'Duration']}
            />
            <Bar dataKey="minutes" radius={[4, 4, 0, 0]}>
              {chartData.map((_, index) => (
                <Cell key={index} fill={SWISS_RED} />
              ))}
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}

export function HistoryPage() {
  const { t } = useTranslation();
  const [viewMode, setViewMode] = useState<ViewMode>('heatmap');

  return (
    <div className="min-h-screen bg-[#f5f5f5]">
      <div className="absolute inset-0 overflow-hidden">
        <div 
          className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px]"
          style={{
            background: `radial-gradient(circle, rgba(${SWISS_RED_RGB},0.04) 0%, transparent 70%)`,
          }}
        />
      </div>

      <div className="relative z-10">
        <div className="p-6">
          <GlassCard className="rounded-2xl p-6 mb-4">
            <h1 className="text-2xl font-bold tracking-tight text-black">{t('history.title')}</h1>
            <p className="text-sm text-black/40 mt-1 tracking-wider">{t('history.subtitle')}</p>
          </GlassCard>
        </div>

        <div className="flex gap-2 px-4 pb-4">
          <button
            onClick={() => setViewMode('heatmap')}
            className={`px-5 py-2.5 text-sm tracking-widest uppercase transition-all duration-200 rounded-xl ${
              viewMode === 'heatmap'
                ? 'text-white font-medium'
                : 'bg-white/60 backdrop-blur-xl text-black/60 hover:bg-white/80'
            }`}
            style={viewMode === 'heatmap' ? { background: SWISS_RED, boxShadow: '0 2px 8px rgba(230,57,70,0.3)' } : { border: '1px solid rgba(0,0,0,0.06)' }}
          >
            {t('history.heatmap')}
          </button>
          <button
            onClick={() => setViewMode('barchart')}
            className={`px-5 py-2.5 text-sm tracking-widest uppercase transition-all duration-200 rounded-xl ${
              viewMode === 'barchart'
                ? 'text-white font-medium'
                : 'bg-white/60 backdrop-blur-xl text-black/60 hover:bg-white/80'
            }`}
            style={viewMode === 'barchart' ? { background: SWISS_RED, boxShadow: '0 2px 8px rgba(230,57,70,0.3)' } : { border: '1px solid rgba(0,0,0,0.06)' }}
          >
            {t('history.barchart')}
          </button>
        </div>

        <div className="px-4 mb-4">
          <GlassCard className="rounded-2xl overflow-hidden">
            {viewMode === 'heatmap' ? (
              <HeatmapView sessions={mockSessions} />
            ) : (
              <BarChartView sessions={mockSessions} />
            )}
          </GlassCard>
        </div>

        <div className="px-4">
          <GlassCard className="rounded-2xl overflow-hidden">
            <div className="p-4 border-b border-black/5">
              <h3 className="text-xs font-semibold text-black/40 tracking-widest uppercase">{t('history.recentRecords')}</h3>
            </div>
            <div className="divide-y divide-black/5">
              {mockSessions.slice(0, 5).map((session) => (
                <div
                  key={session.id}
                  className="flex justify-between items-center p-4 hover:bg-black/[0.02] transition-colors"
                >
                  <div>
                    <p className="font-medium text-black tracking-wide">{session.eventName}</p>
                    <p className="text-xs text-black/30 mt-0.5">{session.date}</p>
                  </div>
                  <span className="text-sm font-semibold" style={{ color: SWISS_RED }}>
                    {t('history.minutes', { count: Math.round(session.duration / 60) })}
                  </span>
                </div>
              ))}
            </div>
          </GlassCard>
        </div>
      </div>
    </div>
  );
}
