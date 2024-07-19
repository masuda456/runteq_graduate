import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    console.log("Subscribe controller connected")
  }

  subscribe(event) {
    event.preventDefault()
    // サブスクリプション処理をここに記述する
    console.log("Subscribed!")
  }
}
