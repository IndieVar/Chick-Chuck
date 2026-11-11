import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    ariaLabel: String,
    noResults: String,
    searchPlaceholder: String,
  }

  connect() {
    this.select = this.element.querySelector("select")
    if (!this.select) return

    this.originalDisplay = this.select.style.display
    this.originalHidden = this.select.hidden
    this.build()
    this.select.hidden = true
    this.select.style.display = "none"
    this.select.addEventListener("change", this.syncSelection)
    this.select.addEventListener("change", this.inferParentSelection)
    this.select.addEventListener("searchable-select:refresh", this.refresh)
    document.addEventListener("click", this.closeOnOutsideClick)
    document.addEventListener("focusin", this.closeOnOutsideClick)
    this.syncSelection()
  }

  disconnect() {
    this.select?.removeEventListener("change", this.syncSelection)
    this.select?.removeEventListener("change", this.inferParentSelection)
    this.select?.removeEventListener("searchable-select:refresh", this.refresh)
    document.removeEventListener("click", this.closeOnOutsideClick)
    document.removeEventListener("focusin", this.closeOnOutsideClick)
    if (this.select) {
      this.select.hidden = this.originalHidden
      this.select.style.display = this.originalDisplay
    }
    this.widget?.remove()
  }

  build() {
    this.widget = document.createElement("div")
    this.widget.className = "relative w-full min-w-0"

    this.button = document.createElement("button")
    this.button.type = "button"
    this.button.className = `${this.select.className} flex items-center justify-between gap-2 text-start`
    this.button.setAttribute("aria-haspopup", "listbox")
    this.button.setAttribute("aria-expanded", "false")
    this.button.setAttribute("aria-label", this.ariaLabelValue || this.select.labels?.[0]?.textContent.trim() || "")
    this.button.addEventListener("click", () => this.open())
    this.button.addEventListener("keydown", (event) => {
      if (event.key === "ArrowDown" || event.key === "ArrowUp") {
        event.preventDefault()
        this.open()
      }
    })

    this.buttonLabel = document.createElement("span")
    this.buttonLabel.className = "min-w-0 truncate"
    this.button.append(this.buttonLabel, this.createDropdownIcon())

    this.popup = document.createElement("div")
    this.popup.className = "absolute left-0 top-full z-50 mt-1 w-full rounded-md border border-gray-300 bg-white p-2 text-gray-700 shadow-lg"
    this.popup.hidden = true
    this.popup.addEventListener("click", (event) => event.stopPropagation())

    this.input = document.createElement("input")
    this.input.type = "search"
    this.input.autocomplete = "off"
    this.input.placeholder = this.searchPlaceholderValue
    this.input.setAttribute("role", "combobox")
    this.input.setAttribute("aria-expanded", "false")
    this.input.setAttribute("aria-label", this.searchPlaceholderValue)
    this.input.className = "mb-2 block w-full rounded border border-gray-300 px-3 py-2 text-base focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500"
    this.input.addEventListener("input", () => this.renderOptions())
    this.input.addEventListener("keydown", (event) => this.handleInputKeydown(event))

    this.list = document.createElement("div")
    this.list.id = `${this.select.id || "searchable-select"}-listbox`
    this.list.setAttribute("role", "listbox")
    this.list.className = "max-h-60 overflow-y-auto"
    this.list.style.maxHeight = "15rem"
    this.list.style.overflowY = "auto"
    this.list.tabIndex = -1
    this.list.addEventListener("keydown", (event) => this.handleInputKeydown(event))
    this.button.setAttribute("aria-controls", this.list.id)
    this.input.setAttribute("aria-controls", this.list.id)

    this.emptyMessage = document.createElement("p")
    this.emptyMessage.className = "px-3 py-2 text-sm text-gray-500"
    this.emptyMessage.textContent = this.noResultsValue
    this.emptyMessage.hidden = true

    this.popup.append(this.input, this.list, this.emptyMessage)
    this.widget.append(this.button, this.popup)
    this.select.after(this.widget)
  }

  open() {
    if (!this.popup.hidden) return

    const buttonRect = this.button.getBoundingClientRect()
    const spaceBelow = window.innerHeight - buttonRect.bottom
    if (spaceBelow < 280 && buttonRect.top > spaceBelow) {
      this.popup.classList.remove("top-full", "mt-1")
      this.popup.classList.add("bottom-full", "mb-1")
    } else {
      this.popup.classList.remove("bottom-full", "mb-1")
      this.popup.classList.add("top-full", "mt-1")
    }

    this.popup.hidden = false
    this.button.setAttribute("aria-expanded", "true")
    this.input.setAttribute("aria-expanded", "true")
    this.input.value = ""
    this.renderOptions()
    if (this.searchable) {
      this.input.focus()
    } else {
      this.list.focus()
    }
  }

  close() {
    if (this.popup.hidden) return

    this.popup.hidden = true
    this.button.setAttribute("aria-expanded", "false")
    this.input.setAttribute("aria-expanded", "false")
    this.input.removeAttribute("aria-activedescendant")
    this.activeIndex = -1
  }

  closeOnOutsideClick = (event) => {
    if (!this.element.contains(event.target)) this.close()
  }

  syncSelection = () => {
    const selectedOption = this.select.selectedOptions[0]
    this.buttonLabel.textContent = selectedOption?.textContent.trim() || ""
    this.button.disabled = this.select.disabled
  }

  inferParentSelection = () => {
    const parentByTarget = {
      thing: ["category", "categoryId"],
      city: ["district", "districtId"],
    }
    const parentConfig = parentByTarget[this.select.dataset.dependentSelectTarget]
    if (!parentConfig) return

    const [parentTarget, dataKey] = parentConfig
    const form = this.element.closest("form")
    const parentSelect = form?.querySelector(`[data-dependent-select-target="${parentTarget}"]`)
    const parentId = this.select.selectedOptions[0]?.dataset[dataKey]
    if (!parentSelect || parentSelect.value || !parentId) return

    parentSelect.value = parentId
    parentSelect.dispatchEvent(new Event("change", { bubbles: true }))
  }

  refresh = () => {
    this.syncSelection()
    if (!this.popup.hidden) this.renderOptions()
  }

  renderOptions() {
    const availableOptions = Array.from(this.select.options).filter((option) => {
      const group = option.parentElement instanceof HTMLOptGroupElement ? option.parentElement : null
      return !option.hidden && !group?.hidden && option.value !== ""
    })
    this.searchable = availableOptions.length > 10
    this.input.hidden = !this.searchable
    this.input.style.display = this.searchable ? "" : "none"
    const query = this.searchable ? this.normalize(this.input.value) : ""
    this.list.replaceChildren()
    this.visibleOptions = []
    let previousGroup = null

    Array.from(this.select.options).forEach((option) => {
      const group = option.parentElement instanceof HTMLOptGroupElement ? option.parentElement : null
      if (option.hidden || group?.hidden || !this.normalize(option.textContent).includes(query)) return

      if (group && group !== previousGroup) {
        const heading = document.createElement("div")
        heading.setAttribute("role", "presentation")
        heading.className = "px-3 py-1 text-xs font-semibold text-gray-500"
        heading.textContent = group.label
        this.list.append(heading)
      }
      previousGroup = group

      const item = document.createElement("div")
      item.id = `${this.list.id}-option-${this.visibleOptions.length}`
      item.setAttribute("role", "option")
      item.setAttribute("aria-selected", String(option.selected))
      item.className = "cursor-pointer rounded px-3 py-2 text-base hover:bg-blue-50"
      item.textContent = option.textContent.trim()
      item.addEventListener("mouseenter", () => this.setActive(this.visibleOptions.indexOf(item)))
      item.addEventListener("click", () => this.selectOption(option))
      this.list.append(item)
      this.visibleOptions.push(item)
    })

    this.emptyMessage.hidden = this.visibleOptions.length > 0
    this.activeIndex = -1
    this.input.removeAttribute("aria-activedescendant")
  }

  createDropdownIcon() {
    const icon = document.createElementNS("http://www.w3.org/2000/svg", "svg")
    icon.setAttribute("viewBox", "0 0 20 20")
    icon.setAttribute("fill", "currentColor")
    icon.setAttribute("aria-hidden", "true")
    icon.classList.add("h-5", "w-5", "shrink-0")

    const path = document.createElementNS("http://www.w3.org/2000/svg", "path")
    path.setAttribute("fill-rule", "evenodd")
    path.setAttribute("d", "M5.22 7.47a.75.75 0 0 1 1.06 0L10 11.19l3.72-3.72a.75.75 0 1 1 1.06 1.06l-4.25 4.25a.75.75 0 0 1-1.06 0L5.22 8.53a.75.75 0 0 1 0-1.06Z")
    path.setAttribute("clip-rule", "evenodd")
    icon.append(path)

    return icon
  }

  handleInputKeydown(event) {
    if (event.key === "ArrowDown" || event.key === "ArrowUp") {
      event.preventDefault()
      const direction = event.key === "ArrowDown" ? 1 : -1
      const nextIndex = this.activeIndex + direction
      this.setActive(Math.max(0, Math.min(nextIndex, this.visibleOptions.length - 1)))
    } else if (event.key === "Enter" && this.visibleOptions[this.activeIndex]) {
      event.preventDefault()
      this.visibleOptions[this.activeIndex].click()
    } else if (event.key === "Escape") {
      event.preventDefault()
      this.close()
      this.button.focus()
    }
  }

  setActive(index) {
    this.visibleOptions.forEach((option, optionIndex) => {
      option.classList.toggle("bg-blue-100", optionIndex === index)
    })
    this.activeIndex = index

    const activeOption = this.visibleOptions[index]
    if (activeOption) {
      this.input.setAttribute("aria-activedescendant", activeOption.id)
      activeOption.scrollIntoView({ block: "nearest" })
    } else {
      this.input.removeAttribute("aria-activedescendant")
    }
  }

  selectOption(option) {
    this.select.value = option.value
    this.syncSelection()
    this.close()
    this.select.dispatchEvent(new Event("change", { bubbles: true }))
    this.button.focus()
  }

  normalize(value) {
    return value.normalize("NFD").replace(/\p{Diacritic}/gu, "").toLocaleLowerCase().trim()
  }
}
