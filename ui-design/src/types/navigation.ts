export type AxisType = 'A' | 'B';

export interface Action {
  type: AxisType;
  delta: number;
}

export interface Page {
  axis: AxisType;
  index: number;
}