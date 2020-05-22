import React, { FunctionComponent } from "react";
import { Piece as PieceModel } from "../models/Game";
import { Piece } from "./Piece";

interface Props {
  index: number;
  piece: PieceModel | undefined;
  isHighlighted: boolean;
  onDrop: (from: number, to: number) => void;
  onHover: (position: number) => void;
}

export const Square: FunctionComponent<Props> = ({
  index,
  piece,
  isHighlighted,
  onDrop,
  onHover,
}) => {
  const isBlack = index % 2 === Math.floor(index / 8) % 2;
  // prettier-ignore
  let color = isBlack ? isHighlighted ? "bg-green-600" : "bg-gray-600"
                      : isHighlighted ? "bg-green-400" : "bg-white";

  return (
    <div
      className={`${color} w-1/8 h-1/8 flex`}
      onDragOver={(e) => e.preventDefault()}
      onDragEnter={(e) => e.preventDefault()}
      onDrop={(e) =>
        onDrop(parseInt(e.dataTransfer.getData("text/plain"), 10), index)
      }
      onMouseEnter={() => onHover(index)}
    >
      {piece && (
        <div
          draggable={true}
          onDragStart={(e) => e.dataTransfer.setData("text/plain", "" + index)}
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
