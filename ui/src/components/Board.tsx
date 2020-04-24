import range from "lodash/range";
import React, { FunctionComponent, useState, useEffect } from "react";
import { Board as BoardType, Color } from "../models/Game";
import Square from "./Square";

interface Props {
  board: BoardType;
  playerColor: Color;
  makeMove: (from: number, to: number) => void;
  legalMoves: (position: number) => Promise<number[]>;
}

const Board: FunctionComponent<Props> = ({
  board,
  playerColor,
  makeMove,
  legalMoves,
}) => {
  const [hoveredPosition, setHoveredPosition] = useState<number | undefined>();
  const [moves, setMoves] = useState<number[]>([]);
  useEffect(() => {
    if (!hoveredPosition) return;

    let requestStillValid = true;
    legalMoves(hoveredPosition).then((moves) => {
      if (requestStillValid) setMoves(moves);
    });

    return () => {
      requestStillValid = false;
    };
  }, [legalMoves, hoveredPosition, setMoves]);

  const onHover = (position: number) => {
    setMoves([]);
    setHoveredPosition(board[position] ? position : undefined);
  };

  let rows = range(0, 8);
  let cols = range(0, 8);
  if (playerColor === Color.White) {
    rows = rows.reverse();
  } else {
    cols = cols.reverse();
  }

  return (
    <div className="bg-white border border-gray-700 rounded shadow w-3/4-vmin h-3/4-vmin m-8 flex flex-wrap">
      {rows.map((y) =>
        cols.flatMap((x) => {
          const index = y * 8 + x;

          return (
            <Square
              key={index}
              index={index}
              piece={board[index]}
              isHighlighted={moves.includes(index)}
              onDrop={makeMove}
              onHover={onHover}
            />
          );
        })
      )}
    </div>
  );
};

export default Board;
