# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $("#purchase_order_line_item_isbn").on "change", (e, data, status, xhr) ->	
    alert("hi");			 
#  $("#purchase_order_line_item_edition_id").val("hey now")