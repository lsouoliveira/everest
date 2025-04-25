import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["target"]

    remove() {
        console.log("Removing target elements")
        this.targetTargets.forEach(target => {
            console.log("Removing target:", target)
            target.remove()
        })
    }
}
