import React, { FunctionComponent } from "react";
import { Route, Switch } from "react-router-dom";
import GamePage from "../pages/Game";
import LobbyPage from "../pages/Lobby";
import AuthenticatedHeader from "./AuthenticatedHeader";

const AuthenticatedApp: FunctionComponent = () => {
  return (
    <>
      <AuthenticatedHeader />
      <Switch>
        <Route path="/" exact component={LobbyPage} />
        <Route path="/game/:name" component={GamePage} />
      </Switch>
    </>
  );
};

export default AuthenticatedApp;
