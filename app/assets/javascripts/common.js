$( document ).ready(function() {
  $('.toggleLink').click(function(){
  $("#comment" + this.id).slideToggle();
  });      
  jQuery(".chosen").data("placeholder","Select Frameworks...").chosen();

  $('#datepicker1').datepicker();

	$('a.vote, input#comment-box').on('click', function() { 
    blockUI();
  });

  $('body').on('click', 'a.delete-comment', function() { 
    blockUI();
  });


	var leftHeight = $('.main-content').height();
    $('.right-sidebar').css({'height':leftHeight});
    $('.left-sidebar').css({'height':leftHeight});

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