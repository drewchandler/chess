export enum PieceType {
  Pawn = 0,
  Rook = 1,
  Knight = 2,
  Bishop = 3,
  Queen = 4,
  King = 5
}

export interface Piece {
  type: PieceType;
  player: number;
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
