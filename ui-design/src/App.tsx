import { useState, useEffect } from 'react';
import { useNavigationStore } from './store/navigationStore';
import { TimerPage } from './pages/TimerPage';
import { HistoryPage } from './pages/HistoryPage';
import { SettingsPage } from './pages/SettingsPage';

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

function App() {
  const { currentPage, navigate } = useNavigationStore();
  const [hoveringLeft, setHoveringLeft] = useState(false);
  const [hoveringRight, setHoveringRight] = useState(false);
  const [hoveringTop, setHoveringTop] = useState(false);
  const [hoveringBottom, setHoveringBottom] = useState(false);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'ArrowLeft') {
        navigate({ type: 'horizontal', delta: -1 });
      } else if (e.key === 'ArrowRight') {
        navigate({ type: 'horizontal', delta: 1 });
      } else if (e.key === 'ArrowUp') {
        navigate({ type: 'vertical', delta: -1 });
      } else if (e.key === 'ArrowDown') {
        navigate({ type: 'vertical', delta: 1 });
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [navigate]);

  const renderPage = () => {
    switch (currentPage.name) {
      case 'Timer':
      case 'Timer35':
      case 'Timer90':
      case 'TimerCountup':
      case 'TimerCustom1':
      case 'TimerCustom2':
        return <TimerPage presetName={currentPage.name} />;
      case 'History':
        return <HistoryPage />;
      case 'Settings':
        return <SettingsPage />;
      default:
        return <TimerPage presetName="Timer35" />;
    }
  };

  const EdgeNav = ({ 
    position, 
    direction, 
    isHovering, 
    setHovering,
    axis
  }: { 
    position: string;
    direction: 'left' | 'right' | 'top' | 'bottom';
    isHovering: boolean;
    setHovering: (v: boolean) => void;
    axis: 'horizontal' | 'vertical';
  }) => {
    const isVertical = direction === 'top' || direction === 'bottom';
    const isLeft = direction === 'left';
    const isTop = direction === 'top';

    return (
      <div
        className={`fixed ${position} z-50 flex ${isVertical ? 'flex-col' : 'flex-row'} items-center justify-center transition-all duration-200 cursor-pointer`}
        style={{
          width: isVertical ? '100%' : (isHovering ? '32px' : '12px'),
          height: isVertical ? (isHovering ? '32px' : '12px') : '100%',
          background: isHovering ? 'rgba(255,255,255,0.85)' : 'transparent',
          backdropFilter: isHovering ? 'blur(16px)' : 'none',
        }}
        onMouseEnter={() => setHovering(true)}
        onMouseLeave={() => setHovering(false)}
        onClick={() => navigate({ type: axis, delta: (isLeft || isTop) ? -1 : 1 })}
      >
        <div
          className="transition-all duration-200"
          style={{
            width: isVertical ? '28px' : (isHovering ? '20px' : '8px'),
            height: isVertical ? (isHovering ? '20px' : '8px') : '28px',
            opacity: isHovering ? 1 : 0.3,
          }}
        >
          {direction === 'left' && (
            <svg className="w-full h-full" viewBox="0 0 28 28" fill="none">
              <path d="M20 6L10 14L20 22" stroke={SWISS_RED} strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          )}
          {direction === 'right' && (
            <svg className="w-full h-full" viewBox="0 0 28 28" fill="none">
              <path d="M8 6L18 14L8 22" stroke={SWISS_RED} strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          )}
          {direction === 'top' && (
            <svg className="w-full h-full" viewBox="0 0 28 28" fill="none">
              <path d="M6 20L14 10L22 20" stroke={SWISS_RED} strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          )}
          {direction === 'bottom' && (
            <svg className="w-full h-full" viewBox="0 0 28 28" fill="none">
              <path d="M6 8L14 18L22 8" stroke={SWISS_RED} strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          )}
        </div>
      </div>
    );
  };

  return (
    <main className="h-screen w-full overflow-auto" style={{ background: '#f5f5f5' }}>
      {renderPage()}
      
      <EdgeNav
        position="left-0 top-0 h-full"
        direction="left"
        isHovering={hoveringLeft}
        setHovering={setHoveringLeft}
        axis="horizontal"
      />
      <EdgeNav
        position="right-0 top-0 h-full"
        direction="right"
        isHovering={hoveringRight}
        setHovering={setHoveringRight}
        axis="horizontal"
      />
      <EdgeNav
        position="top-0 left-0 w-full"
        direction="top"
        isHovering={hoveringTop}
        setHovering={setHoveringTop}
        axis="vertical"
      />
      <EdgeNav
        position="bottom-0 left-0 w-full"
        direction="bottom"
        isHovering={hoveringBottom}
        setHovering={setHoveringBottom}
        axis="vertical"
      />

      <div className="fixed bottom-3 left-1/2 -translate-x-1/2 z-40">
        <GlassCard className="px-5 py-2.5 rounded-full">
          <span className="text-sm font-medium tracking-widest uppercase" style={{ color: SWISS_RED }}>
            {currentPage.name}
          </span>
        </GlassCard>
      </div>
    </main>
  );
}

export default App;
