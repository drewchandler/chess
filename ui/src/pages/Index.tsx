import React, { FunctionComponent, FormEvent, useState } from "react";
import { Redirect } from "react-router-dom";
import useAuth from "../hooks/use-auth";

const IndexPage: FunctionComponent = () => {
  const { user, login } = useAuth();
  const [name, setName] = useState("");

  if (user) return <Redirect to="/game" />;

  const onSubmit = () => {
    login(name);
  };

  return (
    <form onSubmit={onSubmit}>
      <label htmlFor="name">Name</label>
      <input id="name" onInput={e => setName(e.currentTarget.value)} />
      <button type="submit">Log in</button>
    </form>
  );
};

export default IndexPage;
