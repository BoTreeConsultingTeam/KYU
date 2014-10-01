$( document ).ready(function() {
  $(".i-preview").hide(); 
  $('#basic_info').addClass('active');
  $('#default_link').addClass('active');
  $('.toggleLink').click(function(){
    $("#comment" + this.id).slideToggle();
  });
  $('#datepicker1').datepicker({
    format: 'yyyy-mm-dd'
  });
  $('.colorpicker').colorpicker();
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

  $('a.vote, input#comment-box').on('click', function() { 
    blockUI();

  });
  $('.profile_link').on('click', function(){
    $('.user_tab').removeClass("active");
    blockUI();
    $(this).addClass('active');
  });
  $('.questions_filter_link').on('click', function(){
    $('.filter_link').removeClass("active");
    blockUI();
    $(this).addClass('active');
  });

  $('.user_filter_link').on('click', function(){
    $('.user_link').removeClass("active");
    blockUI();
    $(this).addClass('active');
  });

  $('body').on('click', 'a.delete-comment', function() { 
    blockUI();
  });

  $('body').on('click', 'a.disable, a.enable, a.report_abuse, a.delete-disabled-question', function() { 
    blockUI();
  });

  var document_height = $('.main-content').height();
  var right_sidebar_height = $('.right-sidebar').height();
  if (document_height < right_sidebar_height) {
    document_height = right_sidebar_height;
  };
  $('.right-sidebar').css('min-height',document_height);
  $('.left-sidebar').css('height',document_height); 

});

function blockUI(){
	$.blockUI({ css: { 
        border: 'none', 
        padding: '15px', 
        backgroundColor: '#000', 
        '-webkit-border-radius': '10px', 
        '-moz-border-radius': '10px', 
        opacity: .5, 
        color: '#fff' 
    }}); 
};
