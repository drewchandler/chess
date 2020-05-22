import React, { FunctionComponent } from "react";
import { useParams, useHistory } from "react-router-dom";
import { Board } from "../components/Board";
import { GameOutcome } from "../components/GameOutcome";
import { Players } from "../components/Players";
import { useAuth } from "../hooks/use-auth";
import { useGame } from "../hooks/use-game";
import { getPlayerColor, State } from "../models/Game";
import { Modal } from "../components/Modal";
import { ErrorMessage } from "../components/ErrorMessage";
import { ReactComponent as LoadingSpinner } from "../svgs/loading.svg";

export const GamePage: FunctionComponent = () => {
  const user = useAuth().user!;
  const history = useHistory();
  const { name } = useParams();
  const { error, game, dispatch } = useGame(name!);

  if (!game) {
    return (
      <Modal>
        {error ? (
          <>
            <ErrorMessage error={error} />

            <button
              className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
              onClick={() => history.replace("/")}
            >
              Back
            </button>
          </>
        ) : (
          <LoadingSpinner />
        )}
      </Modal>
    );
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
