import debounce, { DebouncedFunction } from "../utils/debounce";
import type { ViewHook } from "phoenix_live_view";

type HTMLElementEvent<T extends UIEvent> = T & {
  target: HTMLElement;
};

interface BoardHook {
  mounted: (this: ViewHook & BoardHook) => void;
  mouseEnter: (
    this: ViewHook & BoardHook,
    e: HTMLElementEvent<MouseEvent>
  ) => void;
  mouseLeave: (
    this: ViewHook & BoardHook,
    e: HTMLElementEvent<MouseEvent>
  ) => void;
  dragStart: (
    this: ViewHook & BoardHook,
    e: HTMLElementEvent<DragEvent>
  ) => void;
  drop: (this: ViewHook & BoardHook, e: HTMLElementEvent<DragEvent>) => void;
  fetchMoves: DebouncedFunction<
    (this: ViewHook & BoardHook, target: HTMLElement) => void
  >;
  clearMoves: DebouncedFunction<(this: ViewHook & BoardHook) => void>;
}

const board: BoardHook = {
  mounted() {
    this.fetchMoves = debounce(this.fetchMoves.bind(this), 300);
    this.clearMoves = debounce(this.clearMoves.bind(this), 300);

    this.el.addEventListener("mouseenter", this.mouseEnter.bind(this), true);
    this.el.addEventListener("mouseleave", this.mouseLeave.bind(this), true);
    this.el.addEventListener("dragstart", this.dragStart.bind(this));
    this.el.addEventListener("drop", this.drop.bind(this));
  },

  mouseEnter(e) {
    if (!e.target.matches("[draggable]")) return;

    this.clearMoves.cancel();
    this.fetchMoves(e.target);
  },

  mouseLeave(e) {
    if (!e.target.matches("[draggable]")) return;

    this.fetchMoves.cancel();
    this.clearMoves();
  },

  dragStart(e) {
    e.dataTransfer.setData("text/json", JSON.stringify(getPosition(e.target)));
  },

  drop(e) {
    const target = getTarget(e, "[data-x]");
    if (!target) return;

    this.pushEvent("move", {
      from: JSON.parse(e.dataTransfer.getData("text/json")),
      to: getPosition(target),
    });
  },

  fetchMoves: function (target: HTMLElement) {
    this.pushEvent("get-moves", getPosition(target));
  } as any,

  clearMoves: function () {
    this.pushEvent("clear-moves", {});
  } as any,
};

const getPosition = (el: Element) => {
  return {
    x: parseInt(el.getAttribute("data-x"), 10),
    y: parseInt(el.getAttribute("data-y"), 10),
  };
};

const getTarget = <T extends UIEvent>(
  e: HTMLElementEvent<T>,
  selector: string
) => {
  return e.target.matches(selector) ? e.target : e.target.closest(selector);
};

export default board;
