import { Socket } from "phoenix";
import { createContext } from "react";

const socket = new Socket("/socket");
socket.connect();

export default createContext(socket);
