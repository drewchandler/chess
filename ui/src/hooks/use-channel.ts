import { useEffect, useState } from "react";
import { Channel } from "phoenix";
import useSocket from "./use-socket";

export default (
  name: string,
  onJoin?: (payload: any) => void
): { channel: Channel | undefined; error?: any } => {
  const { socket } = useSocket() || {};
  const [channel, setChannel] = useState<Channel | undefined>();
  const [error, setError] = useState<any | undefined>();

  useEffect(() => {
    if (!socket) {
      setChannel(undefined);
      setError(undefined);

      return;
    }

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

  return { error, channel };
};
