import { debounce, Cancelable } from "lodash";
import { useCallback, DependencyList } from "react";

export const useDebounce = <T extends (...args: any[]) => any>(
  func: T,
  delay: number,
  deps: DependencyList
): T & Cancelable => {
  return useCallback(debounce(func, delay), deps);
};
