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

    def after_date(date)
      products = []
      last_page = 1
      response = self.products_after(date, last_page)
      while !response.empty? do
        products.concat(response)
        last_page += 1
        response = self.products_after(date, last_page)
      end
      products
    end

    def products(last_page)
      get("http://#{@base_uri}/api/v2/products?per_page=100&page=#{last_page}")
    end

    def products_after(after_date, last_page)
      get("http://#{@base_uri}/api/v2/products?per_page=100&page=#{last_page}&updated_after=#{after_date.xmlschema}")
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

    def quantity(variant_sku)
      get("http://#{@base_uri}/api/v2/variants/#{variant_sku}/quantity")
    end

    def decrease_quantity(variant_sku, quantity)
      post("http://#{@base_uri}/api/v2/variants/#{variant_sku}/sold/#{quantity}")
    end

    private
    def get(url)
      JSON.parse(self.class.get(url, {basic_auth: @auth}).body)
    end

    def post(url)
      JSON.parse(self.class.post(url, {basic_auth: @auth}).body)
    end
  end
end