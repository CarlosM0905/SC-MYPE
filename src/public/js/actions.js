
function showLog(){
    console.log('sdad');
    let login = document.getElementById("shadow");
    console.log( login.class);
    if(login.className.localeCompare("d-block")){
      $("#shadow").toggleClass("d-block", "d-none");
      jqc
    }
    
    else if(login.className.localeCompare("d-none")){
        $("#shadow").toggleClass("d-none", "d-block");
    }
}