import { useState, useCallback, useEffect } from "react";
import useChannel from "./use-channel";
import { Game, GameState } from "../models/Game";

interface GameDispatch {
  move(from: number, to: number): void;
}

export default (
  name: string
): { game: Game; error?: any; dispatch: GameDispatch } => {
  const [game, setGame] = useState<Game>({ state: GameState.Loading });
  const onJoin = useCallback(payload => setGame(payload.game), [setGame]);
  const { error, channel } = useChannel(`game:${name}`, onJoin);
  const dispatch = {
    move(from: number, to: number): void {
      channel && channel.push("move", { from, to });
    }
  };

  useEffect(() => {
    if (!channel) {
      return;
    }

    channel.on("update", payload => {
      setGame(payload.game);
    });
  }, [channel]);

  return { game, error, dispatch };
};
