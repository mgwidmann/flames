// Note: Phoenix JS dependencies are loaded
// from their Application directories by the LayoutView
import NProgress from "../vendor/nprogress";

let Hooks = {}

let socketPath = document.querySelector("html").getAttribute("phx-socket") || "/live"
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveView.LiveSocket(socketPath, Phoenix.Socket, {
  hooks: Hooks,
  params: (liveViewName) => {
    return {
      _csrf_token: csrfToken,
    };
  },
})


const socket = liveSocket.socket
const originalOnConnError = socket.onConnError
let fallbackToLongPoll = true

socket.onOpen(() => {
  fallbackToLongPoll = false
})

socket.onConnError = (...args) => {
  if (fallbackToLongPoll) {
    // No longer fallback to longpoll
    fallbackToLongPoll = false
    // close the socket with an error code
    socket.disconnect(null, 3000)
    // fall back to long poll
    socket.transport = Phoenix.LongPoll
    // reopen
    socket.connect()
  } else {
    originalOnConnError.apply(socket, args)
  }
}

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket