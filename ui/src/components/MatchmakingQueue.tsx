import React, { FunctionComponent, useState, useEffect } from "react";
import { User } from "../hooks/use-auth";
import useChannel from "../hooks/use-channel";
import { Link } from "react-router-dom";

interface Props {
  user: User;
}

const MatchmakingQueue: FunctionComponent<Props> = ({ user }) => {
  const [gameName, setGameName] = useState<string | undefined>();
  const { channel } = useChannel(`matchmaking:${user.username}`);
  useEffect(() => {
    if (!channel) {
      return;
    }

    channel.on("matched", data => {
      setGameName(data.name);
    });
  }, [channel]);

  return gameName ? (
    <Link to={`/game/${gameName}`}>Join</Link>
  ) : (
    <span>Waiting...</span>
  );
};

export default MatchmakingQueue;
