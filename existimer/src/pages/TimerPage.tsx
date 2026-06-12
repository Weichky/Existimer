import { useState, useEffect } from "react";
import { useTimerStore } from "../store/timerStore";

function formatTime(seconds: number): string {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins.toString().padStart(2, "0")}:${secs.toString().padStart(2, "0")}`;
}

export function TimerPage() {
  const {
    mode,
    status,
    targetSeconds,
    elapsedSeconds,
    pauseCount,
    totalPauseSeconds,
    defaultCountdownMinutes,
    init,
    setMode,
    setDefaultCountdownMinutes,
    start,
    pause,
    resume,
    reset,
    tick,
  } = useTimerStore();

  const [inputMinutes, setInputMinutes] = useState(defaultCountdownMinutes.toString());
  const [currentPauseDuration, setCurrentPauseDuration] = useState(0);

  useEffect(() => {
    init().then(() => {
      setInputMinutes(defaultCountdownMinutes.toString());
    });
  }, [init, defaultCountdownMinutes]);

  useEffect(() => {
    let interval: number | null = null;
    if (status === "running") {
      interval = window.setInterval(() => {
        tick();
      }, 1000);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [status, tick]);

  useEffect(() => {
    let interval: number | null = null;
    if (status === "paused") {
      const pauseStartTime = useTimerStore.getState().pauseStartTime;
      if (pauseStartTime) {
        interval = window.setInterval(() => {
          const elapsed = Math.floor((Date.now() - pauseStartTime) / 1000);
          setCurrentPauseDuration(elapsed);
        }, 100);
      }
    } else {
      setCurrentPauseDuration(0);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [status]);

  const handleSetDefaultMinutes = async () => {
    const mins = parseInt(inputMinutes, 10);
    if (mins > 0) {
      await setDefaultCountdownMinutes(mins);
    }
  };

  const getDisplayTime = () => {
    if (mode === "countdown") {
      const remaining = targetSeconds - elapsedSeconds;
      return formatTime(Math.max(0, remaining));
    }
    return formatTime(elapsedSeconds);
  };

  const progress = mode === "countdown"
    ? Math.max(0, (targetSeconds - elapsedSeconds) / targetSeconds * 100)
    : 100;

  const displayPauseSeconds = status === "paused"
    ? totalPauseSeconds + currentPauseDuration
    : totalPauseSeconds;

  return (
    <div style={{ padding: "20px", maxWidth: "400px", margin: "0 auto" }}>
      <div style={{ marginBottom: "20px" }}>
        <div style={{ marginBottom: "10px", color: "#666" }}>
          <span style={{ marginRight: "10px" }}>倒计时默认分钟:</span>
          <input
            type="number"
            value={inputMinutes}
            onChange={(e) => setInputMinutes(e.target.value)}
            style={{ width: "60px", padding: "4px", marginRight: "8px" }}
          />
          <button onClick={handleSetDefaultMinutes}>设置</button>
        </div>
      </div>

      <div style={{
        display: "flex",
        gap: "10px",
        marginBottom: "20px",
        justifyContent: "center"
      }}>
        <button
          onClick={() => setMode("countdown")}
          style={{
            padding: "8px 16px",
            background: mode === "countdown" ? "#E63946" : "#ccc",
            color: "white",
            border: "none",
            borderRadius: "4px",
            cursor: "pointer"
          }}
        >
          倒计时
        </button>
        <button
          onClick={() => setMode("countup")}
          style={{
            padding: "8px 16px",
            background: mode === "countup" ? "#E63946" : "#ccc",
            color: "white",
            border: "none",
            borderRadius: "4px",
            cursor: "pointer"
          }}
        >
          正向计时
        </button>
      </div>

      <div style={{
        textAlign: "center",
        padding: "40px",
        background: "#f5f5f5",
        borderRadius: "8px",
        marginBottom: "20px"
      }}>
        <div style={{ fontSize: "48px", fontFamily: "monospace", color: "#333" }}>
          {getDisplayTime()}
        </div>
        {mode === "countdown" && status !== "idle" && (
          <div style={{ marginTop: "10px", color: "#666" }}>
            进度: {progress.toFixed(1)}%
          </div>
        )}
        {status === "completed" && (
          <div style={{ marginTop: "10px", color: "#10b981", fontWeight: "bold" }}>
            完成!
          </div>
        )}
      </div>

      <div style={{ display: "flex", gap: "10px", justifyContent: "center" }}>
        {status === "idle" && (
          <button onClick={start} style={buttonStyle}>开始</button>
        )}
        {status === "running" && (
          <button onClick={pause} style={buttonStyle}>暂停</button>
        )}
        {status === "paused" && (
          <button onClick={resume} style={buttonStyle}>继续</button>
        )}
        {(status === "running" || status === "paused" || status === "completed") && (
          <button onClick={reset} style={{...buttonStyle, background: "#666"}}>重置</button>
        )}
      </div>

      {status !== "idle" && (
        <div style={{
          marginTop: "20px",
          padding: "15px",
          background: "#fff",
          borderRadius: "8px",
          display: "flex",
          justifyContent: "space-around"
        }}>
          <div>
            <div style={{ color: "#666", fontSize: "12px" }}>暂停次数</div>
            <div style={{ fontSize: "20px", fontWeight: "bold" }}>{pauseCount}</div>
          </div>
          <div>
            <div style={{ color: "#666", fontSize: "12px" }}>
              {status === "paused" ? "本次暂停" : "累计暂停"}
            </div>
            <div style={{ fontSize: "20px", fontWeight: "bold" }}>{formatTime(displayPauseSeconds)}</div>
          </div>
        </div>
      )}
    </div>
  );
}

const buttonStyle: React.CSSProperties = {
  padding: "12px 24px",
  background: "#E63946",
  color: "white",
  border: "none",
  borderRadius: "4px",
  cursor: "pointer",
  fontSize: "16px"
};