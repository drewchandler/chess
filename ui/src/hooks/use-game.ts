import { useCallback, useEffect, useState } from "react";
import { Game, State } from "../models/Game";
import { useChannel } from "./use-channel";

interface GameDispatch {
  makeMove(from: number, to: number): void;
  legalMoves(position: number): Promise<number[]>;
}

export const useGame = (
  name: string
): { game?: Game; error?: string; dispatch: GameDispatch } => {
  const [game, setGame] = useState<Game | undefined>();
  const onJoin = useCallback((payload) => setGame(payload.game), [setGame]);
  const { error, channel, leave } = useChannel(`game:${name}`, onJoin);
  useEffect(() => {
    if (!channel) {
      return;
    }

    const ref = channel.on("update", (payload: { game: Game }) => {
      setGame(payload.game);

      if (
        [State.WhiteVictory, State.BlackVictory].includes(payload.game.state)
      ) {
        leave();
      }
    });

    return () => {
      channel.off("update", ref);
    };
  }, [channel, leave]);

  const dispatch = {
    makeMove(from: number, to: number) {
      channel?.push("move", { from, to });
    },
    legalMoves(position: number): Promise<number[]> {
      return new Promise((resolve, reject) => {
        channel
          ?.push("legal_moves", { position })
          .receive("ok", ({ moves }) => resolve(moves))
          .receive("error", reject);
      });
    },
  };

  return { game, error, dispatch };
};
