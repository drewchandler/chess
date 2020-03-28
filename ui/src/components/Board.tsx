import range from "lodash/range";
import React, { FunctionComponent } from "react";
import { Board as BoardType, Color } from "../models/Game";
import Square from "./Square";

interface Props {
  board: BoardType;
  playerColor: Color;
  move: (from: number, to: number) => void;
}

const Board: FunctionComponent<Props> = ({ board, playerColor, move }) => {
  let rows = range(0, 8);
  let cols = range(0, 8);
  if (playerColor === Color.White) {
    rows = rows.reverse();
  } else {
    cols = cols.reverse();
  }

  return (
    <div className="bg-white border border-gray-700 rounded shadow w-3/4-vmin h-3/4-vmin m-8 flex flex-wrap">
      {rows.map(y =>
        cols.flatMap(x => {
          const index = y * 8 + x;

          return (
            <Square
              key={index}
              index={index}
              piece={board[index]}
              move={move}
            />
          );
        })
      )}
    </div>
  );
};

export default Board;
