import React, { FunctionComponent } from "react";
import { Piece, PieceType } from "../models/Game";

interface Props {
  index: number;
  piece: Piece | undefined;
}

const sprites = [
  {
    [PieceType.Bishop]: "♗",
    [PieceType.King]: "♔",
    [PieceType.Knight]: "♘",
    [PieceType.Pawn]: "♙",
    [PieceType.Queen]: "♕",
    [PieceType.Rook]: "♖",
  },
  {
    [PieceType.Bishop]: "♝",
    [PieceType.King]: "♚",
    [PieceType.Knight]: "♞",
    [PieceType.Pawn]: "♟",
    [PieceType.Queen]: "♛",
    [PieceType.Rook]: "♜",
  }
];

const Square: FunctionComponent<Props> = ({ index, piece }) => {
  const isBlack = index % 2 === Math.floor(index / 8) % 2;
  const content = piece && sprites[piece.player][piece.type];

  return (
    <div
      className={`${isBlack && "bg-gray-600"} w-1/8 h-1/8 flex`}
    >
      {content && <p className="block m-auto text-6xl">{content}</p>}
    </div>
  );
};

export default Square;
