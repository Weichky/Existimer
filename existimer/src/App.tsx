import { useState, useEffect } from 'react';
import { useNavigationStore } from './store/navigationStore';
import { useTimerStore } from './store/timerStore';
import { TimerPage } from './pages/TimerPage';

function App() {
  const {
    presets,
    horizontalIndex,
    currentPage,
    initialized,
    init,
    navigateHorizontal,
    navigateVertical,
    insertPresetAfterCurrent,
  } = useNavigationStore();
  const { defaultCountdownMinutes } = useTimerStore();

  const [hoveringLeft, setHoveringLeft] = useState(false);
  const [hoveringRight, setHoveringRight] = useState(false);
  const [hoveringTop, setHoveringTop] = useState(false);
  const [hoveringBottom, setHoveringBottom] = useState(false);

  useEffect(() => {
    init();
  }, [init]);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'ArrowLeft') {
        navigateHorizontal(-1);
      } else if (e.key === 'ArrowRight') {
        navigateHorizontal(1);
      } else if (e.key === 'ArrowUp') {
        navigateVertical(-1);
      } else if (e.key === 'ArrowDown') {
        navigateVertical(1);
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [navigateHorizontal, navigateVertical]);

  const currentPreset = presets[horizontalIndex];

  const renderPage = () => {
    if (!initialized) {
      return <div style={{ padding: 20 }}>Loading...</div>;
    }

    switch (currentPage.name) {
      case 'Timer':
        return <TimerPage preset={currentPreset} onInsertAfter={() => {
          insertPresetAfterCurrent({
            id: '',
            name: 'New',
            timer_type: 'countdown',
            target_seconds: defaultCountdownMinutes * 60,
            position: 0,
            created_at: null,
            updated_at: null,
          });
        }} />;
      case 'History':
        return <div style={{ padding: 20 }}>History (待实现)</div>;
      case 'Settings':
        return <div style={{ padding: 20 }}>Settings (待实现)</div>;
      default:
        return <TimerPage preset={currentPreset} onInsertAfter={() => {
          insertPresetAfterCurrent({
            id: '',
            name: 'New',
            timer_type: 'countdown',
            target_seconds: defaultCountdownMinutes * 60,
            position: 0,
            created_at: null,
            updated_at: null,
          });
        }} />;
    }
  };

  const EdgeNav = ({
    position,
    direction,
    isHovering,
    setHovering,
    onClick,
  }: {
    position: string;
    direction: 'left' | 'right' | 'top' | 'bottom';
    isHovering: boolean;
    setHovering: (v: boolean) => void;
    onClick: () => void;
  }) => {
    const isVertical = direction === 'top' || direction === 'bottom';

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
        onClick={onClick}
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
              <path d="M20 6L10 14L20 22" stroke="#E63946" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          )}
          {direction === 'right' && (
            <svg className="w-full h-full" viewBox="0 0 28 28" fill="none">
              <path d="M8 6L18 14L8 22" stroke="#E63946" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          )}
          {direction === 'top' && (
            <svg className="w-full h-full" viewBox="0 0 28 28" fill="none">
              <path d="M6 20L14 10L22 20" stroke="#E63946" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          )}
          {direction === 'bottom' && (
            <svg className="w-full h-full" viewBox="0 0 28 28" fill="none">
              <path d="M6 8L14 18L22 8" stroke="#E63946" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"/>
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
        onClick={() => navigateHorizontal(-1)}
      />
      <EdgeNav
        position="right-0 top-0 h-full"
        direction="right"
        isHovering={hoveringRight}
        setHovering={setHoveringRight}
        onClick={() => navigateHorizontal(1)}
      />
      <EdgeNav
        position="top-0 left-0 w-full"
        direction="top"
        isHovering={hoveringTop}
        setHovering={setHoveringTop}
        onClick={() => navigateVertical(-1)}
      />
      <EdgeNav
        position="bottom-0 left-0 w-full"
        direction="bottom"
        isHovering={hoveringBottom}
        setHovering={setHoveringBottom}
        onClick={() => navigateVertical(1)}
      />
    </main>
  );
}

export default App;