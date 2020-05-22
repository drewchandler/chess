import React, { FunctionComponent } from "react";
import { Piece as PieceModel } from "../models/Game";
import sprite from "../svgs/chess_pieces.svg";

interface Props {
  piece: PieceModel;
  className?: string;
}

export const Piece: FunctionComponent<Props> = ({ piece, className }) => {
  const spriteUrl = piece && `${sprite}#${piece.color}-${piece.type}`;

  return (
    <svg className={className}>
      <use href={spriteUrl} />
    </svg>
  );
};
