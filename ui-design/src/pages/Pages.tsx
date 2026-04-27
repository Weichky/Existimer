import type { ReactNode } from 'react';

interface PageProps {
  name: string;
  index: number;
}

export function TimerAPage({ index }: PageProps): ReactNode {
  return (
    <div className="flex flex-col items-center justify-center h-full bg-red-50">
      <h1 className="text-3xl font-bold mb-4 text-red-600">Timer A{index}</h1>
      <p className="text-gray-600">A Index: {index}</p>
      <div className="text-8xl mt-4">{index}</div>
    </div>
  );
}

export function HistoryBPage({ index }: PageProps): ReactNode {
  return (
    <div className="flex flex-col items-center justify-center h-full bg-green-50">
      <h1 className="text-3xl font-bold mb-4 text-green-600">History B{index}</h1>
      <p className="text-gray-600">B Index: {index}</p>
      <div className="text-8xl mt-4">{index}</div>
    </div>
  );
}

export function SettingsCPage({ index }: PageProps): ReactNode {
  return (
    <div className="flex flex-col items-center justify-center h-full bg-purple-50">
      <h1 className="text-3xl font-bold mb-4 text-purple-600">Settings C{index}</h1>
      <p className="text-gray-600">C Index: {index}</p>
      <div className="text-8xl mt-4">{index}</div>
    </div>
  );
}

export type PageComponent = (props: PageProps) => ReactNode;