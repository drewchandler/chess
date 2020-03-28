import React, { FormEvent, FunctionComponent, useState } from "react";
import useAuth from "../hooks/use-auth";
import { Color, PieceType } from "../models/Game";
import Piece from "./Piece";

const UnauthenticatedApp: FunctionComponent = () => {
  const { login } = useAuth();
  const [username, setUsername] = useState("");

  const onSubmit = () => login(username);
  const onUsernameInput = (e: FormEvent<HTMLInputElement>) =>
    setUsername(e.currentTarget.value);

  return (
    <div className="w-full h-full flex flex-col items-center justify-center">
      <Piece
        piece={{ color: Color.Black, type: PieceType.Knight }}
        className="w-32 h-32"
      />
      <span className="text-4xl mb-4">Chess</span>
      <form
        className="w-1/3 border border-gray-700 bg-white p-4 rounded shadow"
        onSubmit={onSubmit}
      >
        <div className="mb-6">
          <label
            className="block text-gray-700 text-sm font-bold mb-2"
            htmlFor="username"
          >
            Username
          </label>
          <input
            className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            id="username"
            type="text"
            placeholder="Username"
            onInput={onUsernameInput}
          />
        </div>
        <div className="flex items-end">
          <button
            className="border bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
            type="submit"
          >
            Log In
          </button>
        </div>
      </form>
    </div>
  );
};

export default UnauthenticatedApp;
