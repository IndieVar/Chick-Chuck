import { Controller } from "@hotwired/stimulus"

// Thumbnail grid for a multiple file input; files can be added in several rounds and removed one by one
export default class extends Controller {
  static targets = ["input", "grid"]
  static values = { single: Boolean }

  connect() {
    this.files = []
    this.form = this.element.closest("form")
    this.onReset = () => setTimeout(() => { this.files = []; this.sync() })
    this.form?.addEventListener("reset", this.onReset)
  }

  disconnect() {
    this.form?.removeEventListener("reset", this.onReset)
  }

  add() {
    if (this.singleValue) this.files = []
    Array.from(this.inputTarget.files).forEach((file) => {
      const duplicate = this.files.some((f) => f.name === file.name && f.size === file.size && f.lastModified === file.lastModified)
      if (!duplicate) this.files.push(file)
    })
    this.sync()
  }

  remove(event) {
    this.files.splice(Number(event.currentTarget.dataset.index), 1)
    this.sync()
  }

  sync() {
    const transfer = new DataTransfer()
    this.files.forEach((file) => transfer.items.add(file))
    this.inputTarget.files = transfer.files

    this.gridTarget.replaceChildren(...this.files.map((file, index) => this.tile(file, index)))
    this.gridTarget.hidden = this.files.length === 0
  }

  tile(file, index) {
    const item = document.createElement("div")
    item.className = "upload-thumb"

    const img = document.createElement("img")
    img.className = "upload-thumb__img"
    img.alt = file.name
    img.src = URL.createObjectURL(file)
    img.onload = () => URL.revokeObjectURL(img.src)

    const button = document.createElement("button")
    button.type = "button"
    button.className = "upload-thumb__remove"
    button.dataset.index = index
    button.dataset.action = "upload-preview#remove"
    button.setAttribute("aria-label", "Remove")
    button.innerHTML = '<svg viewBox="0 0 20 20" fill="currentColor" width="14" height="14"><path d="M6.28 5.22a.75.75 0 0 0-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 1 0 1.06 1.06L10 11.06l3.72 3.72a.75.75 0 1 0 1.06-1.06L11.06 10l3.72-3.72a.75.75 0 0 0-1.06-1.06L10 8.94 6.28 5.22Z"/></svg>'

    const name = document.createElement("span")
    name.className = "upload-thumb__name"
    name.textContent = file.name

    item.append(img, button, name)
    return item
  }
}
