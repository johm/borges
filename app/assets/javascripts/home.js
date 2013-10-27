jQuery('document').ready(function (){

    jQuery('#menubar .menuwrapper').hover(function() {
	jQuery(this).stop().animate({
            "top": "50px"
	}, 600);
	jQuery(this).find("img").show("fade");
	jQuery(this).find(".menusub").show("fade");
    }, function() {
	jQuery(this).stop().animate({
            "top": "0px"
	}, 600);
	jQuery(this).find("img").hide("fade");
	jQuery(this).find(".menusub").hide("fade");
    });

    

    jQuery("#footer").css("top",jQuery(document).height()-jQuery("#footer").height());

    
    jQuery(window).scroll(function(){
	var top = (jQuery(window).scrollTop() > 0) ? $(window).scrollTop() : 1;
	jQuery('#myCarousel').stop(true, true).fadeTo(100, 1 / top);
    });

    jQuery(".carousel").carousel();



    jQuery(window).resize(function (){
	setTimeout(makefrontpagerespond, 500); //twice for good measure!
	setTimeout(makefrontpagerespond, 1000); //twice for good measure!
	var newheight = jQuery(window).height()-jQuery("#top").height() - 200;      
	jQuery("#heroCarousel").height(newheight);
	jQuery("#heroCarousel .item").height(newheight);

    });
    
    jQuery(window).resize();
    
    jQuery("#invoice_line_items").on("ajax:success",".best_in_place",recalculate_invoice_line_item); 
    jQuery("#line_items").on("ajax:success",".best_in_place",afterQuantityChange); //purchase_orders
    
    makefrontpagerespond();
    setTimeout(makefrontpagerespond, 750); //twice for good measure!
    
});



  function afterQuantityChange(event, data, status, xhr){
  var self=$(this);

  $.getJSON('/purchase_order_line_items/'+$(this).data('purchase-order-line-item')+'.json',function(data){
  $("#purchase_order_line_item_"+self.data('purchase-order-line-item')+" .ext_price").html(data.ext_price_string);
  });
  
  $.getJSON('/purchase_orders/'+$(this).data('purchase-order'),function(data){
  $("#total").html(data.estimated_total_string);});
  }
  



function recalculate_invoice_line_item(event, data, status, xhr){
    var line_item=jQuery(event.target).data("invoice-line-item");
    var invoice=jQuery(event.target).data("invoice");
    jQuery.getJSON('/invoice_line_items/'+$(this).data('invoice-line-item')+'.json',function(data){
	$("#invoice_line_item_"+jQuery(event.target).data('invoice-line-item')+" .ext_price").html(data.ext_price_string);
    });
}

$(document).on('nested:fieldAdded', function(event){
  //this is a kludge to make link_to_add generate some unique ids

  // this field was just inserted into your form
    var field = event.field; 
    
    var autocompletefield=field.find('.theautocomplete');
    var idfield=field.find('.theid');
    
    if (autocompletefield && idfield){
	var newid="uniquish-"+Math.floor((Math.random()*100000)+1);
	idfield.attr('id',newid);
	autocompletefield.attr('data-id-element',"#"+newid);



    }
    
});



function makefrontpagerespond(){    
    jQuery("#fronttextfluid").each(function(){
//	jQuery(this).bigtext();
//	jQuery(this).find("p").each(function(){
//	    jQuery(this).css('height',jQuery(this).css('font-size'));
	    
//	});
    });
}

