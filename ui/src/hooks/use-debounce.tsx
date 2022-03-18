import type { DebouncedFunc } from "lodash";
import debounce from "lodash/debounce";
import { useCallback, DependencyList } from "react";

export const useDebounce = <T extends (...args: any[]) => any>(
  func: T,
  delay: number,
  deps: DependencyList
): DebouncedFunc<T> => {
  return useCallback(debounce(func, delay), deps);
};
