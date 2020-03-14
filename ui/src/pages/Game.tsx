import React, { FunctionComponent } from "react";
import Board from "../components/Board";
import useGame from "../hooks/use-game";
import useRequiredAuth from "../hooks/use-required-auth";
import { Color } from "../models/Game";

const GamePage: FunctionComponent = () => {
  const { user } = useRequiredAuth();
  const { game, dispatch } = useGame("test");

  if (!user) {
    return <></>;
  }

  if (!game) {
    return <div>Loading</div>;
  }

  const playerColor =
    game.players[0] === user.username ? Color.White : Color.Black;

  return (
    <div className="flex w-screen h-screen justify-between">
      <div className="flex items-center justify-center w-full h-full">
        <Board
          board={game.board}
          playerColor={playerColor}
          move={dispatch.move}
        />
      </div>
      <div className="flex flex-col flex-shrink-0 w-1/4">
        <div>Clock</div>
        <div>History</div>
        <div>Chat</div>
      </div>
    </div>
  );
};

export default GamePage;
