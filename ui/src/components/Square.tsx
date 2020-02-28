import React, { FunctionComponent } from "react";
import { Color, Piece, PieceType } from "../models/Game";

const sprites = {
  [Color.White]: {
    [PieceType.Bishop]: "♗",
    [PieceType.King]: "♔",
    [PieceType.Knight]: "♘",
    [PieceType.Pawn]: "♙",
    [PieceType.Queen]: "♕",
    [PieceType.Rook]: "♖"
  },
  [Color.Black]: {
    [PieceType.Bishop]: "♝",
    [PieceType.King]: "♚",
    [PieceType.Knight]: "♞",
    [PieceType.Pawn]: "♟",
    [PieceType.Queen]: "♛",
    [PieceType.Rook]: "♜"
  }
};

interface Props {
  index: number;
  piece: Piece | undefined;
  move: (from: number, to: number) => void;
}

const Square: FunctionComponent<Props> = ({ index, piece, move }) => {
  const isBlack = index % 2 === Math.floor(index / 8) % 2;
  const content = piece && sprites[piece.color][piece.type];

  return (
    <div
      className={`${isBlack && "bg-gray-600"} w-1/8 h-1/8 flex`}
      onDragOver={e => e.preventDefault()}
      onDragEnter={e => e.preventDefault()}
      onDrop={e =>
        move(parseInt(e.dataTransfer.getData("text/plain"), 10), index)
      }
    >
      {content && (
        <p
          className="block m-auto text-6xl cursor-pointer select-none"
          draggable={true}
          onDragStart={e => e.dataTransfer.setData("text/plain", "" + index)}
        >
          {content}
        </p>
      )}
    </div>
  );
};

export default Square;
