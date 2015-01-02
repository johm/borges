jQuery(document).ready(function() {
    jQuery("body").on("switch-change",".switch-inventory",function(e, data, status, xhr){
	jQuery(this).closest('form').trigger("submit.rails");
	});

    jQuery("#inventory_section").on("change", function(){
	jQuery.get("/inventories/"+jQuery(this).parent().find("#inventory_id_for_section").val()+"/section",{section: jQuery(this).val()}).done(function(data){
	    jQuery("#open_copies").html(data);
	}) 			  
    });

    
    jQuery("#inventory_owner").on("change", function(){
	jQuery.get("/inventories/"+jQuery(this).parent().find("#inventory_id_for_section").val()+"/owner",{owner: jQuery(this).val()}).done(function(data){
	    jQuery("#open_copies").html(data);
	}) 			  
    });



    jQuery("#open_copies").on("click",".inventory_section_link",function(e){
	jQuery.post("/inventory_copy_confirmations",{inventory_copy_confirmation: {copy_id: jQuery(this).data("copy"), inventory_id: jQuery(this).data("inventory")}},null,'script');
	e.preventDefault();
    });

});
