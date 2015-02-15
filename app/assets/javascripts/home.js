jQuery('document').ready(function (){
    
    $('video,audio').mediaelementplayer();





   
    jQuery('#menubar .menuwrapper>a').each(function(){
	if (jQuery(location).attr('pathname')==jQuery(this).attr('href')){
	    jQuery(this).find("img").show();
	    jQuery(this).data("active","yes");
	}
	else{
	    var toplevel=jQuery(this);
	    jQuery(this).siblings().find("a").each(function(){
		if (jQuery(location).attr('pathname')==jQuery(this).attr('href')){
		    toplevel.find("img").show();
		    toplevel.data("active","yes");
		}
	    });
	}
    });
    
    jQuery('#menubar .menuwrapper').hover(function() {
	jQuery(this).stop().animate({
            "top": "10px",
	}, 400);

	jQuery(this).children("a").stop().animate({
            "padding-top": "6px",
	}, 400);
	
	jQuery(this).find('a').css("color","#fafafa");
	jQuery(this).find('a').css("background-color","#cb3e38");
	jQuery(this).find('a').css("opacity",".95");

	jQuery(this).find("img").show("fade");
	jQuery(this).find(".menusub").slideDown();
    }, function() {
	jQuery(this).stop().animate({
            "top": "0px",
	}, 400);
	
	
	jQuery(this).children("a").stop().animate({
            "padding-left": "0px",
	}, 400);
	
	jQuery(this).children('a').css("color","#cb3e38");
	jQuery(this).children('a').css("background-color","#ffffff");
	jQuery(this).find('a').css("opacity","1");

	jQuery(this).children('a').each(function(){
	if (jQuery(this).data("active") != "yes"){
	    jQuery(this).find("img").hide("fade");
	    }
	});
	jQuery(this).find(".menusub").slideUp();
    });


    jQuery("iframe[src*='archive.org/embed']").each(function(){ jQuery(this).height(3/4*jQuery(this).width());});    

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
    
    jQuery("#inventory_copy_confirmations").on("change",".switch-inventory input",function(){
	jQuery(this).closest(".edit_inventory_copy_confirmation").find(".inventory_trash a").toggle();
    }); 

    jQuery("#invoice_line_items").on("ajax:success",".best_in_place",recalculate_invoice_line_item); 
    jQuery("#line_items").on("ajax:success",".best_in_place",afterQuantityChange); //purchase_orders

    //this doesn't really work.    
    jQuery('#sale_order_meta .best_in_place').on("ajax:success", function ()
						 {window.location.reload();});

    $('.datetimepicker').each(function(){ 
	$(this).datetimepicker({step:30,value:$(this).val(),formatTime:'g:i a'});
    });
    
    $('.datepicker').datetimepicker({
	timepicker:false,format:"Y-m-d"
    });


    $('.manage_calendar .calendar td.day').not('.not-current-month').each(function(){
	$(this).prepend(
	    "<a class='newevent' href='/events/new?date="+$(this).data('date')+"'><i class='icon-plus-sign'></i></a>"
	);
    }); 

    
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

