import { Channel } from "phoenix";
import { useEffect, useState } from "react";
import useSocket from "./use-socket";

export default (
  name: string,
  onJoin?: (payload: any) => void
): { channel: Channel | undefined; error?: any } => {
  const { socket } = useSocket() || {};
  const [channel, setChannel] = useState<Channel | undefined>();
  const [error, setError] = useState<any | undefined>();

  useEffect(() => {
    if (!socket || error) {
      return;
    }

    const c = socket.channel(name);

    c.join()
      .receive("ok", (payload) => {
        setChannel(c);
        setError(undefined);
        if (onJoin) {
          onJoin(payload);
        }
      })
      .receive("error", (payload) => {
        setChannel(undefined);
        setError(payload.message);
      });

    return () => {
      c.leave();
    };
  }, [error, name, onJoin, socket]);

  return { error, channel };
};
