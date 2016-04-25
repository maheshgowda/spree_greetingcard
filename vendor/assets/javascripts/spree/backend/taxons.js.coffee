$(document).ready ->
  window.productTemplate = Handlebars.compile($('#product_template').text());
  window.greetingcardTemplate = Handlebars.compile($('#greetingcard_template').text());
  $('#taxon_products').sortable({
    handle: ".js-sort-handle"
  });
  $('#taxon_greetingcards').sortable({
    handle: ".js-sort-handle"
  });
  formatTaxon = (taxon) ->
    Select2.util.escapeMarkup(taxon.pretty_name)
  $('#taxon_products').on "sortstop", (event, ui) ->
    $.ajax
      url: Spree.routes.classifications_api,
      method: 'PUT',
      dataType:'json',
      data:
        token: Spree.api_key,
        product_id: ui.item.data('product-id'),
        taxon_id: $('#taxon_id').val(),
        position: ui.item.index()
    
    $('#taxon_greetingcards').on "sortstop", (event, ui) ->
    $.ajax
      url: Spree.routes.classifications_api,
      method: 'PUT',
      dataType:'json',
      data:
        token: Spree.api_key,
        greetingcard_id: ui.item.data('greetingcard-id'),
        taxon_id: $('#taxon_id').val(),
        position: ui.item.index()

  if $('#taxon_id').length > 0
    $('#taxon_id').select2
      dropdownCssClass: "taxon_select_box",
      placeholder: Spree.translations.find_a_taxon,
      ajax:
        url: Spree.routes.taxons_search,
        datatype: 'json',
        data: (term, page) ->
          per_page: 50,
          page: page,
          without_children: true,
          token: Spree.api_key,
          q:
            name_cont: term
        results: (data, page) ->
          more = page < data.pages;
          results: data['taxons'],
          more: more
      formatResult: formatTaxon,
      formatSelection: formatTaxon

  $('#taxon_id').on "change", (e) ->
    el = $('#taxon_products')
    el = $('#taxon_greetingcards')
    $.ajax
      url: Spree.routes.taxon_products_api,
      url: Spree.routes.taxon_greetingcards_api,
      data:
        id: e.val,
        token: Spree.api_key
      success: (data) ->
        el.empty()
        if data.products.length == 0
          $('#taxon_products').html("<div class='alert alert-info'>" + Spree.translations.no_results + "</div>")
        else
          for product in data.products
            if product.master.images[0] != undefined && product.master.images[0].small_url != undefined
              product.image = product.master.images[0].small_url
            else
              for variant in product.variants
                if variant.images[0] != undefined && variant.images[0].small_url != undefined
                  product.image = variant.images[0].small_url
                  break
            el.append(productTemplate({ product: product }))
        
        if data.greetingcards.length == 0
          $('#taxon_greetingcards').html("<div class='alert alert-info'>" + Spree.translations.no_results + "</div>")
        else
          for greetingcard in data.greetingcards
            if greetingcard.master.images[0] != undefined && greetingcard.master.images[0].small_url != undefined
              greetingcard.image = greetingcard.master.images[0].small_url
            else
              for variant in greetingcard.variants
                if variant.images[0] != undefined && variant.images[0].small_url != undefined
                  greetingcard.image = variant.images[0].small_url
                  break
            el.append(greetingcardTemplate({ greetingcard: greetingcard }))

  $('#taxon_products').on "click", ".js-delete-product", (e) ->
    current_taxon_id = $("#taxon_id").val()
    product = $(this).parents(".product")
    product_id = product.data("product-id")
    product_taxons = String(product.data("taxons")).split(',').map(Number)
    product_index = product_taxons.indexOf(parseFloat(current_taxon_id))
    product_taxons.splice(product_index, 1)
    taxon_ids = if product_taxons.length > 0 then product_taxons else [""]

    $.ajax
      url: Spree.routes.products_api + "/" + product_id
      data:
        product:
          taxon_ids: taxon_ids
        token: Spree.api_key
      type: "PUT",
      success: (data) ->
        product.fadeOut 400, (e) ->
          product.remove()
  
  $('#taxon_greetingcards').on "click", ".js-delete-greetingcard", (e) ->
    current_taxon_id = $("#taxon_id").val()
    greetingcard = $(this).parents(".greetingcard")
    greetingcard_id = greetingcard.data("greetingcard-id")
    greetingcard_taxons = String(greetingcard.data("taxons")).split(',').map(Number)
    greetingcard_index = greetingcard_taxons.indexOf(parseFloat(current_taxon_id))
    greetingcard_taxons.splice(greetingcard_index, 1)
    taxon_ids = if greetingcard_taxons.length > 0 then greetingcard_taxons else [""]

    $.ajax
      url: Spree.routes.greetingcards_api + "/" + greetingcard_id
      data:
        greetingcard:
          taxon_ids: taxon_ids
        token: Spree.api_key
      type: "PUT",
      success: (data) ->
        greetingcard.fadeOut 400, (e) ->
          greetingcard.remove()

  $('#taxon_products').on "click", ".js-edit-product", (e) ->
    product = $(this).parents(".product")
    product_id = product.data("product-id")
    window.location = Spree.routes.edit_product(product_id)

  $('#taxon_greetingcards').on "click", ".js-edit-greetingcard", (e) ->
    greetingcard = $(this).parents(".greetingcard")
    greetingcard_id = greetingcard.data("greetingcard-id")
    window.location = Spree.routes.edit_greetingcard(greetingcard_id)

  $(".variant_autocomplete").variantAutocomplete();
