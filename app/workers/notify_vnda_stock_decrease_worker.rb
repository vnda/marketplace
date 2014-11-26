class NotifyVndaStockDecreaseWorker
  include Sidekiq::Worker

  def perform(store_id, params)
    store = Store.find_by(id: store_id)
    meli = store.meli
    params = {:access_token => meli.access_token}
    response = meli.get(params["resource"])
    order = JSON.parse(response.body)

    store.decrease_stock_from_ml(order)
  end
end
