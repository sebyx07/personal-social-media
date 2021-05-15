import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "input" ]

  toggle(e){
    if(this.inputTarget.type === "password"){
      e.target.classList.add("line-through");
      return this.inputTarget.type = "text";
    }

    e.target.classList.remove("line-through");
    this.inputTarget.type = "password"
  }
}