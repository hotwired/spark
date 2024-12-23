import consumer from "./consumer"
import { assetNameFromPath } from "../helpers.js";
import { MorphHtmlReloader } from "../reloaders/morph_html_reloader.js";
import { CssReloader } from "../reloaders/css_reloader.js";
import { StimulusReloader } from "../reloaders/stimulus_reloader.js";
import { ReplaceHtmlReloader } from "../reloaders/replace_html_reloader.js";

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
    const fileName = assetNameFromPath(path)

    switch(action) {
      case "reload_html":
        return this.reloadHtml()
      case "reload_css":
        return this.reloadCss(fileName)
      case "reload_stimulus":
        return this.reloadStimulus(fileName)
      default:
        throw new Error(`Unknown action: ${action}`)
    }
  },

  reloadHtml() {
    const HtmlReloader = HotwireSpark.config.htmlReloadMethod == "morph"
      ? MorphHtmlReloader
      : ReplaceHtmlReloader
    return HtmlReloader.reload()
  },

  reloadCss(fileName) {
    return CssReloader.reload(new RegExp(fileName))
  },

  reloadStimulus(fileName) {
    return StimulusReloader.reload(new RegExp(fileName))
  }
})

