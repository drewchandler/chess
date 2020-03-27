import React, { FunctionComponent } from "react";
import Board from "../components/Board";
import useGame from "../hooks/use-game";
import { Color } from "../models/Game";
import { useParams } from "react-router-dom";
import useAuth from "../hooks/use-auth";

const GamePage: FunctionComponent = () => {
  const user = useAuth().user!;
  const { name } = useParams();
  const { game, dispatch } = useGame(name!);

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
