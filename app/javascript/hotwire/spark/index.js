import "./channels/monitoring_channel.js"
import { getConfigurationProperty } from "./helpers.js";

const HotwireSpark = {
  config: {
    loggingEnabled: false,
    htmlReloadMethod: "morph"
  }
}

document.addEventListener("DOMContentLoaded", function() {
  HotwireSpark.config.loggingEnabled = getConfigurationProperty("logging");
  HotwireSpark.config.htmlReloadMethod = getConfigurationProperty("html-reload-method");
})

export default HotwireSpark
