export function assetNameFromPath(path) {
  return path.split("/").pop().split(".")[0]
}

export function pathWithoutAssetDigest(path) {
  return path.replace(/-[a-z0-9]+\.(\w+)(\?.*)?$/, ".$1")
}

export function urlWithParams(urlString, params) {
  const url = new URL(urlString, window.location.origin)
  Object.entries(params).forEach(([ key, value ]) => {
    url.searchParams.set(key, value)
  })
  return url.toString()
}

export function cacheBustedUrl(urlString) {
  return urlWithParams(urlString, { reload: Date.now() })
}

class ResponseError extends Error {
  constructor(message, response) {
    super(message)
    this.response = response
  }
}

export async function reloadHtmlDocument() {
  let currentUrl = cacheBustedUrl(urlWithParams(window.location.href, { hotwire_spark: "true" }))
  const response = await fetch(currentUrl, { headers: { "Accept": "text/html" }})


  const fetchedHTML = await response.text()
  const parser = new DOMParser()
  const parsedResult = parser.parseFromString(fetchedHTML, "text/html")

  if (response.ok) {
    return parsedResult
  } else {
    throw new ResponseError(`${response.status} when fetching ${currentUrl}`, parsedResult)
  }
}

export function getConfigurationProperty(name) {
  return document.querySelector(`meta[name="hotwire-spark:${name}"]`)?.content
}

