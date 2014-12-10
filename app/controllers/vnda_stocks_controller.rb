class VndaStocksController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    FullSyncWorker.perform_async(store.id)
    render :json => {success: true}
  end
end
