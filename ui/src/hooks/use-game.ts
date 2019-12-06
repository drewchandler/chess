import { useState, useCallback } from "react";
import useChannel from "./use-channel";
import { Game, GameState } from "../models/Game";

export default (name: string): [any, Game] => {
  const [game, setGame] = useState<Game>({ state: GameState.Loading });
  const onJoin = useCallback(payload => setGame(payload.game), [setGame]);
  const [error] = useChannel(`game:${name}`, onJoin);

  return [error, game];
};
