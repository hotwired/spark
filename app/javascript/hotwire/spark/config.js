function getConfigurationProperty(name) {
  return document.querySelector(`meta[name="hotwire-spark:${name}"]`)?.content
}

export default {
  loggingEnabled: getConfigurationProperty("logging") ?? false,
  htmlReloadMethod: getConfigurationProperty("html-reload-method"),
  cableServerPath: getConfigurationProperty("cable-server-path"),
}
