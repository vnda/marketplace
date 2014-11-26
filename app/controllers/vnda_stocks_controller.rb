class VndaStocksController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    puts params
    #NotifyMlStockDecreaseWorker.perform_async(store.id, params)
    render :json => {success: true}
  end

end
