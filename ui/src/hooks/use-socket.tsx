import { Socket } from "phoenix";
import React, {
  createContext,
  useContext,
  FunctionComponent,
  useState
} from "react";

interface SocketContextValue {
  socket?: Socket;
  connect: () => void;
  disconnect: () => void;
}

const socketContext = createContext<SocketContextValue | undefined>(undefined);

export const ProvideSocket: FunctionComponent = ({ children }) => {
  const [socket, setSocket] = useState<Socket | undefined>(undefined);
  const connect = () => {
    if (socket) {
      return;
    }

    const newSocket = new Socket("/socket", { params: { token: "abcd" } });
    newSocket.connect();

    setSocket(newSocket);
  };

  const disconnect = () => {
    if (!socket) {
      return;
    }

    socket.disconnect();
    setSocket(undefined);
  };

  return (
    <socketContext.Provider value={{ socket, connect, disconnect }}>
      {children}
    </socketContext.Provider>
  );
};

const useSocket = () => {
  const socketContextValue = useContext(socketContext);

  if (!socketContextValue) {
    throw "Socket context not properly configured";
  }

  return socketContextValue;
};

export default useSocket;
