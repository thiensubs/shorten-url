require("@rails/ujs").start()
require("turbolinks").start()
require("channels")
require('jquery/dist/jquery')
require('bootstrap/dist/js/bootstrap')
import toastr from 'toastr'
global.toastr = toastr;
import $ from 'jquery'
require('data-confirm-modal')
import "bootstrap/dist/css/bootstrap.css"
import "src/home.sass"
import "toastr/toastr.scss";
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
$(document).on('turbolinks:load', function() {
  $('body').tooltip({
    selector: '[data-toggle="tooltip"]',
    container: 'body',
  });

  $('body').popover({
    selector: '[data-toggle="popover"]',
    container: 'body',
    html: true,
    trigger: 'hover',
  });
  
});