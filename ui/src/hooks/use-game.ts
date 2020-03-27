import { useState, useCallback, useEffect } from "react";
import useChannel from "./use-channel";
import { Game } from "../models/Game";

interface GameDispatch {
  move(from: number, to: number): void;
}

export default (
  name: string
): { game?: Game; error?: any; dispatch: GameDispatch } => {
  const [game, setGame] = useState<Game | undefined>();
  const onJoin = useCallback(payload => setGame(payload.game), [setGame]);
  const { error, channel } = useChannel(`game:${name}`, onJoin);
  useEffect(() => {
    if (!channel) {
      return;
    }

    channel.on("update", payload => {
      setGame(payload.game);
    });
  }, [channel]);

  const dispatch = {
    move(from: number, to: number): void {
      channel && channel.push("move", { from, to });
    }
  };

  return { game, error, dispatch };
};
