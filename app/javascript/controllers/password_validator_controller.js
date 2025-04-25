import { Controller } from "@hotwired/stimulus"

const specialChars = /[ !"#$%&'()*+,\-./:;<=>?@[\\\]^_`{|}~]/g
const rules = [
    {
        id: "two-numbers",
        validate: (value) => {
            const digits = value.match(/\d/g)
            return digits ? digits.length >= 2 : false
        }
    },
    {
        id: "two-special-characters",
        validate: (value) => {
            const specialCharsCount = value.match(specialChars)
            return specialCharsCount ? specialCharsCount.length >= 2 : false
        }
    },
    {
        id: "two-uppercase",
        validate: (value) => {
            const uppercaseLetters = value.match(/[A-Z]/g)
            return uppercaseLetters ? uppercaseLetters.length >= 2 : false
        }
    },
    {
        id: "two-lowercase",
        validate: (value) => {
            const lowercaseLetters = value.match(/[a-z]/g)
            return lowercaseLetters ? lowercaseLetters.length >= 2 : false
        }
    },
    {
        id: "min-length-10",
        validate: (value) => {
            return value.length >= 10
        }
    },
    {
        id: "max-length-72",
        validate: (value) => {
            return value.length <= 72
        }
    }
]

export default class extends Controller {
    static targets = ["password", "rulesContainer", "rule"]

    connect() {
        this.validatePassword()
    }

    validatePassword() {
        const rulesResult = rules.map(rule => {
            return {
                id: rule.id,
                isValid: rule.validate(this.passwordTarget.value)
            }
        })
        const isValid = rulesResult.every(rule => rule.isValid)

        this.updateRulesContainer(rulesResult)
        this.updatePasswordInput(isValid)
    }

    updateRulesContainer(rulesResult) {
        if (!this.passwordTarget.value) {
            this.ruleTargets.forEach(rule => rule.classList.remove("is-invalid", "is-valid"))
            return
        }

        rulesResult.forEach(rule => {
            const ruleElement = this.rulesContainerTarget.querySelector(`#${rule.id}`)
            if (ruleElement) {
                this.toggleInvalidClass(rule.isValid, ruleElement)
            }
        })
    }

    updatePasswordInput(isValid) {
        if (!this.passwordTarget.value) {
            this.passwordTarget.classList.remove("is-invalid", "is-valid")
            return
        }

        this.toggleInvalidClass(isValid, this.passwordTarget)
    }

    toggleInvalidClass(isValid, element) {
        if (isValid) {
            element.classList.remove("is-invalid")
            element.classList.add("is-valid")
        } else {
            element.classList.add("is-invalid")
            element.classList.remove("is-valid")
        }
    }
}
