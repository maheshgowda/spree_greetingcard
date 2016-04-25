$.fn.greetingcardAutocomplete = function (options) {
  'use strict';

  // Default options
  options = options || {};
  var multiple = typeof(options.multiple) !== 'undefined' ? options.multiple : true;

  function formatGreetingcard(greetingcard) {
    return Select2.util.escapeMarkup(greetingcard.name);
  }

  this.select2({
    minimumInputLength: 3,
    multiple: multiple,
    initSelection: function (element, callback) {
      $.get(Spree.routes.greetingcard_search, {
        ids: element.val().split(','),
        token: Spree.api_key
      }, function (data) {
        callback(multiple ? data.greetingcards : data.greetingcards[0]);
      });
    },
    ajax: {
      url: Spree.routes.greetingcard_search,
      datatype: 'json',
      data: function (term, page) {
        return {
          q: {
            name_or_master_sku_cont: term,
          },
          m: 'OR',
          token: Spree.api_key
        };
      },
      results: function (data, page) {
        var greetingcards = data.greetingcards ? data.greetingcards : [];
        return {
          results: greetingcards
        };
      }
    },
    formatResult: formatGreetingcard,
    formatSelection: formatGreetingcard
  });
};

$(document).ready(function () {
  $('.greetingcard_picker').greetingcardAutocomplete();
});
