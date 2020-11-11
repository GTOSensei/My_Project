$(document).on('turbolinks:load', function() {
    $("#showHideshipping").change(function () {
        if(this.checked)
        {
          $("#shipping").hide("slow");
        } else 
        {
          $("#shipping").show("slow");
        }        
    });
});