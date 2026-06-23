interface DialOverlayProps {
  visible: boolean;
}

export function DialOverlay({ visible }: DialOverlayProps) {
  const size = 260;
  const glowSize = size * 0.85;

  return (
    <>
      <div
        className="absolute pointer-events-none rounded-full"
        style={{
          width: size,
          height: size,
          left: '50%',
          top: '50%',
          transform: 'translate(-50%, -50%)',
          zIndex: 0,
          background: 'rgba(255, 255, 255, 0.4)',
          backdropFilter: 'blur(16px)',
        }}
      />

      <div
        className="absolute pointer-events-none rounded-full"
        style={{
          width: glowSize,
          height: glowSize,
          left: '50%',
          top: '50%',
          transform: 'translate(-50%, -50%)',
          zIndex: 1,
          background: 'transparent',
          boxShadow: '0 0 30px rgba(230,57,70,0.35), 0 0 60px rgba(230,57,70,0.2)',
          opacity: visible ? 1 : 0,
        }}
      />
    </>
  );
}