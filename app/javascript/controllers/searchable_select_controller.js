import { Controller } from "@hotwired/stimulus"

const TEXTS = {
  en: { search: "Search...", empty: "Nothing found" },
  ru: { search: "Поиск...", empty: "Ничего не найдено" },
  uk: { search: "Пошук...", empty: "Нічого не знайдено" },
  he: { search: "חיפוש...", empty: "לא נמצאו תוצאות" }
}
const SEARCH_THRESHOLD = 10
const WRAPPER_CLASS = /^(col-|row-|flex|grow|shrink|order-|self-|h-|w-)/

// Replaces a native select with a styled dropdown (search appears for long lists);
// the select stays in the DOM, so forms, inline handlers and other controllers keep working
export default class extends Controller {
  static values = { always: Boolean }

  connect() {
    this.select = this.element.querySelector("select")
    if (!this.select) return
    this.element.querySelectorAll(":scope > .ss__button, :scope > .ss__panel").forEach((node) => node.remove())

    const texts = TEXTS[document.documentElement.lang] || TEXTS.en
    this.texts = texts
    const classes = this.select.className.split(/\s+/).filter((name) => name && name !== "ss__native")
    this.select.classList.add("ss__native")
    this.select.tabIndex = -1

    const bare = classes.includes("border-0")
    this.button = document.createElement("button")
    this.button.type = "button"
    this.button.className = bare ? `${classes.join(" ")} ss__button ss__button--bare` : "ss__button ss__button--field"
    this.button.disabled = this.select.disabled
    this.button.setAttribute("aria-haspopup", "listbox")
    this.button.addEventListener("click", () => this.toggle())
    if (bare) {
      classes.filter((name) => WRAPPER_CLASS.test(name)).forEach((name) => this.element.classList.add(name))
    }

    this.panel = document.createElement("div")
    this.panel.className = "ss__panel"
    this.panel.hidden = true

    this.search = document.createElement("input")
    this.search.type = "search"
    this.search.className = "ss__search"
    this.search.placeholder = texts.search
    this.search.autocomplete = "off"
    this.search.addEventListener("input", () => this.render())
    this.search.addEventListener("keydown", (event) => this.onKeydown(event))

    this.list = document.createElement("ul")
    this.list.className = "ss__list"
    this.list.setAttribute("role", "listbox")

    this.panel.append(this.search, this.list)
    this.element.classList.add("ss")
    this.element.append(this.button, this.panel)

    this.outside = (event) => { if (!this.element.contains(event.target)) this.close() }
    this.sync = () => this.updateLabel()
    document.addEventListener("click", this.outside)
    this.select.addEventListener("change", this.sync)
    this.updateLabel()
  }

  disconnect() {
    document.removeEventListener("click", this.outside)
    this.select?.removeEventListener("change", this.sync)
    this.select?.classList.remove("ss__native")
    this.button?.remove()
    this.panel?.remove()
  }

  toggle() {
    this.panel.hidden ? this.open() : this.close()
  }

  open() {
    this.searchable = this.alwaysValue || this.visibleOptions().filter((option) => option.value).length > SEARCH_THRESHOLD
    this.search.hidden = !this.searchable
    this.panel.hidden = false
    this.button.setAttribute("aria-expanded", "true")
    this.search.value = ""
    this.render()
    this.searchable ? this.search.focus() : this.button.focus()
  }

  close() {
    this.panel.hidden = true
    this.button.setAttribute("aria-expanded", "false")
  }

  visibleOptions() {
    return Array.from(this.select.options).filter((option) => !option.hidden)
  }

  // Alphabetical order (blank option first); optgroups are sorted by label, options inside by text
  sortedOptions() {
    const collator = new Intl.Collator(document.documentElement.lang || undefined, { numeric: true, sensitivity: "base" })
    const groupLabel = (option) => (option.parentElement.tagName === "OPTGROUP" ? option.parentElement.label : "")
    return this.visibleOptions().sort((a, b) => {
      if (!a.value !== !b.value) return a.value ? 1 : -1
      return collator.compare(groupLabel(a), groupLabel(b)) || collator.compare(a.textContent, b.textContent)
    })
  }

  updateLabel() {
    const option = this.select.selectedOptions[0]
    this.button.textContent = option ? option.textContent : ""
    this.button.classList.toggle("ss__button--empty", !this.select.value)
  }

  render() {
    const query = this.search.value.trim().toLowerCase()
    this.list.replaceChildren()
    this.items = []
    let group = null

    this.sortedOptions().forEach((option) => {
      if (query && (!option.value || !option.textContent.toLowerCase().includes(query))) return

      const optgroup = option.parentElement.tagName === "OPTGROUP" ? option.parentElement : null
      if (optgroup && optgroup !== group) {
        const heading = document.createElement("li")
        heading.className = "ss__group"
        heading.textContent = optgroup.label
        this.list.append(heading)
      }
      group = optgroup

      const item = document.createElement("li")
      item.className = "ss__item"
      item.setAttribute("role", "option")
      item.textContent = option.textContent
      if (!option.value) item.classList.add("ss__item--empty")
      if (option.value === this.select.value) item.classList.add("is-selected")
      item.addEventListener("click", () => this.choose(option.value))
      this.list.append(item)
      this.items.push(item)
    })

    if (!this.items.some((item) => !item.classList.contains("ss__item--empty"))) {
      const none = document.createElement("li")
      none.className = "ss__none"
      none.textContent = this.texts.empty
      this.list.append(none)
    }

    this.setActive(this.items.findIndex((item) => item.classList.contains("is-selected")))
  }

  setActive(index) {
    this.items.forEach((item) => item.classList.remove("is-active"))
    this.activeIndex = Math.max(0, Math.min(index, this.items.length - 1))
    const active = this.items[this.activeIndex]
    if (active) {
      active.classList.add("is-active")
      active.scrollIntoView({ block: "nearest" })
    }
  }

  onKeydown(event) {
    if (event.key === "ArrowDown") { event.preventDefault(); this.setActive(this.activeIndex + 1) }
    else if (event.key === "ArrowUp") { event.preventDefault(); this.setActive(this.activeIndex - 1) }
    else if (event.key === "Enter") { event.preventDefault(); this.items[this.activeIndex]?.click() }
    else if (event.key === "Escape") { this.close(); this.button.focus() }
  }

  choose(value) {
    this.select.value = value
    this.select.dispatchEvent(new Event("change", { bubbles: true }))
    this.close()
    this.button.focus()
  }
}
