import React, { FunctionComponent } from "react";
import { Piece } from "../models/Game";
import sprite from "../sprites/chess_pieces.svg";

interface Props {
  index: number;
  piece: Piece | undefined;
  move: (from: number, to: number) => void;
}

const Square: FunctionComponent<Props> = ({ index, piece, move }) => {
  const isBlack = index % 2 === Math.floor(index / 8) % 2;
  const spriteUrl = piece && `${sprite}#${piece.color}-${piece.type}`;

  return (
    <div
      className={`${isBlack ? "bg-gray-600" : ""} w-1/8 h-1/8 flex`}
      onDragOver={e => e.preventDefault()}
      onDragEnter={e => e.preventDefault()}
      onDrop={e =>
        move(parseInt(e.dataTransfer.getData("text/plain"), 10), index)
      }
    >
      {spriteUrl && (
        <div
          draggable={true}
          onDragStart={e => e.dataTransfer.setData("text/plain", "" + index)}
        >
          <svg className="w-full h-full cursor-pointer select-none">
            <use href={spriteUrl} />
          </svg>
        </div>
      )}
    </div>
  );
};

export default Square;
