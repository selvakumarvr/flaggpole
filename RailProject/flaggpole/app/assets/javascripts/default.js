// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready( function(){
  $(".zip").autocomplete({
    url: "/portal/twitter_zips.js",
    minChars: 3,
    maxItemsToShow: 20,
    mustMatch: 1,
    matchSubset: 0,
    showResult: function(value, data) {
      return '<span>' + data[0] + ' ' + value + '</span>';
    },
    onItemSelect: function(item){
      $(".zip").each(function(){
        // only update the current item
        if(item.value == $(this).val()) {
          getFollowerCount($(this));
        }
      });
    },
  });

  getFollowerCount = function(zip){
    var zip_count = zip.parent().find(".zip_count");
    if(zip.val().length == 5) {
      $.getJSON('/portal/twitter_zips/'+zip.val()+'/followers_count.json', function(data){
          zip_count.val(data);
          updateTotalReached();
      });
    }
    else {
      zip_count.val(0);
    }
  };

  updateTotalReached = function(){
    var total = 0;
    $(".zip_count").each(function(){
      var c = $(this).val();
      total += parseInt(c, 10);
    });
    $("#totalreach").text(total);    
  };

  $("#promotion_message").counter();

});
