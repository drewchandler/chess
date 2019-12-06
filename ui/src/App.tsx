import React, { FunctionComponent } from "react";
import Board from "./components/Board";
import useGame from "./hooks/use-game";
import { GameState } from "./models/Game";

const App: FunctionComponent = () => {
  const [, game] = useGame("test");

  return (
    <>
      {game.state === GameState.Loading ? (
        <div>Loading</div>
      ) : (
        <div className="flex w-screen h-screen justify-between">
          <div className="flex items-center justify-center w-full h-full">
            <Board board={game.board} />
          </div>
          <div className="flex flex-col flex-shrink-0 w-1/4">
            <div>Clock</div>
            <div>History</div>
            <div>Chat</div>
          </div>
        </div>
      )}
    </>
  );
};

export default App;
