jQuery ->
  $('.best_in_place').best_in_place()
  $("a#add_purchase_order_line_item").on "click", (e, data, status, xhr) ->
    $("#new_purchase_order_line_item").trigger("submit.rails")

  $("a#add_invoice_line_item").on "click", (e, data, status, xhr) ->
    $("#new_invoice_line_item").trigger("submit.rails")

  $("a#add_sale_order_line_item").on "click", (e, data, status, xhr) ->
    $("#new_sale_order_line_item").trigger("submit.rails")

  $("a#add_return_order_line_item").on "click", (e, data, status, xhr) ->
    $("#new_return_order_line_item").trigger("submit.rails")

  $("a#add_inventory_copy_confirmation").on "click", (e, data, status, xhr) ->
    $("#new_inventory_copy_confirmation").trigger("submit.rails")

  $("a#add_bucket_line_item").on "click", (e, data, status, xhr) ->
    $("#new_bucket_line_item").trigger("submit.rails")

