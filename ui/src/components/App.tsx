import React, { FunctionComponent } from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import { ProvideAuth } from "../hooks/use-auth";
import { ProvideSocket } from "../hooks/use-socket";
import GamePage from "../pages/Game";
import IndexPage from "../pages/Index";
import LobbyPage from "../pages/Lobby";

const App: FunctionComponent = () => {
  return (
    <Router>
      <ProvideSocket>
        <ProvideAuth>
          <Switch>
            <Route path="/lobby" component={LobbyPage} />
            <Route path="/game" component={GamePage} />
            <Route path="/" component={IndexPage} />
          </Switch>
        </ProvideAuth>
      </ProvideSocket>
    </Router>
  );
};

export default App;
