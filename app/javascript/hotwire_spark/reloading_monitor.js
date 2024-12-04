import { HtmlReloader } from "./reloaders/html_reloader.js"
import { CssReloader } from "./reloaders/css_reloader.js";
import { StimulusReloader } from "./reloaders/stimulus_reloader.js";
import { nameFromFilePath } from "./helpers.js";

export class ReloadingMonitor {
  static start() {
    new ReloadingMonitor().start()
  }

  start() {
    const socket = new WebSocket(`ws://${window.location.host}/hotwire_spark`)
    socket.addEventListener("message", this.#dispatchMessage.bind(this))
  }

  #dispatchMessage(event) {
    const message = JSON.parse(event.data)
    const filePath = nameFromFilePath(message.path)

    switch (message.action) {
      case "reload_html":
        this.#reloadHtml()
        break
      case "reload_css":
        this.#reloadCss(filePath)
        break
      case "reload_stimulus":
        this.#reloadStimulus(filePath)
        break
    }
  }

  #reloadHtml() {
    HtmlReloader.reload()
  }

  #reloadCss(path) {
    CssReloader.reload(new RegExp(path))
  }

  #reloadStimulus(path) {
    StimulusReloader.reload(new RegExp(path))
  }
}
