import React, { FunctionComponent } from "react";
import { Piece as PieceModel } from "../models/Game";
import Piece from "./Piece";

interface Props {
  index: number;
  piece: PieceModel | undefined;
  move: (from: number, to: number) => void;
}

const Square: FunctionComponent<Props> = ({ index, piece, move }) => {
  const isBlack = index % 2 === Math.floor(index / 8) % 2;

  return (
    <div
      className={`${isBlack ? "bg-gray-600" : ""} w-1/8 h-1/8 flex`}
      onDragOver={e => e.preventDefault()}
      onDragEnter={e => e.preventDefault()}
      onDrop={e =>
        move(parseInt(e.dataTransfer.getData("text/plain"), 10), index)
      }
    >
      {piece && (
        <div
          draggable={true}
          onDragStart={e => e.dataTransfer.setData("text/plain", "" + index)}
        >
          <Piece
            piece={piece}
            className="w-full h-full cursor-pointer select-none"
          />
        </div>
      )}
    </div>
  );
};

export default Square;
