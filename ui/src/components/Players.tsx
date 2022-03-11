import React, { FunctionComponent } from "react";
import { Color, Game, getActivePlayer } from "../models/Game";
import { Clock } from "./Clock";

interface Props {
  game: Game;
  playerColor: Color;
}

export const Players: FunctionComponent<Props> = ({ game, playerColor }) => {
  const activePlayer = getActivePlayer(game);
  const indexes = playerColor === Color.Black ? [0, 1] : [1, 0];

  return (
    <div>
      {indexes.map((index) => {
        const player = game.players[index];
        const clock = game.clocks[index];
        const isActive = player === activePlayer;

        return (
          <div key={index}>
            {isActive && "*"}
            {player}
            <Clock time={clock} shouldCountdown={isActive} />
          </div>
        );
      })}
    </div>
  );
};
