load 'lib/vnda_api/products.rb'
load 'lib/meli.rb'

module Store::MlUploader
  
  module InstanceMethods
    
    def send_to_ml(ml_product, product_id, sku)
      params = {:access_token => meli.access_token}
      already_sent_product = self.ml_products.find_by(vnda_id: product_id.to_s, vnda_sku: sku.to_s)

      if already_sent_product
        response = meli.put("/items/#{already_sent_product.ml_id}", ml_product, params)
        json = JSON.parse response.body
        puts json
        logger.info  "Product data updated in ml #{ml_product[:title]}"
      else
        puts ml_product
        response = meli.post("/items", ml_product, params)
        json = JSON.parse response.body
        puts json
        self.ml_products.create(vnda_id: product_id, vnda_sku: sku, ml_id: json['id']) unless ml_product[:id]
        logger.info  "Product sent to ml #{ml_product[:title]}"
      end
    end

    def decrease_stock_from_ml(order)
      order["order_items"].each do |order_item|
        ml_item_id = order_item['item']['id']
        quantity = order_item['quantity']
        ml_product = self.ml_products.find_by(ml_id: ml_item_id)
        api.decrease_quantity(ml_product.vnda_sku, quantity) if ml_product
      end
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end