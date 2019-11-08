import React, { FunctionComponent } from "react";
import GameDisplay from "./components/GameDisplay";
import { buildGame } from "./models/Game";

const App: FunctionComponent = () => {
  const game = buildGame();

  return (
    <>
      <div className="flex w-screen h-screen justify-between">
        <div className="flex items-center justify-center w-full h-full">
          <GameDisplay game={game} />
        </div>
        <div className="flex flex-col flex-shrink-0 w-1/4">
          <div>Clock</div>
          <div>History</div>
          <div>Chat</div>
        </div>
      </div>
    </>
  );
};

export default App;
