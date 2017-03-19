<?php

class ControllerProductPriceList extends Controller {

    public function index() {
        $this->load->language('product/price_list');
        $this->load->model('catalog/product');
        $this->load->model('tool/image');
        
        $this->document->addStyle('catalog/view/theme/default/stylesheet/price_list.css');

        $data['breadcrumbs'] = array();

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/home')
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title'),
            'href' => $this->url->link('product/price_list')
        );

        $this->document->setTitle($this->language->get('heading_title'));

        $data['heading_title'] = $this->language->get('heading_title');

        $data['text_refine'] = $this->language->get('text_refine');
        $data['text_empty'] = $this->language->get('text_empty');
        $data['text_quantity'] = $this->language->get('text_quantity');
        $data['text_manufacturer'] = $this->language->get('text_manufacturer');
        $data['text_model'] = $this->language->get('text_model');
        $data['text_price'] = $this->language->get('text_price');

        $data['button_cart'] = $this->language->get('button_cart');
        
        if($this->config->get('dco_status')) {
            $discounts = (array) $this->config->get('dco_threshold');
        }else{
            $discounts = array();
        }

        $data['products'] = array();

        $filter_data = array();

        $results = $this->model_catalog_product->getProducts($filter_data);

        foreach ($results as $result) {
            if ($result['image']) {
                $image = $this->model_tool_image->resize($result['image'], 200, 200);
            } else {
                $image = $this->model_tool_image->resize('placeholder.png', 200, 200);
            }

            if ($this->customer->isLogged() || !$this->config->get('config_customer_price')) {
                $price = $this->currency->format($this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
                $price_clear = $this->tax->calculate($result['price'], $result['tax_class_id'], $this->config->get('config_tax'));
            } else {
                $price = false;
            }
            
            if($discounts){
                $product_discount = array();
                if ((float) $result['special']) {
                    $product_price = $result['special'];
                }else{
                    $product_price = $result['price'];
                }
                foreach($discounts as $discount) {
                    $product_discount[] = $this->language->get('text_from') . $this->currency->format($discount['threshold'], $this->session->data['currency']) . ' - ' . $this->currency->format(($product_price - (($product_price/100) * $discount['discount_amount'])), $this->session->data['currency']);
                }
            }else{
                $product_discount = array(); 
            }

            if ((float) $result['special']) {
                $special = $this->currency->format($this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax')), $this->session->data['currency']);
                $special_clear = $this->tax->calculate($result['special'], $result['tax_class_id'], $this->config->get('config_tax'));
            } else {
                $special = false;
            }

            $data['products'][] = array(
                'product_id' => $result['product_id'],
                'thumb' => $image,
                'name' => $result['name'],
                'quantity' => $result['quantity'],
                'description' => utf8_substr(strip_tags(html_entity_decode($result['description'], ENT_QUOTES, 'UTF-8')), 0, $this->config->get($this->config->get('config_theme') . '_product_description_length')) . '..',
                'price' => $price,
                'price_clear' => $price_clear,
                'special' => $special,
                'special_clear' => $special_clear,
                'discounts' => $product_discount,
                'minimum' => $result['minimum'] > 0 ? $result['minimum'] : 1,
                'href' => $this->url->link('product/product', 'product_id=' . $result['product_id'])
            );
        }
        
        

        $data['column_left'] = $this->load->controller('common/column_left');
        $data['column_right'] = $this->load->controller('common/column_right');
        $data['content_top'] = $this->load->controller('common/content_top');
        $data['content_bottom'] = $this->load->controller('common/content_bottom');
        $data['footer'] = $this->load->controller('common/footer');
        $data['header'] = $this->load->controller('common/header');

        $this->response->setOutput($this->load->view('product/price_list', $data));
    }

}
