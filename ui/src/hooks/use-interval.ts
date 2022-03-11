import { useEffect, useRef } from "react";

export const useInterval = (
  callback: (...args: any[]) => any,
  delay: number | undefined
) => {
  const savedCallback = useRef<(...args: any[]) => any>();

  useEffect(() => {
    savedCallback.current = callback;
  }, [callback]);

  useEffect(() => {
    function tick() {
      savedCallback.current?.();
    }

    if (delay !== undefined) {
      let id = setInterval(tick, delay);
      return () => clearInterval(id);
    }
  }, [delay]);
};
