export function nameFromFilePath(path) {
  return path.split("/").pop().split(".")[0]
}

export function urlWithParams(urlString, params) {
  const url = new URL(urlString, window.location.origin)
  Object.entries(params).forEach(([key, value]) => {
    url.searchParams.set(key, value)
  })
  return url.toString()
}

export function cacheBustedUrl(urlString) {
  return urlWithParams(urlString, { reload: Date.now() })
}

export async function reloadHtmlDocument() {
  let currentUrl = cacheBustedUrl(window.location.href)
  const response = await fetch(currentUrl)
  const fetchedHTML = await response.text()
  const parser = new DOMParser()
  return parser.parseFromString(fetchedHTML, "text/html")
}

