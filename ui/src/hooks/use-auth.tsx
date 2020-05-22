import React, {
  createContext,
  FunctionComponent,
  useContext,
  useEffect,
  useState,
} from "react";
import { useHistory } from "react-router-dom";
import { useSocket } from "./use-socket";

export interface User {
  username: string;
}

interface AuthContextValue {
  user?: User;
  login: (name: string) => void;
  logout: () => void;
}

const authContext = createContext<AuthContextValue | undefined>(undefined);

const USER_LOCAL_STORAGE_KEY = "user";

export const ProvideAuth: FunctionComponent = ({ children }) => {
  const history = useHistory();
  const [user, setUser] = useState<User | undefined>(() => {
    const userData = window.localStorage.getItem(USER_LOCAL_STORAGE_KEY);

    return userData && JSON.parse(userData);
  });
  const { connect, disconnect } = useSocket();
  useEffect(() => user && connect(user.username), []); // eslint-disable-line react-hooks/exhaustive-deps

  const login = (username: string) => {
    const newUser = { username };
    window.localStorage.setItem(
      USER_LOCAL_STORAGE_KEY,
      JSON.stringify(newUser)
    );
    setUser(newUser);
    connect(username);
  };

  const logout = () => {
    setUser(undefined);
    window.localStorage.removeItem(USER_LOCAL_STORAGE_KEY);
    disconnect();
    history.push("/");
  };

  return (
    <authContext.Provider value={{ user, login, logout }}>
      {children}
    </authContext.Provider>
  );
};

export const useAuth = () => {
  const authContextValue = useContext(authContext);

  if (!authContextValue) {
    throw new Error("Auth context not properly configured");
  }

  return authContextValue;
};
