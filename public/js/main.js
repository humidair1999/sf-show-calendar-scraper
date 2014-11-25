$('#find-slims').on('click', function(evt) {
    var selectedMonth = $('#select-month').val();

    console.log(selectedMonth);

    evt.preventDefault();

    $.ajax({
        url: '/test',
        type: 'get',
        data: {
            month: selectedMonth
        }
    }).done(function(data) {
        console.log(data);
    }).fail(function() {
        console.log('fail');
    });
});