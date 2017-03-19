$(document).ready(function () {
    $('body').on('change', '.quantity', function () {
        $('body').find('input.quantity').each(function (index, element) {
            var minimum = $(element).data('min');
            var cval = parseInt($(element).val());
            if (minimum > 1 || minimum % cval) {
                for (n = 1; n < minimum; n++) {
                    var new_q = cval + n;
                    if (!(new_q % minimum)) {
                        $(element).val(new_q);
                        $(element).after('<div class="min-alert">Кол-во изменено на кратное мнимальному!</div>');
                    }
                }
            }
        });
        setTimeout(function () {
            $('.min-alert').fadeOut(1000, function () {
                $('.min-alert').remove();
            });
        }, 1500)
    });
});
cart.add = function (product_id,quantity) {
        $.ajax({
            url: 'index.php?route=checkout/cart/add',
            type: 'post',
            data: 'product_id=' + product_id + '&quantity=' + $('#input-quantity_' + product_id).val(),
            dataType: 'json',
            beforeSend: function () {
                $('#cart > button').button('loading');
            },
            complete: function () {
                $('#cart > button').button('reset');
            },
            success: function (json) {
                $('.alert, .text-danger').remove();

                if (json['redirect']) {
                    location = json['redirect'];
                }

                if (json['success']) {
                    $('#content').parent().before('<div class="alert alert-success"><i class="fa fa-check-circle"></i> ' + json['success'] + ' <button type="button" class="close" data-dismiss="alert">&times;</button></div>');

                    // Need to set timeout otherwise it wont update the total
                    setTimeout(function () {
                        $('#cart > button').html('<span id="cart-total"><i class="fa fa-shopping-cart"></i> ' + json['total'] + '</span>');
                    }, 100);

                    $('html, body').animate({scrollTop: 0}, 'slow');

                    $('#cart > ul').load('index.php?route=common/cart/info ul li');
                }
            },
            error: function (xhr, ajaxOptions, thrownError) {
                alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
            }
        });
    };