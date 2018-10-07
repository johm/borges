jQuery('document').ready(function (){
    jQuery("#front_1 .translucent").fitText(1.2);
    jQuery(".footersocial").fitText(0.5);
    
    jQuery(".translucent a").hover(
	function(){
	    $(this).closest(".translucent").animate({'margin-top':'9vh'});
	    },
	function(){
	    $(this).closest(".translucent").animate({'margin-top':'10vh'});
	});
});
