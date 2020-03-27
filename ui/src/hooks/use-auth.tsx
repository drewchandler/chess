import React, {
  createContext,
  FunctionComponent,
  useState,
  useContext
} from "react";
import useSocket from "./use-socket";

export interface User {
  username: string;
}

interface AuthContextValue {
  user?: User;
  login: (name: string) => void;
  logout: () => void;
}

const authContext = createContext<AuthContextValue | undefined>(undefined);

export const ProvideAuth: FunctionComponent = ({ children }) => {
  const [user, setUser] = useState<User | undefined>(undefined);
  const { connect } = useSocket();

  const login = (username: string) => {
    setUser({ username });
    connect(username);
  };

  const logout = () => {
    setUser(undefined);
  };

  return (
    <authContext.Provider value={{ user, login, logout }}>
      {children}
    </authContext.Provider>
  );
};

const useAuth = () => {
  const authContextValue = useContext(authContext);

  if (!authContextValue) {
    throw new Error("Auth context not properly configured");
  }

  return authContextValue;
};

export default useAuth;
