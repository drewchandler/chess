import React, { FunctionComponent } from "react";
import useAuth from "../hooks/use-auth";
import { Color, PieceType } from "../models/Game";
import Piece from "./Piece";

const AuthenticatedHeader: FunctionComponent = () => {
  const { user, logout } = useAuth();

  return (
    <div className="text-white bg-blue-700 px-4 py-2 flex fixed w-full">
      <div className="w-5/6 flex">
        <Piece
          piece={{ color: Color.Black, type: PieceType.Knight }}
          className="w-8 h-8"
        />
        <span className="text-2xl ml-2">Chess</span>
      </div>
      <div>
        <span>{user!.username}</span>
        <span
          className="cursor-pointer ml-2 text-xs text-gray-300"
          onClick={() => logout()}
        >
          (Log out)
        </span>
      </div>
    </div>
  );
};

export default AuthenticatedHeader;
