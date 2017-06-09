$(document).ready(function () {
  setInterval(refreshPartial, 600000)
  $('body').on('click', '#link_update', function() {
    refreshPartial()
  })
});

function refreshPartial() {
  var array = window.location.href.split('/')
  var site_name = array[0] +'//' + array[1] + array[2] + '/'
  var full_url = site_name + 'conversations/refresh_unread_messages'
  $.ajax({
    url: full_url,
    dataType: 'json',
    success: function(data) {
      $('#unread_messages').text(data.content);
    }
 })
}
