import React, { FunctionComponent, useState } from "react";
import useRequiredAuth from "../hooks/use-required-auth";
import MatchmakingQueue from "../components/MatchmakingQueue";

const LobbyPage: FunctionComponent = () => {
  const { user } = useRequiredAuth();
  const [inQueue, setInQueue] = useState(false);

  if (!user) {
    return <></>;
  }

  return (
    <>
      <h1>Lobby</h1>
      <button onClick={() => setInQueue(true)}>Play</button>
      {inQueue && <MatchmakingQueue user={user} />}
    </>
  );
};

export default LobbyPage;
