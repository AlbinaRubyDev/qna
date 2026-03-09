import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rating"]
  static values = {
    type: String,
    id: Number
  }

  vote(event) {
    event.preventDefault()

    const value = event.currentTarget.dataset.value
    const url = `/${this.typeValue.toLowerCase()}s/${this.idValue}/cast_vote`
    const token = document.querySelector('meta[name="csrf-token"]')?.content
    
    fetch(url, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": token
      },
      body: new URLSearchParams({ value: value })
    })
    .then(response => response.json())
    .then(data => {
      this.ratingTarget.innerHTML = data.rating
    })
  }
}
