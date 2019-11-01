import React, { FunctionComponent } from "react";
import GameDisplay from "./components/GameDisplay";
import { buildGame } from "./models/Game";

const App: FunctionComponent = () => {
  const game = buildGame();

  return <GameDisplay game={game} />;
};

export default App;
