<?php echo $header; ?>
<div class="container">
    <ul class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) { ?>
            <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
        <?php } ?>
    </ul>
    <!--COUPON_BAR-->
    <div class="row row-margin input-group hidden">
    	<form action="" method="get" id="coupon_form">
        	<input type="hidden" id="discount_value">
        	<div class="row">
            	<div class="col-lg-7">
                	<input name="code" id="coupon_code" type="text" placeholder="Номер купона" class="input-lg" autocomplete="off" spellcheck="false"
                    maxlength="20">
                </div>
                <!--
                <div class="col-lg-2">
                	<label class="control-label" for="input-option225">Delivery Date</label>
                </div>
                <div class="col-lg-3">
                    <div class="input-group date">
                        <input type="text" name="option[225]" value="<?php echo date('Y-m-d');?>" data-date-format="YYYY-MM-DD" id="input-option225" class="form-control">
                        <span class="input-group-btn">
                            <button class="btn btn-default" type="button"><i class="fa fa-calendar"></i></button>
                        </span>
                    </div>                	
                </div>
                -->
                <div class="col-lg-5">
                    <button class="btn btn-default btn-lg submit_btn">Применить</button>
                </div>
            </div>
        </form>
    </div>
    
    <div class="alert alert-danger" id="wrong_code">
        <i class="fa fa-exclamation-circle"></i>
        <span></span>
        <button type="button" class="close" data-close="wrong_code">x</button>
    </div>
    <div class="alert alert-success" id="code_ok">
    	<i class="fa fa-check-circle"></i>
        <span></span>
        <button type="button" class="close" data-close="code_ok">x</button>
    </div>
    <div class="row"><?php echo $column_left; ?>
        <?php if ($column_left && $column_right) { ?>
            <?php $class = 'col-sm-6'; ?>
        <?php } elseif ($column_left || $column_right) { ?>
            <?php $class = 'col-sm-9'; ?>
        <?php } else { ?>
            <?php $class = 'col-sm-12'; ?>
        <?php } ?>
        <div id="content" class="<?php echo $class; ?>"><?php echo $content_top; ?>
            <?php if ($products) { ?>
                <div class="row">
                    <?php foreach ($products as $product) { ?>
                        <div class="product-layout col-lg-3 col-md-3 col-sm-6 col-xs-12">
                            <div class="product-thumb transition">
                                <div class="image"><img src="<?php echo $product['thumb']; ?>" alt="<?php echo $product['name']; ?>" title="<?php echo $product['name']; ?>" class="img-responsive" /></div>
                                <div>
                                    <div class="caption">
                                        <h4><?php echo $product['name']; ?></h4>
                                        <p><?php echo $product['description']; ?></p>
                                        <p>
                                            <label class="control-label" for="input-quantity"><?php echo $text_quantity; ?></label>
                                            <input type="number" data-min="<?php echo $product['minimum']; ?>" data-max="<?php echo $product['quantity']; ?>" name="quantity" value="0" size="2" id="input-quantity_<?php echo $product['product_id']; ?>" class="form-control quantity" data-id="<?php echo $product['product_id']; ?>">
                                            <input type="hidden" id="price_<?php echo $product['product_id']; ?>" value="<?php echo!$product['special_clear'] ? $product['price_clear'] : $product['special_clear']; ?>">
                                            <input type="hidden" id="sum_<?php echo $product['product_id']; ?>" class="product_sum" value="0">
                                        </p>
                                    </div>
                                    <div class="button-group price-cont">
                                        <span class="hidden-xs hidden-sm hidden-md" id="price_show_<?php echo $product['product_id']; ?>">
                                            <?php if ($product['price']) { ?>
                                                <?php if (!$product['special']) { ?>
                                                    <?php echo $product['price']; ?>
                                                <?php } else { ?>
                                                    <?php echo $product['special']; ?>
                                                <?php } ?>
                                            <?php } ?>
                                        </span>
                                        <?php if($product['discounts']){ ?>
                                        <div class="discounts">
                                            <?php foreach($product['discounts'] as $discount){ ?>
                                            <div><?php echo $discount; ?></div>
                                            <?php } ?>
                                        </div>    
                                        <?php } ?>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <?php } ?>
                </div>
                <br />
                <br />
                <div class="row row-margin">
                    <h2>Всего: Руб. <span id="total_sum">0</span></h2>
                </div>

                <div class="alert alert-danger" id="wrong_cart">
                    <i class="fa fa-exclamation-circle"></i>
                    <span>Ошибка</span>
                    <button type="button" class="close" data-close="wrong_cart">x</button>
                </div>

                <div class="row">
                    <div class="col-sm-4">
                        <form action="" method="post" id="add_to_cart">
                            <button type="submit" id="button-cart" data-loading-text="Loading..." class="btn btn-primary btn-lg btn-block">Добавить в корзину</button>
                            <input type="hidden" id="redirect">
                        </form>
                    </div>
                </div>
            <?php } ?>
            <?php echo $content_bottom; ?></div>
        <?php echo $column_right; ?></div>
