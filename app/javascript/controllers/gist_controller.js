import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  async connect() {
    const url = this.element.dataset.gist
    const id = url.split("/").pop()
    
    const res = await fetch(`https://api.github.com/gists/${id}`)
    const data = await res.json()
    const file = Object.values(data.files)[0]

    this.element.innerHTML = `<pre>${file.content}</pre>`
  }
}
