import React, { FunctionComponent } from "react";
import { Link, BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Game from "../pages/Game";

const App: FunctionComponent = () => {
  return (
    <Router>
      <Switch>
        <Route path="/">
          <Game />
        </Route>
      </Switch>
    </Router>
  );
};

export default App;
