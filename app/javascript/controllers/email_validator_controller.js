import { Controller } from "@hotwired/stimulus"

const emailRegex = /^[a-zA-Z0-9!#$%&'*+\-/=?^_{|}~.]{1,64}@[a-zA-Z0-9.-]{1,128}$/

export default class extends Controller {
    static targets = ["email"]

    connect() {
        this.validateEmail()
    }

    validateEmail() {
        if (!this.emailTarget.value) {
            this.emailTarget.classList.remove("is-valid")
            this.emailTarget.classList.remove("is-invalid")
            return
        }

        const isValid = emailRegex.test(this.emailTarget.value)

        if (isValid) {
            this.emailTarget.classList.remove("is-invalid")
            this.emailTarget.classList.add("is-valid")
        } else {
            this.emailTarget.classList.add("is-invalid")
            this.emailTarget.classList.remove("is-valid")
        }
    }
}
