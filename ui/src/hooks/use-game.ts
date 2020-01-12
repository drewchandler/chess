import { useState, useCallback } from "react";
import useChannel from "./use-channel";
import { Game, GameState } from "../models/Game";

export default (name: string): { game: Game; error?: any } => {
  const [game, setGame] = useState<Game>({ state: GameState.Loading });
  const onJoin = useCallback(payload => setGame(payload.game), [setGame]);
  const { error } = useChannel(`game:${name}`, onJoin);

  return { game, error };
};
