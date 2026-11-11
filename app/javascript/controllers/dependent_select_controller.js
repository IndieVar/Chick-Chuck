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

  filterOptions(parentSelect, childSelect, dataKey) {
    const parentId = parentSelect.value
    let selectedOptionHidden = false

    Array.from(childSelect.options).forEach((option) => {
      const optionParentId = option.dataset[dataKey]
      const visible = !optionParentId || !parentId || optionParentId === parentId

      option.hidden = !visible
      if (!visible && option.selected) selectedOptionHidden = true
    })

    if (selectedOptionHidden) childSelect.value = ""
  }
}
