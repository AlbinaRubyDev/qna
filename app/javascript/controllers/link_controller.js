import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "template", "newLink" ]

  add() {
    this.linkIndex ||= 0

    const content = this.templateTarget.innerHTML.replace(/NEW_LINK_INDEX/g, this.linkIndex += 1)
    this.newLinkTarget.insertAdjacentHTML("beforeend", content)
  }
}
