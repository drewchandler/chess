import React, { FunctionComponent } from "react";

interface Props {
  error: string;
}

export const ErrorMessage: FunctionComponent<Props> = ({ error }) => (
  <span className="text-lg text-red-500 py-4">{error}</span>
);
