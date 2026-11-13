import { Controller } from "@hotwired/stimulus"

// For a grouped child select (options inside optgroups titled like the parent options):
// selects the matching parent and submits the form
export default class extends Controller {
  static values = { parent: String }

  sync() {
    const form = this.element.form
    const parent = form?.querySelector(`select[name$="[${this.parentValue}]"], select[name="${this.parentValue}"]`)
    const label = this.element.selectedOptions[0]?.parentElement?.label

    if (parent && label) {
      const match = Array.from(parent.options).find((option) => option.textContent.trim() === label.trim())
      if (match) parent.value = match.value
    }
    form?.submit()
  }
}
