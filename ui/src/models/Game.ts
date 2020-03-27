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

export enum State {
  WhiteTurn = "white_turn",
  BlackTurn = "black_turn"
}

export type Board = Array<Piece | undefined>;

export type Game = {
  board: Board;
  players: String[];
  state: State;
};

export const getPlayerColor = (game: Game, player: string) => {
  return game.players[0] === player ? Color.White : Color.Black;
};

export const getActivePlayer = (game: Game) => {
  if (game.state === State.WhiteTurn) {
    return game.players[0];
  } else if (game.state === State.BlackTurn) {
    return game.players[1];
  }
};
