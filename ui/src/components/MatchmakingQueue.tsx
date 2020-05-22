import React, { FunctionComponent, useEffect } from "react";
import { useHistory } from "react-router-dom";
import { User } from "../hooks/use-auth";
import useChannel from "../hooks/use-channel";
import { ReactComponent as LoadingSpinner } from "../svgs/loading.svg";
import Modal from "./Modal";
import ErrorMessage from "./ErrorMessage";

interface Props {
  user: User;
  leaveQueue: () => void;
}

const MatchmakingQueue: FunctionComponent<Props> = ({ user, leaveQueue }) => {
  const history = useHistory();
  const { error, channel } = useChannel(`matchmaking:${user.username}`);
  useEffect(() => {
    if (!channel) return;

    const ref = channel.on("matched", (data) => {
      history.push(`/game/${data.name}`);
    });

    return () => {
      channel.off("matched", ref);
    };
  }, [channel, history]);

  return (
    <Modal>
      {error ? <ErrorMessage error={error} /> : <LoadingSpinner />}
      <button
        className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
        onClick={leaveQueue}
      >
        Cancel
      </button>
    </Modal>
  );
};

export default MatchmakingQueue;
