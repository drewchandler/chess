import React, { FunctionComponent, useState } from "react";
import MatchmakingQueue from "../components/MatchmakingQueue";
import useAuth from "../hooks/use-auth";

const LobbyPage: FunctionComponent = () => {
  const user = useAuth().user!;
  const [inQueue, setInQueue] = useState(false);

  return (
    <>
      <h1>Lobby</h1>
      <button onClick={() => setInQueue(true)}>Play</button>
      {inQueue && <MatchmakingQueue user={user} />}
    </>
  );
};

export default LobbyPage;
