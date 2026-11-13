import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "box", "text", "btn"]
    static values = { ownerId: String }

    connect() {
      if (this.currentUserId && this.currentUserId === this.authorId) {
        this.boxTarget.classList.add("chat-msg--own")
      } else {
        this.boxTarget.classList.add("chat-msg--peer")
        this.btnTarget.classList.add("hidden")
      }
    }

    get currentUserId() {
      return document.querySelector("[name='current-user-id']").content
    }

    get authorId() {
      return this.ownerIdValue
    }

    clearInput() {
      this.element.reset()
    }
}