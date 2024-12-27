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

    const { documentElement } = await this.#reloadHtmlDocument()
    return this.#updateDocument(documentElement)
  }

  #updateDocument(newDocument) {
    Idiomorph.morph(document.documentElement, newDocument)
    return newDocument
  }

  async #reloadHtmlDocument() {
    try {
      return await reloadHtmlDocument()
    } catch ({ response }) {
      return response
    }
  }

  async #reloadStimulus() {
    await StimulusReloader.reloadAll()
  }
}
