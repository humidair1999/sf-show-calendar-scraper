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
        $('#show-list').empty();

        $.each(data, function(idx, element) {
            $('#show-list').append('<li>' + element.title + ' @ ' + element.date + '</li>');
        });
    }).fail(function() {
        console.log('fail');
    });
});