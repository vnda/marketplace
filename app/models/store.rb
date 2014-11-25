class Store < ActiveRecord::Base
  include Store::ProductLoader
  include Store::MlUploader

  before_create :generate_token
  has_many :ml_products

  validates :name, :api_url, :api_user, :api_password, presence: true

  def meli
    @meli ||= begin
      @meli = Meli.new(ml_app_id, ml_secret, ml_token, ml_refresh_token)
      @meli.get_refresh_token
      self.ml_refresh_token = @meli.refresh_token
      self.save
      @meli
    end
  end

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end
