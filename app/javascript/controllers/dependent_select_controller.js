import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["category", "thing", "district", "city"]

  connect() {
    this.filterOptions(this.categoryTarget, this.thingTarget, "categoryId")
    this.filterOptions(this.districtTarget, this.cityTarget, "districtId")
  }

  filterThings() {
    this.filterOptions(this.categoryTarget, this.thingTarget, "categoryId")
  }

  filterCities() {
    this.filterOptions(this.districtTarget, this.cityTarget, "districtId")
  }

  syncCategory() {
    this.syncParent(this.thingTarget, this.categoryTarget, "categoryId")
  }

  syncDistrict() {
    this.syncParent(this.cityTarget, this.districtTarget, "districtId")
  }

  // Picks the parent automatically when only the child is selected
  syncParent(childSelect, parentSelect, dataKey) {
    const parentId = childSelect.selectedOptions[0]?.dataset[dataKey]
    if (!childSelect.value || !parentId || parentSelect.value === parentId) return

    parentSelect.value = parentId
    parentSelect.dispatchEvent(new Event("change", { bubbles: true }))
  }

  filterOptions(parentSelect, childSelect, dataKey) {
    const parentId = parentSelect.value
    let selectedOptionHidden = false

    Array.from(childSelect.options).forEach((option) => {
      const optionParentId = option.dataset[dataKey]
      const visible = !optionParentId || !parentId || optionParentId === parentId

      option.hidden = !visible
      if (!visible && option.selected) selectedOptionHidden = true
    })

    if (selectedOptionHidden) {
      childSelect.value = ""
      childSelect.dispatchEvent(new Event("change", { bubbles: true }))
    }
  }
}
