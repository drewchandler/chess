export enum PieceType {
  Pawn = "pawn",
  Rook = "rook",
  Knight = "knight",
  Bishop = "bishop",
  Queen = "queen",
  King = "king"
}

export enum Color {
  White = "white",
  Black = "black"
}

export interface Piece {
  type: PieceType;
  color: Color;
}

export type Board = Array<Piece | undefined>;

export enum GameState {
  Loading = "loading",
  InProgress = "in-progress"
}

export type Game =
  | { state: GameState.Loading }
  | {
      state: GameState.InProgress;
      board: Board;
    };
