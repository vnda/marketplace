class StocksController < ApplicationController

  def index
    puts params
    render :json => params
  end

  def create
    puts params
    render :json => params
  end

end
