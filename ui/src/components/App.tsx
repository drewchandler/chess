import React, { FunctionComponent } from "react";
import { useAuth } from "../hooks/use-auth";
import { AuthenticatedApp } from "./AuthenticatedApp";
import { UnauthenticatedApp } from "./UnauthenticatedApp";

export const App: FunctionComponent = () => {
  const { user } = useAuth();

  return (
    <div className="font-sans bg-gray-100 w-screen h-screen">
      {user ? <AuthenticatedApp /> : <UnauthenticatedApp />}
    </div>
  );
};
