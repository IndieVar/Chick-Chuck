// Wraps every native single select in a searchable-select controller element
const SELECTOR = "select:not([multiple]):not([data-native-select])"

function enhance(root = document) {
  root.querySelectorAll(SELECTOR).forEach((select) => {
    if (select.closest(".ss, [data-controller~='searchable-select']")) return
    const wrapper = document.createElement("div")
    wrapper.dataset.controller = "searchable-select"
    select.before(wrapper)
    wrapper.append(select)
  })
}

let queued = false
new MutationObserver(() => {
  if (queued) return
  queued = true
  requestAnimationFrame(() => { queued = false; enhance() })
}).observe(document.documentElement, { childList: true, subtree: true })

document.addEventListener("DOMContentLoaded", () => enhance())
enhance()
