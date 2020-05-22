import { Channel } from "phoenix";
import { useEffect, useState, useCallback } from "react";
import { useSocket } from "./use-socket";

interface UseChannelValue {
  channel?: Channel;
  error?: string;
  leave: () => void;
}

export const useChannel = (
  name: string,
  onJoin?: (payload: any) => void
): UseChannelValue => {
  const { socket } = useSocket() || {};
  const [channel, setChannel] = useState<Channel | undefined>();
  const [error, setError] = useState<string | undefined>();

  useEffect(() => {
    if (!socket || error) return;

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

  const leave = useCallback(() => {
    if (!channel) return;

    channel.leave();
    setChannel(undefined);
  }, [channel]);

  return { error, channel, leave };
};
