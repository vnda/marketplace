class Store < ActiveRecord::Base
  before_create :generate_token

  validates :name, :api_url, :api_user, :api_password, presence: true

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end
