class StoresController < ApplicationController
  before_filter :authenticate!
  helper_method :resource, :collection

  def index
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if resource.save
        format.html { redirect_to stores_path, notice: I18n.t(:create, scope: [:flashes, :store]) }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if resource.update(store_params)
        format.html { redirect_to stores_path, notice: I18n.t(:update, scope: [:flashes, :store]) }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    resource.destroy
    respond_to do |format|
      format.html { redirect_to stores_path, notice: I18n.t(:destroy, scope: [:flashes, :store]) }
    end
  end

  private

  def collection
    @collection ||= Store.order(:name)
  end

  def resource
    @resource ||= params[:id] ? Store.find(params[:id]) : Store.new(store_params)
  end

  def store_params
    params[:store].try(:permit, :name, :api_url, :api_user, :api_password)
  end
end
