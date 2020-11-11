
function check() {
    var check = document.getElementById('check');  
    var btn = document.getElementById('btn');
    check.checked ? btn.disabled = false : btn.disabled = true;
}
function checkParams() {
    var cur_pas = $('#cur_pas').val();
    var pass = $('#pass').val();
    var conf_pas = $('#conf_pas').val();
     
    if(cur_pas.length != 0 && pass.length != 0 && conf_pas.length != 0) {
        $('#btn_save').removeAttr('disabled');
    } else {
        $('#btn_save').attr('disabled', 'disabled');
    }
}
function radio_btn()
{ if (!$(':radio:checked').is(":checked")) {      
      document.getElementById("txt").style.display="block";   
    } else { 
        document.getElementById("txt").style.display="none"; 
    }
}


