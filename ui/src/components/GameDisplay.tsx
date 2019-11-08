import range from "lodash/range";
import React, { FunctionComponent } from "react";
import Square from "./Square";
import { Game } from "../models/Game";

interface Props {
  game: Game;
}

const GameDisplay: FunctionComponent<Props> = ({ game }) => {
  return (
    <div className="border border-gray-700 w-3/4-vmin h-3/4-vmin m-8 flex flex-wrap">
      {range(0, 64)
        .reverse()
        .map(i => (
          <Square key={i} index={i} piece={game.board[i]} />
        ))}
    </div>
  );
};

export default GameDisplay;
