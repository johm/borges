# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery(document).ready(function() {
  jQuery("body").on "switch-change",".switch-inventory",(e, data, status, xhr) ->
    jQuery(this).closest('form').trigger("submit.rails")
  jQuery("#inventory_section").on "change", (e) ->
    jQuery("/inventory/section",{section: jQuery(this).val()}).done 			  