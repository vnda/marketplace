class StocksController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    puts params
    render :json => params
  end

  def create
    puts params
    render :json => params
  end

end
