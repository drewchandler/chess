import range from "lodash/range";
import React, { FunctionComponent } from "react";
import Square from "./Square";
import { Board as BoardType } from "../models/Game";

interface Props {
  board: BoardType;
}

const Board: FunctionComponent<Props> = ({ board }) => {
  return (
    <div className="border border-gray-700 w-3/4-vmin h-3/4-vmin m-8 flex flex-wrap">
      {range(0, 64)
        .reverse()
        .map(i => (
          <Square key={i} index={i} piece={board[i]} />
        ))}
    </div>
  );
};

export default Board;
