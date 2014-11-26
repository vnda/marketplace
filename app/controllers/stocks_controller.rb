class StocksController < ApplicationController

  def index
    puts params
    render :json => params
  end

end
