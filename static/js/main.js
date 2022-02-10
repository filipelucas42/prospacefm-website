myLib = {
    toggleBurger: function(e){
        e.classList.toggle("is-active");
        document.querySelector("#nav-items-container").classList.toggle("is-active");
    }
}