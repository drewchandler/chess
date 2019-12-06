import { useContext, useEffect, useState } from "react";
import SocketContext from "../contexts/socket";
import { Channel } from "phoenix";

export default (
  name: string,
  onJoin?: (payload: any) => void
): [any | undefined, Channel | undefined] => {
  const socket = useContext(SocketContext);
  const [channel, setChannel] = useState<Channel | undefined>();
  const [error, setError] = useState<any | undefined>();

  useEffect(() => {
    const c = socket.channel(name);

    c.join()
      .receive("ok", payload => {
        setChannel(c);
        setError(undefined);
        if (onJoin) onJoin(payload);
      })
      .receive("error", payload => {
        setChannel(undefined);
        setError(payload);
      });

    return () => {
      c.leave();
    };
  }, [socket, name, onJoin]);

  return [error, channel];
};