</div>
<script>
//COUNT SUM:
    $('body').on('change', '.quantity', function () {
        validation();
        var id = $(this).data('id');
        var p = parseFloat($('#price_' + id).val().replace(/\,/g, ''));
        var s = p * parseInt($(this).val().replace(/\,/g, ''));
        $('body input[id="sum_' + id + '"]').val(s);
        
        sum();
    });
    function sum() {
        var sum = 0;
        $('body').find('.product_sum').each(function (index, element) {
            sum += parseFloat($(this).val().replace(/\,/g, ''));
        });
        sum = sum.toFixed(2);
        $('#total_sum').text(null).text(sum);
    }
    function validation() {
        $('body').find('input.quantity').each(function (index, element) {
            var minimum = $(element).data('min');
            var cval = parseInt($(element).val());
            if(minimum > 1 || minimum%cval){
                for (n=1; n<minimum; n++) {
                    var new_q = cval + n;
                    if (!(new_q%minimum)) {
                        $(element).val(new_q);
                        $(element).after('<div class="min-alert">Кол-во изменено на кратное мнимальному!</div>');
                    }
                }
            }
        });
        
        
        setTimeout(function() { $('.min-alert').fadeOut(1000, function(){ $('.min-alert').remove(); }); }, 1500)

    }
//USE COUPON
    $('#coupon_form').on('submit', function (e) {
        e.preventDefault();

        var c = $('#coupon_code').val();

        $.ajax({
            url: 'index.php?route=extension/total/coupon/coupon',
            type: 'post',
            data: 'coupon=' + c,
            dataType: 'json',
            success: function (json) {
                if (json['error']) {
                    $('.alert').hide();
                    $('#wrong_code').show();
                    $('#wrong_code span').text(json['error']);
                } else if (json['redirect']) {
                    $('.alert').hide();
                    $('#code_ok').show();
                    $('#code_ok span').text('Спасибо. Ваш купон принят!');
                    $('#redirect').val(json['redirect']);
                    convert_prices();
                }
            }
        });
    });
//CLOSE ALERT BOX
    $('body').on('click', 'button.close', function (e) {
        e.preventDefault();
        $('#' + $(this).data('close')).hide();
    });
//CHECK COUPON DOSCOUNT VALUE:
    function convert_prices() {
        //CHECK:
        var c = $('#coupon_code').val();
        $.ajax({
            url: window.location.href,
            type: 'post',
            data: 'coupon=' + c,
            dataType: 'json',
            success: function (json) {
                $('#discount_value').val(json['val']);
                format_prices();
            }
        });
    }
//FORMAT PRICES WITH DISCOUNT:
    function format_prices() {
        var d = parseFloat($('#discount_value').val());
        if (d == 0) {
            return false
        }

        $('body').find('.quantity').each(function (index, element) {
            //read
            var id = $(this).data('id');
            var p = parseFloat($('#price_' + id).val().replace(',', ''));
            var n = (p * ((100 - d) / 100)).toFixed(2);
            //set
            $('#price_' + id).val(n);
            $('#price_show_' + id).text('$' + n);
        });
        sum();
    }
//SUBMIT -> ADD TO CART:
    $('#add_to_cart').on('submit', function (e) {
        e.preventDefault();

        var t = $('#add_to_cart button').text(), s = 0, er = 0, total = 0;
        $('#add_to_cart button').text($('#add_to_cart button').data('loading-text'));

        //total:
        $('body').find('.quantity').each(function (index, element) {
            var q = parseInt($(this).val());
            var id = parseInt($(this).data('id'));
            if (q > 0) {
                total = total + 1
            }
        });

        $('body').find('.quantity').each(function (index, element) {
            var q = parseInt($(this).val());
            var id = parseInt($(this).data('id'));
            if (q > 0) {
                $.ajax({
                    url: 'index.php?route=checkout/cart/add',
                    type: 'post',
                    data: 'product_id=' + id + '&quantity=' + q,
                    dataType: 'json',
                    success: function (json) {
                        //count returns
                        if (json['error']) {
                            er = er + 1
                        } else {
                            s = s + 1
                        }
                        var sum = s + er;
                        //callback
                        if (sum == total) {
                            $('#add_to_cart button').text(t);
                            submit_cart(er);
                        }
                    }
                });
            }
        });
    });
//redirect or alert
    function submit_cart(er) {
        if (er > 0) {
            $('#wrong_cart').show()
        } else {
            window.location.href = 'index.php?route=checkout/cart'
        }
    }
</script>
<?php echo $footer; ?>
