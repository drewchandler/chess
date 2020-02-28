import range from "lodash/range";
import React, { FunctionComponent } from "react";
import Square from "./Square";
import { Board as BoardType } from "../models/Game";

interface Props {
  board: BoardType;
  move: (from: number, to: number) => void;
}

const Board: FunctionComponent<Props> = ({ board, move }) => {
  return (
    <div className="border border-gray-700 w-3/4-vmin h-3/4-vmin m-8 flex flex-wrap">
      {range(0, 8)
        .reverse()
        .map(y =>
          range(0, 8).flatMap(x => {
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
