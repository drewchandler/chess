import React, { FunctionComponent, useState } from "react";
import { MatchmakingQueue } from "../components/MatchmakingQueue";
import { useAuth } from "../hooks/use-auth";

export const LobbyPage: FunctionComponent = () => {
  const user = useAuth().user!;
  const [inQueue, setInQueue] = useState(false);
  const joinQueue = () => setInQueue(true);
  const leaveQueue = () => setInQueue(false);

  return (
    <div className="w-full h-full flex flex-col items-center justify-center">
      {inQueue ? (
        <MatchmakingQueue user={user} leaveQueue={leaveQueue} />
      ) : (
        <button
          className="bg-blue-500 hover:bg-blue-700 text-white text-6xl font-bold py-8 px-24 rounded focus:outline-none focus:shadow-outline"
          onClick={joinQueue}
        >
          Play
        </button>
      )}
    </div>
  );
};
