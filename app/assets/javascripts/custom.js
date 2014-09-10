$(function(){
  $('.toggleLink').click(function(){
    $("#comment" + this.id).slideToggle();
  });
});