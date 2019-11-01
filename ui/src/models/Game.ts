export enum PieceType {
  Pawn = "PAWN",
  Knight = "KNIGHT",
  Bishop = "BISHOP",
  Rook = "ROOK",
  Queen = "QUEEN",
  King = "KING"
};

export interface Piece {
  type: PieceType;
  player: number;
}

export type Board = Array<Piece | undefined>;

export interface Game {
  board: Board
}

export const buildGame = (): Game => {
  const board: Board = Array(64);
  board[0] = { type: PieceType.Rook, player: 0 };
  board[1] = { type: PieceType.Knight, player: 0 };
  board[2] = { type: PieceType.Bishop, player: 0 };
  board[3] = { type: PieceType.Queen, player: 0 };
  board[4] = { type: PieceType.King, player: 0 };
  board[5] = { type: PieceType.Bishop, player: 0 };
  board[6] = { type: PieceType.Knight, player: 0 };
  board[7] = { type: PieceType.Rook, player: 0 };
  board[8] = { type: PieceType.Pawn, player: 0 };
  board[9] = { type: PieceType.Pawn, player: 0 };
  board[10] = { type: PieceType.Pawn, player: 0 };
  board[11] = { type: PieceType.Pawn, player: 0 };
  board[12] = { type: PieceType.Pawn, player: 0 };
  board[13] = { type: PieceType.Pawn, player: 0 };
  board[14] = { type: PieceType.Pawn, player: 0 };
  board[15] = { type: PieceType.Pawn, player: 0 };

  board[48] = { type: PieceType.Pawn, player: 1 };
  board[49] = { type: PieceType.Pawn, player: 1 };
  board[50] = { type: PieceType.Pawn, player: 1 };
  board[51] = { type: PieceType.Pawn, player: 1 };
  board[52] = { type: PieceType.Pawn, player: 1 };
  board[53] = { type: PieceType.Pawn, player: 1 };
  board[54] = { type: PieceType.Pawn, player: 1 };
  board[55] = { type: PieceType.Pawn, player: 1 };
  board[56] = { type: PieceType.Rook, player: 1 };
  board[57] = { type: PieceType.Knight, player: 1 };
  board[58] = { type: PieceType.Bishop, player: 1 };
  board[59] = { type: PieceType.King, player: 1 };
  board[60] = { type: PieceType.Queen, player: 1 };
  board[61] = { type: PieceType.Bishop, player: 1 };
  board[62] = { type: PieceType.Knight, player: 1 };
  board[63] = { type: PieceType.Rook, player: 1 };

  return { board };
};
