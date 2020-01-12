import React, { FunctionComponent } from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import { ProvideAuth } from "../hooks/use-auth";
import { ProvideSocket } from "../hooks/use-socket";
import GamePage from "../pages/Game";
import IndexPage from "../pages/Index";

const App: FunctionComponent = () => {
  return (
    <Router>
      <ProvideSocket>
        <ProvideAuth>
          <Switch>
            <Route path="/game">
              <GamePage />
            </Route>
            <Route path="/">
              <IndexPage />
            </Route>
          </Switch>
        </ProvideAuth>
      </ProvideSocket>
    </Router>
  );
};

export default App;
