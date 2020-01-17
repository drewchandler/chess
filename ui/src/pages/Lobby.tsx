import React, { FunctionComponent } from "react";
import { Link } from "react-router-dom";
import useRequiredAuth from "../hooks/use-required-auth";

const LobbyPage: FunctionComponent = () => {
  useRequiredAuth();

  return (
    <>
      <h1>Lobby</h1>
      <Link to="/game">Game</Link>
    </>
  );
};

export default LobbyPage;
