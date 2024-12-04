import { HotwireSpark } from "./index.js"

export function log(...args) {
  if (HotwireSpark.config.loggingEnabled) {
    console.log(`[hotwire_spark]`, ...args)
  }
}

