$( document ).ready(function() {
  $('.toggleLink').click(function(){
    $("#comment" + this.id).slideToggle();
  });      
  jQuery(".chosen").data("placeholder","Select Frameworks...").chosen();
});
