load 'lib/vnda_api/products.rb'
load 'lib/meli.rb'

module Store::ProductLoader
  
  module InstanceMethods
    def api
      @api ||= VndaApi::Products.new(api_url,api_user,api_password)
    end

    def send_all_to_ml
      products = self.last_update.nil? ? api.all : api.after_date(self.last_update)
      logger.info  "Loaded #{products.count} products"

      products.each_with_index do |product,index|
        category = category_for(product)

        next unless category
        process_product(product, category)
      end
      self.last_update = DateTime.now
      self.save
      logger.info  "Products sent - #{products.count}."
    end

    def process_product(product, category)
      variants = api.variants(product["id"])
      product['images'] = api.images(product["id"])
      product['variants'] = []
      variants.each do |variant|
        variant['quantity'] = api.quantity(variant['sku'])['quantity']
        ml_product = ml_product_for(product, variant, category.upcase)
        send_to_ml(ml_product, product['id'], variant['sku']) if ml_product
      end
    end

    def category_for(product)
      product["tag_names"].select {|x| x.start_with?('mlb')}.first
    end

    def ml_product_for(product, variation, category)
      settings = category_settings(category)
      already_sent_product = self.ml_products.find_by(vnda_id: product['id'].to_s, vnda_sku: variation['sku'].to_s)
      ml_product = {
        title: title(product, variation, settings),
        price: product['price'],
        currency_id: "BRL",
        available_quantity: available_quantity(variation, category),
        condition:"new",
        pictures: pictures_for(product['images'], settings["max_pictures_per_item"])
      }
      unless already_sent_product
        ml_product.merge!(
        {
          category_id: category,
          listing_type_id: "bronze",
          description: description(product, settings),
        })
      end
      ml_product
    end

    def pictures_for(product_images, max_images)
      ml_images = []
      product_images.each_with_index do |image, index|
        next if index + 1 > max_images
        ml_images << {source: "http:#{image['url']}"}
      end
      ml_images
    end

    def category_settings(category)
      category_data = JSON.parse(Meli.new.get("/categories/#{category}").body)["settings"]
    end

    def title(product, variation, settings)
      title = "#{product['name']} #{variation['name']}"
      if title.length > settings["max_title_length"]
        title.truncate(settings["max_title_length"], omission: '')
      end
      title
    end

    def description(product, settings)
      description = product['description']
      if description && description.length > settings["max_description_length"]
        description.truncate(settings["max_description_length"], omission: '')
      end
      description
    end

    def available_quantity(variation, category)
      settings = JSON.parse(Meli.new.get("/categories/#{category}/listing_types/bronze").body)
      max_stock = settings["configuration"]["max_stock_per_item"]
      (variation['quantity'] > max_stock) ? max_stock : variation['quantity']
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end