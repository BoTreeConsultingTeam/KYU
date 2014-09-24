$( document ).ready(function() {
  $(".i-preview").hide(); 
  $('.toggleLink').click(function(){
  $("#comment" + this.id).slideToggle();
  });      
  $('#datepicker1').datepicker();
  $("#search").keyup(function() {
    $('#search_preview').empty();
    $('.i-preview').hide();
    if ($('#search').val().length <= 3){
      $('#search_preview').hide();
    }
    if ($('#search').val().length > 3){
      if($('#search_preview').is(':hidden')){
        $("#search_preview").show("fast");
      }
      $.ajax({
        async: false,
        type: "GET",
        cache: false,
        url: "/questions/search_by_keyword.json?keyword="+this.value,
        data: {},
        dataType: 'json'
        })
      .done(function( msg ) {
        if(msg.length == 0){
          $('#search_preview').append("<div class = 'i-preview'><a href='#'><div class='i-preview-content'><span class= 'i-preview-title'>No Suggestion Found</span></div></a></div>");
        }else{
          $('#search_preview').empty();
          $('.i-preview').hide();
          var i;
          for(i=0;i<msg.length;i++){
            $('#search_preview').append("<div class = 'i-preview'><a href='/questions/"+msg[i][0]+"'><div class='i-preview-content'><span class= 'i-preview-title'>"+msg[i][1]+"</span></div></a></div>");
          }
        };
      });
    };
  });
  if ($.trim($('i-preview').html()) == '') { $("#search_preview").hide(); }
  $(document).mouseup(function (e){
    var container = $(".i-preview");
    if (!container.is(e.target)
      && container.has(e.target).length === 0){
      container.hide();
      $('#search_preview').hide();
    }
  });
});
