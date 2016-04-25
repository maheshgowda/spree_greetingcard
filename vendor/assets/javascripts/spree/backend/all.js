// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require spree/backend
//= require spree/backend/greetingcard_picker

//= require_tree .

Spree.routes.greetingcards_api = Spree.pathFor('api/v1/greetingcards')
Spree.routes.greetingcard_search = Spree.adminPathFor('search/greetingcards')

Spree.routes.taxon_greetingcards_api = Spree.pathFor('api/v1/taxons/greetingcards')

Spree.routes.edit_greetingcard = function(greetingcard_id) {
  return Spree.adminPathFor('greetingcards/' + greetingcard_id + '/edit')
}

