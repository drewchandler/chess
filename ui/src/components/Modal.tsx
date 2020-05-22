import React, { FunctionComponent } from "react";

export const Modal: FunctionComponent = ({ children }) => {
  return (
    <div className="absolute w-screen h-screen flex items-center justify-center">
      <div className="w-1/4 border border-gray-700 bg-white p-4 rounded shadow flex flex-col items-center justify-center">
        {children}
      </div>
    </div>
  );
};
