import useAuth from "./use-auth";
import { useHistory } from "react-router-dom";
import { useEffect } from "react";

const useRequiredAuth = () => {
  const auth = useAuth();
  const history = useHistory();

  useEffect(() => {
    if (!auth.user) {
      history.replace("/");
    }
  }, [auth.user]);

  return auth;
};

export default useRequiredAuth;
