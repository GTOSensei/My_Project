$(document).on('turbolinks:load', function() {
  $(".input-link").on("click", function(e) {
    e.preventDefault();                               
    var $inp = $(this).closest("div").find("input"),  
        isUp = $(this).is(".quantity-plus"),      
        currVal = parseInt($inp.val(), 10);           
    $inp.val(Math.max(1, currVal += isUp ? 1 : -1));  
  });
});