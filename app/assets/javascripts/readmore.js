    window.onload = function(){
        blok = document.getElementById('ta');
        parent = blok.parentNode;
        blok_height = blok.style.height ? blok.style.height : blok.offsetHeight;
        
        if(blok_height > 60){
            blok.style.maxHeight = '60px';
            link = parent.getElementsByClassName('read-next')[0];
            link.style.display = 'inline'; 
                        
            link.onclick = function(){
                                
                if(blok.style.maxHeight){
                   blok.style.maxHeight = ''
                   link.innerHTML = 'Hide';
                } else {
                   blok.style.maxHeight = '60px';
                   link.innerHTML = 'Read More';                   
                }
                
                return false;
            } 
        
        }
    }
