import range from "lodash/range";
import React, { FunctionComponent, useState, useRef, useEffect } from "react";
import { Board as BoardType, Color } from "../models/Game";
import Square from "./Square";
import useDebounce from "../hooks/use-debounce";

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
  const hoveredPosition = useRef<number | undefined>();
  const [moves, setMoves] = useState<number[]>([]);
  const requestLegalMoves = useDebounce(
    async (position: number) => {
      const newMoves = await legalMoves(position);

      if (hoveredPosition.current === position) {
        setMoves(newMoves);
      }
    },
    300,
    [legalMoves, setMoves]
  );
  useEffect(() => setMoves([]), [board]);

  const onHover = (position: number) => {
    hoveredPosition.current = position;
    setMoves([]);

    if (board[position]) {
      requestLegalMoves(position);
    } else {
      requestLegalMoves.cancel();
    }
  };

  const mouseLeave = () => {
    hoveredPosition.current = undefined;
    setMoves([]);
    requestLegalMoves.cancel();
  };

  return (
    <div
      className="bg-white border border-gray-700 rounded shadow w-3/4-vmin h-3/4-vmin m-8 flex flex-wrap"
      onMouseLeave={mouseLeave}
    >
      {squares(playerColor).map((index) => (
        <Square
          key={index}
          index={index}
          piece={board[index]}
          isHighlighted={moves.includes(index)}
          onDrop={makeMove}
          onHover={onHover}
        />
      ))}
    </div>
  );
};

const squares = (playerColor: Color): Array<number> => {
  let rows = range(0, 8);
  let cols = range(0, 8);
  if (playerColor === Color.White) {
    rows = rows.reverse();
  } else {
    cols = cols.reverse();
  }

  return rows.flatMap((y) => cols.map((x) => y * 8 + x));
};

export default Board;
