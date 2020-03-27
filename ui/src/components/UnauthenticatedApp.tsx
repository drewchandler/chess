import React, { FunctionComponent, useState, FormEvent } from "react";
import useAuth from "../hooks/use-auth";

const UnauthenticatedApp: FunctionComponent = () => {
  const { login } = useAuth();
  const [username, setUsername] = useState("");

  const onSubmit = () => login(username);
  const onUsernameInput = (e: FormEvent<HTMLInputElement>) =>
    setUsername(e.currentTarget.value);

  return (
    <form onSubmit={onSubmit}>
      <label htmlFor="name">Name</label>
      <input id="name" onInput={onUsernameInput} />
      <button type="submit">Log in</button>
    </form>
  );
};

export default UnauthenticatedApp;
