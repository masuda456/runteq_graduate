$(function() {

  const dataContainer = $('#data-container');
  let offset = dataContainer.data('initial-load-count');
  const totalCount = dataContainer.data('total-count');
  const loadMoreCount = dataContainer.data('load-more-count');

  $('#load-more').on('click', function() {
    $.ajax({
      url: '/workout_schedules/load_more',
      data: { offset: offset },
      dataType: 'script',
      success: function() {
        offset += loadMoreCount;
        if ($('.workout-schedule').length >= totalCount) {
          $('#load-more').hide();
        }
      }
    });
  });

});