class MlProduct < ActiveRecord::Base
  belongs_to :store
  
  validates :vnda_id, :vnda_sku, :ml_id, presence: true
end
