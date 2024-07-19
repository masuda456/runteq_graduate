import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Subscribe controller connected")
  }

  subscribe(event) {
    event.preventDefault()
    console.log("Subscribed!")
  }
}
