
$('#req-doc').trigger('click');

document.addEventListener("turbolinks:load", function() {
  $('#req-doc').trigger('click');

  $(function() {
    var support_request_type_id = $('#support_request_support_request_type__id').val()
    var startDate = $('.start-date')[0];
    var endDate = $('.end-date')[0];
    $('#support_request_support_request_type_id').change(function() {
        if(this.value === support_request_type_id) {
          endDate.style.display = 'block';
          startDate.style.display = 'block';
        }
        else{
          endDate.style.display = 'none';
          startDate.style.display = 'none';
        }
    })
  });

  $(function(){
    $('.datepicker').datepicker({
      format: 'mm-dd-yyyy'
    });
  });
});
   