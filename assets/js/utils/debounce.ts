type DebounceableFunction = (...args: any[]) => any;

export interface DebouncedFunction<T extends DebounceableFunction> {
  (...args: Parameters<T>): void;
  cancel(): void;
}

const debounce = <F extends DebounceableFunction>(
  callback: F,
  wait: number
): DebouncedFunction<F> => {
  let timeoutId = null;
  let canceled = false;

  let cancel = () => {
    canceled = true;
  };

  let debounced = Object.assign(
    (...args: Parameters<F>) => {
      window.clearTimeout(timeoutId);
      canceled = false;

      timeoutId = window.setTimeout(() => {
        if (!canceled) {
          callback.apply(null, args);
        }
      }, wait);
    },
    { cancel }
  );

  return debounced;
};

export default debounce;
