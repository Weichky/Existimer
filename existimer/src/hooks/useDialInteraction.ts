import { useRef, useCallback, useEffect, useState } from 'react';
import { TIMING } from '../constants/timer';

interface DialAnimationState {
  isPressed: boolean;
  isLongPressing: boolean;
  longPressProgress: number;
  showDoubleTapFeedback: boolean;
}

interface DialInteractionHandlers {
  onSingleTap: () => void;
  onDoubleTap: () => void;
  onLongPress: () => void;
}

export function useDialInteraction(
  { onSingleTap, onDoubleTap, onLongPress }: DialInteractionHandlers,
  { disabled }: { disabled?: boolean }
) {
  const clickTimer = useRef<number | null>(null);
  const longPressTimer = useRef<number | null>(null);
  const longPressStartTime = useRef<number | null>(null);
  const lastTapTime = useRef<number>(0);
  const spaceDownTime = useRef<number>(0);

  const [animationState, setAnimationState] = useState<DialAnimationState>({
    isPressed: false,
    isLongPressing: false,
    longPressProgress: 0,
    showDoubleTapFeedback: false,
  });

  const clearTimers = useCallback(() => {
    if (clickTimer.current) {
      clearTimeout(clickTimer.current);
      clickTimer.current = null;
    }
    if (longPressTimer.current) {
      clearTimeout(longPressTimer.current);
      longPressTimer.current = null;
    }
  }, []);

  const resetAnimation = useCallback(() => {
    setAnimationState({
      isPressed: false,
      isLongPressing: false,
      longPressProgress: 0,
      showDoubleTapFeedback: false,
    });
    longPressStartTime.current = null;
  }, []);

  const startLongPressProgress = useCallback(() => {
    if (longPressStartTime.current !== null) return;
    
    longPressStartTime.current = Date.now();
    setAnimationState(prev => ({ ...prev, isLongPressing: true }));

    const tick = () => {
      if (longPressStartTime.current === null) return;
      
      const elapsed = Date.now() - longPressStartTime.current;
      const progress = Math.min(elapsed / TIMING.LONG_PRESS_DURATION, 1);
      setAnimationState(prev => ({ ...prev, longPressProgress: progress }));

      if (progress < 1) {
        requestAnimationFrame(tick);
      }
    };
    requestAnimationFrame(tick);
  }, []);

  const handleMouseDown = useCallback(() => {
    if (disabled) return;
    clearTimers();
    setAnimationState(prev => ({ ...prev, isPressed: true }));

    startLongPressProgress();

    longPressTimer.current = window.setTimeout(() => {
      if (longPressStartTime.current !== null) {
        setAnimationState(prev => ({ ...prev, longPressProgress: 1 }));
      }
      onLongPress();
      longPressStartTime.current = null;
      longPressTimer.current = null;
    }, TIMING.LONG_PRESS_DURATION);
  }, [disabled, clearTimers, startLongPressProgress, onLongPress]);

  const handleMouseUp = useCallback(() => {
    if (disabled) return;
    clearTimers();

    if (longPressTimer.current) {
      clearTimeout(longPressTimer.current);
      longPressTimer.current = null;
    }

    setAnimationState(prev => ({ 
      ...prev, 
      isPressed: false,
      isLongPressing: false,
    }));

    longPressStartTime.current = null;
  }, [disabled, clearTimers]);

  const handleClick = useCallback(() => {
    if (disabled) return;
    clearTimers();

    const now = Date.now();
    if (now - lastTapTime.current < TIMING.CLICK_DELAY) {
      lastTapTime.current = 0;
      setAnimationState(prev => ({ ...prev, showDoubleTapFeedback: true }));
      setTimeout(() => setAnimationState(prev => ({ ...prev, showDoubleTapFeedback: false })), 200);
      onDoubleTap();
      return;
    }

    lastTapTime.current = now;
    clickTimer.current = window.setTimeout(() => {
      clickTimer.current = null;
      if (!disabled) {
        onSingleTap();
      }
    }, TIMING.CLICK_DELAY);
  }, [disabled, clearTimers, onSingleTap, onDoubleTap]);

  useEffect(() => {
    if (disabled) {
      clearTimers();
      resetAnimation();
      return;
    }

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.code !== 'Space') return;
      e.preventDefault();
      if (e.repeat) return;

      spaceDownTime.current = Date.now();
      clearTimers();
      setAnimationState(prev => ({ ...prev, isPressed: true }));

      startLongPressProgress();

      longPressTimer.current = window.setTimeout(() => {
        if (longPressStartTime.current !== null) {
          setAnimationState(prev => ({ ...prev, longPressProgress: 1 }));
        }
        onLongPress();
        longPressStartTime.current = null;
        longPressTimer.current = null;
      }, TIMING.LONG_PRESS_DURATION);
    };

    const handleKeyUp = (e: KeyboardEvent) => {
      if (e.code !== 'Space') return;
      e.preventDefault();

      clearTimers();

      if (longPressTimer.current) {
        clearTimeout(longPressTimer.current);
        longPressTimer.current = null;
      }

      setAnimationState(prev => ({ 
        ...prev, 
        isPressed: false,
        isLongPressing: false,
      }));

      longPressStartTime.current = null;

      const holdDuration = Date.now() - spaceDownTime.current;
      spaceDownTime.current = 0;

      if (holdDuration >= TIMING.LONG_PRESS_DURATION) return;

      const now = Date.now();
      if (now - lastTapTime.current < TIMING.CLICK_DELAY) {
        if (clickTimer.current) {
          clearTimeout(clickTimer.current);
          clickTimer.current = null;
        }
        lastTapTime.current = 0;
        setAnimationState(prev => ({ ...prev, showDoubleTapFeedback: true }));
        setTimeout(() => setAnimationState(prev => ({ ...prev, showDoubleTapFeedback: false })), 200);
        onDoubleTap();
        return;
      }

      lastTapTime.current = now;
      clickTimer.current = window.setTimeout(() => {
        clickTimer.current = null;
        if (!disabled) {
          onSingleTap();
        }
      }, TIMING.CLICK_DELAY);
    };

    window.addEventListener('keydown', handleKeyDown);
    window.addEventListener('keyup', handleKeyUp);

    return () => {
      window.removeEventListener('keydown', handleKeyDown);
      window.removeEventListener('keyup', handleKeyUp);
    };
  }, [disabled, clearTimers, resetAnimation, onSingleTap, onDoubleTap, startLongPressProgress, onLongPress]);

  useEffect(() => {
    return () => clearTimers();
  }, [clearTimers]);

  return {
    handlers: {
      onClick: handleClick,
      onDoubleClick: handleClick,
      onMouseDown: handleMouseDown,
      onMouseUp: handleMouseUp,
      onMouseLeave: handleMouseUp,
      onTouchStart: handleMouseDown,
      onTouchEnd: handleMouseUp,
    },
    animationState,
    clearTimers,
    resetAnimation,
  };
}