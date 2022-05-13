// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let Hooks = {}

Hooks.Board = {
  mounted() {
    this.fetchMoves = debounce(this.fetchMoves.bind(this), 300)
    this.clearMoves = debounce(this.clearMoves.bind(this), 300)

    this.el.addEventListener("mouseenter", this.mouseEnter.bind(this), true)
    this.el.addEventListener("mouseleave", this.mouseLeave.bind(this), true)
    this.el.addEventListener("dragstart", this.dragStart.bind(this))
    this.el.addEventListener("drop", this.drop.bind(this))
  },

  mouseEnter(e) {
    if (!e.target.matches('[draggable]')) return

    this.clearMoves.cancel()
    this.fetchMoves(e.target)
  },

  mouseLeave(e) {
    if (!e.target.matches('[draggable]')) return

    this.fetchMoves.cancel()
    this.clearMoves()
  },

  dragStart(e) {
    e.dataTransfer.setData("text/json", JSON.stringify(this.getPosition(e.target)))
  },

  drop(e) {
    let target = this.getTarget(e, "[data-x]")
    if (!target) return

    this.pushEvent("move", { from: JSON.parse(e.dataTransfer.getData("text/json")), to: this.getPosition(target) })
  },

  fetchMoves(target) {
    this.pushEvent("get-moves", this.getPosition(target))
  },

  clearMoves(target) {
    this.pushEvent("clear-moves")
  },

  getPosition(el) {
    return {
      x: parseInt(el.getAttribute("data-x"), 10),
      y: parseInt(el.getAttribute("data-y"), 10)
    }
  },

  getTarget(e, selector) {
    return e.target.matches(selector) ? e.target : e.target.closest(selector)
  }
}

let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

let debounce = (callback, wait) => {
  let timeoutId = null
  let cancelled = false

  let cancel = () => {
    cancelled = true
  }

  let debounced = (...args) => {
    window.clearTimeout(timeoutId)
    cancelled = false

    timeoutId = window.setTimeout(() => {
      if (!cancelled) {
        callback.apply(null, args)
      }
    }, wait)
  }

  debounced.cancel = cancel

  return debounced
}