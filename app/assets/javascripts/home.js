
jQuery('document').ready(function (){

;(function(window, $)
{
  var counter = 0,
    $headCache = $('head'),
    oldBigText = window.BigText,
    oldjQueryMethod = $.fn.bigtext,
    BigText = {
      DEFAULT_MIN_FONT_SIZE_PX: null,
      DEFAULT_MAX_FONT_SIZE_PX: 528,
      GLOBAL_STYLE_ID: 'bigtext-style',
      STYLE_ID: 'bigtext-id',
      LINE_CLASS_PREFIX: 'bigtext-line',
      EXEMPT_CLASS: 'bigtext-exempt',
      DEFAULT_CHILD_SELECTOR: '> div',
      childSelectors: {
        div: '> div',
        ol: '> li',
        ul: '> li'
      },
      noConflict: function(restore)
      {
        if(restore) {
          $.fn.bigtext = oldjQueryMethod;
          window.BigText = oldBigText;
        }
        return BigText;
      },
      init: function()
      {
        if(!$('#'+BigText.GLOBAL_STYLE_ID).length) {
          $headCache.append(BigText.generateStyleTag(BigText.GLOBAL_STYLE_ID, ['.bigtext * { white-space: nowrap; }',
                                          '.bigtext .' + BigText.EXEMPT_CLASS + ', .bigtext .' + BigText.EXEMPT_CLASS + ' * { white-space: normal; }']));
        }
      },
      bindResize: function(eventName, resizeFunction)
      {
        if($.throttle) {
          // https://github.com/cowboy/jquery-throttle-debounce
          $(window).unbind(eventName).bind(eventName, $.throttle(100, resizeFunction));
        } else {
          if($.fn.smartresize) {
            // https://github.com/lrbabe/jquery-smartresize/
            eventName = 'smartresize.' + eventName;
          }
          $(window).unbind(eventName).bind(eventName, resizeFunction);
        }
      },
      getStyleId: function(id)
      {
        return BigText.STYLE_ID + '-' + id;
      },
      generateStyleTag: function(id, css)
      {
        return $('<style>' + css.join('\n') + '</style>').attr('id', id);
      },
      clearCss: function(id)
      {
        var styleId = BigText.getStyleId(id);
        $('#' + styleId).remove();
      },
      generateCss: function(id, linesFontSizes, lineWordSpacings, minFontSizes)
      {
        var css = [];

        BigText.clearCss(id);

        for(var j=0, k=linesFontSizes.length; j<k; j++) {
          css.push('#' + id + ' .' + BigText.LINE_CLASS_PREFIX + j + ' {' +
            (minFontSizes[j] ? ' white-space: normal;' : '') +
            (linesFontSizes[j] ? ' font-size: ' + linesFontSizes[j] + 'px;' : '') +
            (lineWordSpacings[j] ? ' word-spacing: ' + lineWordSpacings[j] + 'px;' : '') +
            '}');
        }

        return BigText.generateStyleTag(BigText.getStyleId(id), css);
      },
      jQueryMethod: function(options)
      {
        BigText.init();
    
        options = $.extend({
              minfontsize: BigText.DEFAULT_MIN_FONT_SIZE_PX,
              maxfontsize: BigText.DEFAULT_MAX_FONT_SIZE_PX,
              childSelector: '',
              resize: true
            }, options || {});
      
        return this.each(function()
        {
          var $t = $(this).addClass('bigtext'),
            childSelector = options.childSelector ||
                  BigText.childSelectors[this.tagName.toLowerCase()] ||
                  BigText.DEFAULT_CHILD_SELECTOR,
            maxWidth = $t.width(),
            id = $t.attr('id');
    
          if(!id) {
            id = 'bigtext-id' + (counter++);
            $t.attr('id', id);
          }
    
          if(options.resize) {
            BigText.bindResize('resize.bigtext-event-' + id, function()
            {
              BigText.jQueryMethod.call($('#' + id), options);
            });
          }
    
          BigText.clearCss(id);
    
          $t.find(childSelector).addClass(function(lineNumber, className)
          {
            // remove existing line classes.
            return [className.replace(new RegExp('\\b' + BigText.LINE_CLASS_PREFIX + '\\d+\\b'), ''),
                BigText.LINE_CLASS_PREFIX + lineNumber].join(' ');
          });
    
          var sizes = calculateSizes($t, childSelector, maxWidth, options.maxfontsize, options.minfontsize);
          $headCache.append(BigText.generateCss(id, sizes.fontSizes, sizes.wordSpacings, sizes.minFontSizes));
        });
      }
    };

  function testLineDimensions($line, maxWidth, property, size, interval, units)
  {
    var width;
    $line.css(property, size + units);

    width = $line.width();

    if(width >= maxWidth) {
      $line.css(property, '');

      if(width == maxWidth) {
        return {
          match: 'exact',
          size: parseFloat((parseFloat(size) - 0.1).toFixed(3))
        };
      }

      return {
        match: 'estimate',
        size: parseFloat((parseFloat(size) - interval).toFixed(3))
      };
    }

    return false;
  }
  function calculateSizes($t, childSelector, maxWidth, maxFontSize, minFontSize)
  {
    var $c = $t.clone(true)
          .addClass('bigtext-cloned')
          .css({
            fontFamily: $t.css('font-family'),
            'min-width': parseInt(maxWidth, 10),
            width: 'auto',
            position: 'absolute',
            left: -9999,
            top: -9999
          }).appendTo(document.body);

    // font-size isn't the only thing we can modify, we can also mess with:
    // word-spacing and letter-spacing.
    // Note: webkit does not respect subpixel letter-spacing or word-spacing,
    // nor does it respect hundredths of a font-size em.
    var fontSizes = [],
      wordSpacings = [],
      minFontSizes = [],
      ratios = [];

    $c.find(childSelector).css({
      'float': 'left',
      'clear': 'left'
    }).each(function(lineNumber) {
      var $line = $(this),
        intervals = [4, 1, 0.4, 0.1],
        lineMax;

      if($line.hasClass(BigText.EXEMPT_CLASS)) {
        fontSizes.push(null);
        ratios.push(null);
        minFontSizes.push(false);
        return;
      }

      // TODO we can cache this ratio?
      var autoGuessSubtraction = 20, // px
        currentFontSize = parseFloat($line.css('font-size')),
        lineWidth = $line.width(),
        ratio = (lineWidth / currentFontSize).toFixed(6),
        newFontSize = parseFloat(((maxWidth - autoGuessSubtraction) / ratio).toFixed(3));

      outer: for(var m=0, n=intervals.length; m<n; m++) {
        inner: for(var j=1, k=4; j<=k; j++) {
          if(newFontSize + j*intervals[m] > maxFontSize) {
            newFontSize = maxFontSize;
            break outer;
          }

          lineMax = testLineDimensions($line, maxWidth, 'font-size', newFontSize + j*intervals[m], intervals[m], 'px');
          if(lineMax !== false) {
            newFontSize = lineMax.size;

            if(lineMax.match == 'exact') {
              break outer;
            }
            break inner;
          }
        }
      }

      ratios.push(maxWidth / newFontSize);

      if(newFontSize > maxFontSize) {
        fontSizes.push(maxFontSize);
        minFontSizes.push(false);
      } else if(!!minFontSize && newFontSize < minFontSize) {
        fontSizes.push(minFontSize);
        minFontSizes.push(true);
      } else {
        fontSizes.push(newFontSize);
        minFontSizes.push(false);
      }
    }).each(function(lineNumber) {
      var $line = $(this),
        wordSpacing = 0,
        interval = 1,
        maxWordSpacing;

      if($line.hasClass(BigText.EXEMPT_CLASS)) {
        wordSpacings.push(null);
        return;
      }

      // must re-use font-size, even though it was removed above.
      $line.css('font-size', fontSizes[lineNumber] + 'px');

      for(var m=1, n=5; m<n; m+=interval) {
        maxWordSpacing = testLineDimensions($line, maxWidth, 'word-spacing', m, interval, 'px');
        if(maxWordSpacing !== false) {
          wordSpacing = maxWordSpacing.size;
          break;
        }
      }

      $line.css('font-size', '');
      wordSpacings.push(wordSpacing);
    }).removeAttr('style');

    $c.remove();

    return {
      fontSizes: fontSizes,
      wordSpacings: wordSpacings,
      ratios: ratios,
      minFontSizes: minFontSizes
    };
  }

  $.fn.bigtext = BigText.jQueryMethod;
  window.BigText = BigText;

})(this, jQuery);

(function( $ ){

  $.fn.fitText = function( kompressor, options ) {

    // Setup options
    var compressor = kompressor || 1,
        settings = $.extend({
          'minFontSize' : Number.NEGATIVE_INFINITY,
          'maxFontSize' : Number.POSITIVE_INFINITY
        }, options);

    return this.each(function(){

      // Store the object
      var $this = $(this);

      // Resizer() resizes items based on the object width divided by the compressor * 10
      var resizer = function () {
        $this.css('font-size', Math.max(Math.min($this.width() / (compressor*10), parseFloat(settings.maxFontSize)), parseFloat(settings.minFontSize)));
      };

      // Call once to set.
      resizer();

      // Call on resize. Opera debounces their resize by default.
      $(window).on('resize orientationchange', resizer);

    });
  };

})( jQuery );


    jQuery("#holder div.fit").each(function(){
//	jQuery(this).fitText(jQuery(this).data('fitfactor'));
	jQuery(this).parent().bigtext();
  });    

    jQuery("#holder .fitinner").each(function(){
	jQuery(this).bigtext({childSelector: '> p'});
	jQuery(this).children('p').each(function(){
	    jQuery(this).css('line-height',jQuery(this).css('font-size'));
	});
  });    

    


    jQuery("#holder div div.fit").each(function(){
	jQuery(this).css({
	    position:'absolute',
	    right:'0px',
	    width:jQuery(this).parent().innerWidth()-40,
	    top: (jQuery(this).parent().innerHeight() - jQuery(this).outerHeight())/2
	});
    });

    jQuery("#footer").css("top",jQuery(document).height()-jQuery("#footer").height());

    
    jQuery(window).scroll(function(){
	var top = (jQuery(window).scrollTop() > 0) ? $(window).scrollTop() : 1;
	jQuery('#myCarousel').stop(true, true).fadeTo(100, 1 / top);
    });

    jQuery(".carousel").carousel();



    jQuery(window).resize(function (){
	var newheight = jQuery(window).height()-jQuery("#top").height() - 200;      
	jQuery("#heroCarousel").height(newheight);
	jQuery("#heroCarousel .item").height(newheight);
    });
    
    jQuery(window).resize();
    
    jQuery("#invoice_line_items").on("ajax:success",".best_in_place",recalculate_invoice_line_item); 
    jQuery("#line_items").on("ajax:success",".best_in_place",afterQuantityChange); //purchase_orders

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


