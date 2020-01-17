import React, { FunctionComponent, useState, useEffect } from "react";
import { useHistory } from "react-router-dom";
import useAuth from "../hooks/use-auth";

const IndexPage: FunctionComponent = () => {
  const { user, login } = useAuth();
  const history = useHistory();

  useEffect(() => {
    if (user) {
      history.replace("/lobby");
    }
  }, [history, user]);

  const [username, setUsername] = useState("");

  const onSubmit = () => {
    login(username);
  };

  return (
    <form onSubmit={onSubmit}>
      <label htmlFor="name">Name</label>
      <input id="name" onInput={e => setUsername(e.currentTarget.value)} />
      <button type="submit">Log in</button>
    </form>
  );
};

export default IndexPage;
