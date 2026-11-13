import { Controller } from "@hotwired/stimulus"

// Search inside the services dropdown and a counter of the selected services on its button
export default class extends Controller {
  static targets = ["search", "item", "all", "empty", "count"]

  connect() {
    this.update()
    // "Select all" is handled by another controller, so recount after its change
    this.element.addEventListener("change", () => setTimeout(() => this.update()))
  }

  filter() {
    const query = this.searchTarget.value.trim().toLowerCase()
    let visible = 0
    this.itemTargets.forEach((item) => {
      const match = item.textContent.trim().toLowerCase().includes(query)
      item.hidden = !match
      if (match) visible += 1
    })
    this.allTarget.hidden = query !== ""
    this.emptyTarget.hidden = visible > 0
  }

  preventSubmit(event) {
    if (event.key === "Enter") event.preventDefault()
  }

  update() {
    const checked = this.itemTargets.filter((item) => item.querySelector("input:checked")).length
    this.countTarget.textContent = checked
    this.countTarget.hidden = checked === 0
  }
}
