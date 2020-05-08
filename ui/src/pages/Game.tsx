import React, { FunctionComponent } from "react";
import { useParams } from "react-router-dom";
import Board from "../components/Board";
import GameOutcome from "../components/GameOutcome";
import Players from "../components/Players";
import useAuth from "../hooks/use-auth";
import useGame from "../hooks/use-game";
import { getPlayerColor, State } from "../models/Game";

const GamePage: FunctionComponent = () => {
  const user = useAuth().user!;
  const { name } = useParams();
  const { game, dispatch } = useGame(name!);

  if (!game) {
    return <div>Loading</div>;
  }

  const playerColor = getPlayerColor(game, user.username);

  return (
    <div className="flex w-screen h-screen justify-between">
      <div className="flex flex-col items-center justify-center w-full h-full">
        {[State.BlackVictory, State.WhiteVictory].includes(game.state) && (
          <GameOutcome players={game.players} state={game.state} />
        )}
        <Board
          board={game.board}
          playerColor={playerColor}
          makeMove={dispatch.makeMove}
          legalMoves={dispatch.legalMoves}
        />
      </div>
      <div className="flex flex-col flex-shrink-0 w-1/4 justify-center">
        <Players game={game} playerColor={playerColor} />
      </div>
    </div>
  );
};

export default GamePage;
