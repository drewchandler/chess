import React, { FunctionComponent } from "react";
import { State } from "../models/Game";

interface Props {
  players: string[];
  state: State;
}

export const GameOutcome: FunctionComponent<Props> = ({ players, state }) => {
  const winner = state === State.WhiteVictory ? players[0] : players[1];

  return <div className="text-4xl">{winner} wins!</div>;
};
