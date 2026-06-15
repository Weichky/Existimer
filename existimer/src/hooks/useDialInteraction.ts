import { useRef, useCallback, useEffect } from 'react';
import { TIMING } from '../constants/timer';

interface DialInteractionHandlers {
  onSingleTap: () => void;
  onDoubleTap: () => void;
  onLongPress: () => void;
}

interface DialInteractionOptions {
  disabled?: boolean;
}

export function useDialInteraction(
  { onSingleTap, onDoubleTap, onLongPress }: DialInteractionHandlers,
  { disabled }: DialInteractionOptions
) {
  const clickTimer = useRef<number | null>(null);
  const longPressTimer = useRef<number | null>(null);
  const lastTapTime = useRef<number>(0);
  const spaceDownTime = useRef<number>(0);

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

  const forceClearAllTimers = useCallback(() => {
    if (clickTimer.current) {
      clearTimeout(clickTimer.current);
      clickTimer.current = null;
    }
    if (longPressTimer.current) {
      clearTimeout(longPressTimer.current);
      longPressTimer.current = null;
    }
    lastTapTime.current = 0;
  }, []);

  const handleMouseDown = useCallback(() => {
    if (disabled) return;
    clearTimers();
    longPressTimer.current = window.setTimeout(() => {
      onLongPress();
      longPressTimer.current = null;
    }, TIMING.LONG_PRESS_DURATION);
  }, [disabled, clearTimers, onLongPress]);

  const handleMouseUp = useCallback(() => {
    if (disabled) return;
    if (longPressTimer.current) {
      clearTimeout(longPressTimer.current);
      longPressTimer.current = null;
    }
  }, [disabled]);

  const handleClick = useCallback(() => {
    if (disabled) return;
    clearTimers();

    const now = Date.now();
    if (now - lastTapTime.current < TIMING.CLICK_DELAY) {
      lastTapTime.current = 0;
      onDoubleTap();
      return;
    }

    lastTapTime.current = now;
    clickTimer.current = window.setTimeout(() => {
      clickTimer.current = null;
      onSingleTap();
    }, TIMING.CLICK_DELAY);
  }, [disabled, clearTimers, onSingleTap, onDoubleTap]);

  useEffect(() => {
    if (disabled) return;

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.code !== 'Space') return;
      e.preventDefault();
      if (e.repeat) return;

      spaceDownTime.current = Date.now();
      clearTimers();

      longPressTimer.current = window.setTimeout(() => {
        onLongPress();
        spaceDownTime.current = 0;
        longPressTimer.current = null;
      }, TIMING.LONG_PRESS_DURATION);
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

      if (holdDuration >= TIMING.LONG_PRESS_DURATION) return;

      const now = Date.now();
      if (now - lastTapTime.current < TIMING.CLICK_DELAY) {
        if (clickTimer.current) {
          clearTimeout(clickTimer.current);
          clickTimer.current = null;
        }
        lastTapTime.current = 0;
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
  }, [disabled, clearTimers, onSingleTap, onDoubleTap, onLongPress]);

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
    clearTimers,
    forceClearAllTimers,
  };
}