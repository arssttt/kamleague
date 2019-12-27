// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import scss from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";
import flatpickr from "flatpickr";

let liveSocket = new LiveSocket("/live", Socket);
liveSocket.connect();

var coeff = 1000 * 60 * 5;
var date = new Date(Date.now());
// Datetime picker
flatpickr("#played_at", {
  enableTime: true,
  dateFormat: "d-m-Y H:i",
  maxDate: new Date(Math.round(date.getTime() / coeff) * coeff),
  defaultDate: new Date(Math.round(date.getTime() / coeff) * coeff)
});

let dropdown = document.querySelector(".dropdown");
dropdown.addEventListener("click", function(event) {
  event.stopPropagation();
  dropdown.classList.toggle("is-active");
});

// Modal trigger
document
  .querySelector("a#map-modal")
  .addEventListener("click", function(event) {
    event.preventDefault();
    var modal = document.querySelector(".modal"); // assuming you have only 1
    var html = document.querySelector("html");
    modal.classList.add("is-active");
    html.classList.add("is-clipped");

    modal
      .querySelector(".modal-background")
      .addEventListener("click", function(e) {
        e.preventDefault();
        modal.classList.remove("is-active");
        html.classList.remove("is-clipped");
      });
  });

// Uncheck radio buttons if they are the same when selecting locations
$(function() {
  $('input[name="game[players][1][location]"]').on("change", function() {
    var other = $('input[name="game[players][2][location]"]:checked');
    // If other is already selected, uncheck it
    if ($(this).val() == other.val()) {
      other.prop("checked", false);
    }
  });

  $('input[name="game[players][2][location]"]').on("change", function() {
    var other = $('input[name="game[players][1][location]"]:checked');
    // If other is already selected, uncheck it
    if ($(this).val() == other.val()) {
      other.prop("checked", false);
    }
  });
});
