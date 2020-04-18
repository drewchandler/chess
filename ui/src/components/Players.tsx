import React, { FunctionComponent } from "react";
import { Color, Game, getActivePlayer } from "../models/Game";

interface Props {
  game: Game;
  playerColor: Color;
}

const Players: FunctionComponent<Props> = ({ game, playerColor }) => {
  const activePlayer = getActivePlayer(game);
  const players =
    playerColor === Color.Black ? game.players : game.players.reverse();

  return (
    <div>
      {players.map((player) => (
        <div key={player}>
          {player === activePlayer && "*"}
          {player}
        </div>
      ))}
    </div>
  );
};

export default Players;
