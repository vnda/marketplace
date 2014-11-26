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
        logger.info  "Product data updated in ml #{ml_product[:title]}"
      else
        response = meli.post("/items", ml_product, params)
        json = JSON.parse response.body
        self.ml_products.create(vnda_id: product_id, vnda_sku: sku, ml_id: json['id']) unless ml_product[:id]
        logger.info  "Product sent to ml #{ml_product[:title]}"
      end
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end