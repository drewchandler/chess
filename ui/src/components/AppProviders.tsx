import React, { FunctionComponent } from "react";
import { BrowserRouter as Router } from "react-router-dom";
import { ProvideAuth } from "../hooks/use-auth";
import { ProvideSocket } from "../hooks/use-socket";

const AppProviders: FunctionComponent = ({ children }) => {
  return (
    <Router>
      <ProvideSocket>
        <ProvideAuth>{children}</ProvideAuth>
      </ProvideSocket>
    </Router>
  );
};

export default AppProviders;
