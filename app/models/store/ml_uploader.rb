load 'lib/vnda_api/products.rb'
load 'lib/meli.rb'

module Store::MlUploader
  
  module InstanceMethods
    
    def send_to_ml(ml_product, product_id, sku)
      params = {:access_token => meli.access_token}
      response = meli.post("/items", ml_product, params)
      JSON.parse response.body

      self.ml_products.create(vnda_id: product_id, vnda_sku: sku, ml_id: response['id'])
      logger.info  "Product sent to ml #{ml_product[:title]}"
    end

  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end