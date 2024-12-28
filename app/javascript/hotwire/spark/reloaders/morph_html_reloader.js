import { Idiomorph } from "idiomorph/dist/idiomorph.esm.js"
import { reloadHtmlDocument } from "../helpers.js"
import { log } from "../logger.js"
import { StimulusReloader } from "./stimulus_reloader.js"

export class MorphHtmlReloader {
  static async reload() {
    return new MorphHtmlReloader().reload()
  }

  async reload() {
    await this.#reloadHtml()
    await this.#reloadStimulus()
  }

  async #reloadHtml() {
    log("Reload html with morph...")

    const reloadedDocument = await reloadHtmlDocument()
    this.#updateBody(reloadedDocument.body)
    return reloadedDocument
  }

  #updateBody(newBody) {
    Idiomorph.morph(document.body, newBody)
  }

  async #reloadStimulus() {
    await StimulusReloader.reloadAll()
  }
}
