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
//import { Socket } from "phoenix";
import flatpickr from "flatpickr";
var moment = require("moment-timezone");

let timeZone = "Europe/Helsinki";

var coeff = 1000 * 60 * 5;
var date = new Date(Date.now());
// Datetime picker
flatpickr("#played_at", {
  altInput: true,
  altFormat: "L H:m A",
  enableTime: true,
  dateFormat: "YYYY-MM-DD\\\\THH:mm:ssZ",
  time_24hr: true,
  maxDate: new Date(Math.round(date.getTime() / coeff) * coeff),
  defaultDate: new Date(Math.round(date.getTime() / coeff) * coeff),
  parseDate(dateString, format) {
    let timezonedDate = new moment.tz(dateString, format, timeZone);

    return new Date(
      timezonedDate.year(),
      timezonedDate.month(),
      timezonedDate.date(),
      timezonedDate.hour(),
      timezonedDate.minute(),
      timezonedDate.second()
    );
  },
  formatDate(date, format) {
    return moment
      .tz(
        [
          date.getFullYear(),
          date.getMonth(),
          date.getDate(),
          date.getHours(),
          date.getMinutes(),
          date.getSeconds()
        ],
        timeZone
      )
      .format(format);
  }
});

$(".game_row").on("click", function() {
  var gameID = $(this).attr("game");
  if (gameID == undefined) return;

  $("tr.game_row_sub[game=" + gameID + "]").fadeToggle();
  if ($(this).hasClass("is-active")) {
    $(this).removeClass("is-active");
  } else {
    $(this).addClass("is-active");
  }
});

let dropdown = $("#info-dropdown");
if (dropdown != null) {
  dropdown.on("click", function(event) {
    event.stopPropagation();
    dropdown.toggleClass("is-active");
  });
}

// Tabs
let tabsWithContent = (function() {
  let tabs = $(".tabs li");
  let tabsContent = $(".tab-content");
  let deactvateAllTabs = function() {
    tabs.each(function() {
      $(this).removeClass("is-active");
    });
  };

  let hideTabsContent = function() {
    tabsContent.each(function() {
      $(this).removeClass("is-active");
    });
  };

  let activateTabsContent = function(tab) {
    tabsContent.eq(tab.index()).addClass("is-active");
  };

  let getIndex = function(el) {
    return [...el.parentElement.children].indexOf(el);
  };

  tabs.each(function() {
    $(this).on("click", function() {
      deactvateAllTabs();
      hideTabsContent();
      $(this).addClass("is-active");
      activateTabsContent($(this));
    });
  });

  tabs.first().click();
})();

// Modal trigger
$("a#map-modal").on("click", function(event) {
  event.preventDefault();
  var modal = $(".modal");
  var html = $("html");
  modal.addClass("is-active");
  html.addClass("is-clipped");

  $(".modal-background").on("click", function(e) {
    e.preventDefault();
    modal.removeClass("is-active");
    html.removeClass("is-clipped");
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
