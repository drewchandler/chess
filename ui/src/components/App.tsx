import React, { FunctionComponent } from "react";
import { Route, Switch } from "react-router-dom";
import GamePage from "../pages/Game";
import IndexPage from "../pages/Index";
import LobbyPage from "../pages/Lobby";

const App: FunctionComponent = () => {
  return (
    <Switch>
      <Route path="/lobby" component={LobbyPage} />
      <Route path="/game/:name" component={GamePage} />
      <Route path="/" component={IndexPage} />
    </Switch>
  );
};

export default App;
