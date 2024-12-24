import consumer from "./consumer"
import { assetNameFromPath } from "../helpers.js";
import { HtmlReloader } from "../reloaders/html_reloader.js";
import { CssReloader } from "../reloaders/css_reloader.js";
import { StimulusReloader } from "../reloaders/stimulus_reloader.js";

consumer.subscriptions.create({ channel: "Hotwire::Spark::Channel" }, {
  connected() {
    document.body.setAttribute("data-hotwire-spark-ready", "")
  },

  async received(message) {
    try {
      await this.dispatch(message)
    } catch(error) {
      console.log(`Error on ${message.action}`, error)
    }
  },

  dispatch({ action, path }) {
    switch(action) {
      case "reload_html":
        return this.reloadHtml()
      case "reload_css":
        return this.reloadCss(path)
      case "reload_stimulus":
        return this.reloadStimulus(path)
      default:
        throw new Error(`Unknown action: ${action}`)
    }
  },

  reloadHtml() {
    return HtmlReloader.reload()
  },

  reloadCss(path) {
    const fileName = assetNameFromPath(path)
    return CssReloader.reload(new RegExp(fileName))
  },

  reloadStimulus(path) {
    return StimulusReloader.reload(path)
  }
})

