class FullSyncWorker
  include Sidekiq::Worker

  def perform(store_id)
    store = Store.find_by(id: store_id)
    store.send_all_to_ml
  end
end