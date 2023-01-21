// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


require("bootstrap")
require("bootstrap-datepicker")


//= require jquery-3.2.1.slim.min
//= require jquery_ujs
//= require jquery.ui.all
//= require popper.min
//= require bootstrap.min
//= require bootstrap-datepicker
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.en-GB.js
//= require turbolinks
//= require_tree .


import "../stylesheets/application";
document.addEventListener("turbolinks:load", function() {
  $(function () {
      $('[data-toggle="tooltip"]').tooltip();
      $('[data-toggle="popover"]').popover();
  })
})

document.addEventListener("turbolinks:load", function() {
  $(function () {
    require("packs/custom");
    //localStorage  
    $(".on-modal-close").on("click", function(){
      $.ajax({
        url: "users/closed_without_docs"
      });
    })
  })

  $(function(){
    $('.datepicker').datepicker({
      format: 'mm-dd-yyyy'
    });
  });

})

require("trix")
require("@rails/actiontext")

Turbolinks.setProgressBarDelay(1000)

