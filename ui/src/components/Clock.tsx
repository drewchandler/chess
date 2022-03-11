import React, { FunctionComponent, useState, useEffect } from "react";
import { useInterval } from "../hooks/use-interval";
import padStart from "lodash/padStart";

const COUNTDOWN_INTEVAL = 200;

interface Props {
  time: number;
  shouldCountdown: boolean;
}

export const Clock: FunctionComponent<Props> = ({ time, shouldCountdown }) => {
  const [clientTime, setClientTime] = useState(time);
  useInterval(
    () => setClientTime((previous) => previous - COUNTDOWN_INTEVAL),
    shouldCountdown ? COUNTDOWN_INTEVAL : undefined
  );
  useEffect(() => setClientTime(time), [time, shouldCountdown]);

  return <div>{formatTime(clientTime)}</div>;
};

const formatTime = (time: number): string => {
  const minutesString = padStart("" + Math.trunc(time / (60 * 1000)), 2, "0");
  const seconds = (time % (60 * 1000)) / 1000;
  const secondsString = padStart("" + Math.trunc(seconds), 2, "0");
  const millisString = "" + Math.trunc((seconds % 1) * 10);

  return `${minutesString}:${secondsString}.${millisString}`;
};
