$('#test-link').on('click', function(evt) {
    evt.preventDefault();

    $.ajax({
        url: '/test',
        type: 'get'
    }).done(function(data) {
        console.log(data);
    }).fail(function() {
        console.log('fail');
    });
});