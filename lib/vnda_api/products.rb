require 'httparty'
require 'pp'

module VndaApi
  class Products
    include HTTParty
    format :json

    def initialize(base_uri, user, password)
      @base_uri = base_uri
      @auth = {username: user, password: password}
    end

    def all
      products = []
      last_page = 1
      response = self.products(last_page)
      while !response.empty? do
        products.concat(response)
        last_page += 1
        response = self.products(last_page)
      end
      products
    end

    def after_date
      products = []
      last_page = 1
      response = self.products_after(last_page)
      while !response.empty? do
        products.concat(response)
        last_page += 1
        response = self.products_after(last_page)
      end
      products
    end

    def products(last_page)
      get("http://#{@base_uri}/api/v2/products?per_page=100&page=#{last_page}")
    end

    def products_after(after_date, last_page)
      get("http://#{@base_uri}/api/v2/products?per_page=100&page=#{last_page}&updated_after=#{after_date.to_s}")
    end

    def variants(product_id)
      get("http://#{@base_uri}/api/v2/products/#{product_id}/variants")
    end

    def images(product_id)
      get("http://#{@base_uri}/api/v2/products/#{product_id}/images")
    end

    def variant_images(product_id, variant_sku)
      get("http://#{@base_uri}/api/v2/products/#{product_id}/variants/#{variant_sku}/images")
    end

    def quantity(variant_sky)
      get("http://#{@base_uri}/api/v2/variants/#{variant_sky}/quantity")
    end

    def decrease_quantity(variant_sky, quantity)
      get("http://#{@base_uri}/api/v2/variants/#{variant_sky}/sold/#{quantity}")
    end

    private
    def get(url)
      JSON.parse(self.class.get(url, {basic_auth: @auth}).body)
    end
  end
end