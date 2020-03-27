import React, { FunctionComponent } from "react";
import { Route, Switch } from "react-router-dom";
import GamePage from "../pages/Game";
import LobbyPage from "../pages/Lobby";

const AuthenticatedApp: FunctionComponent = () => {
  return (
    <Switch>
      <Route path="/" exact component={LobbyPage} />
      <Route path="/game/:name" component={GamePage} />
    </Switch>
  );
};

export default AuthenticatedApp;
