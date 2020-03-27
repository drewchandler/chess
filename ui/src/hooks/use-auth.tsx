import React, {
  createContext,
  FunctionComponent,
  useState,
  useContext,
  useEffect
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

const USER_LOCAL_STORAGE_KEY = "user";

export const ProvideAuth: FunctionComponent = ({ children }) => {
  const [user, setUser] = useState<User | undefined>(() => {
    const user = window.localStorage.getItem(USER_LOCAL_STORAGE_KEY);

    return user && JSON.parse(user);
  });
  const { connect, disconnect } = useSocket();
  useEffect(() => user && connect(user.username), []); // eslint-disable-line react-hooks/exhaustive-deps

  const login = (username: string) => {
    const user = { username };
    window.localStorage.setItem(USER_LOCAL_STORAGE_KEY, JSON.stringify(user));
    setUser(user);
    connect(username);
  };

  const logout = () => {
    setUser(undefined);
    window.localStorage.removeItem(USER_LOCAL_STORAGE_KEY);
    disconnect();
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
