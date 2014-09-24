$( document ).ready(function() {
  $('.toggleLink').click(function(){
  $("#comment" + this.id).slideToggle();
  });      
  $('.colorpicker').colorpicker();
  jQuery(".chosen").data("placeholder","Select Frameworks...").chosen();
  $('#datepicker1').datepicker();
  $('.colorselect').click(function(){
    $('#colorSelector').ColorPicker({
      color: '#0000ff',
      onShow: function (colpkr) {
        $(colpkr).fadeIn(500);
        return false;
      },
      onHide: function (colpkr) {
        $(colpkr).fadeOut(500);
        return false;
      },
      onChange: function (hsb, hex, rgb) {
        $('#colorSelector div').css('backgroundColor', '#' + hex);
      }
    });
  });
});
