import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  // hide modal
  // action: "turbo-modal#hideModal"
  hideModal() {
    const frame = this.element.parentElement
    frame.querySelector(".contacts-modal__backdrop")?.remove()
    frame.removeAttribute("src")
    // Remove src reference from parent frame element
    // Without this, turbo won't re-open the modal on subsequent click
    this.modalTarget.remove()
  }

  // hide modal on successful form submission
  // action: "turbo:submit-end->turbo-modal#submitEnd"
  submitEnd(e) {
    if (e.detail.success) {
      this.hideModal()
    }
  }

  // hide modal when clicking ESC
  // action: "keyup@window->turbo-modal#closeWithKeyboard"
  closeWithKeyboard(e) {
    if (e.code == "Escape") {
      this.hideModal()
    }
  }
  
    // hide modal when clicking outside of modal
  // action: "click@window->turbo-modal#closeBackground"
  closeBackground(e) {
    if (e && this.modalTarget.contains(e.target)) {
      return
    }
    this.hideModal()
  }
}