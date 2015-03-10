class CatRentalRequestsController < ApplicationController
  def index
    @cat_rental_requests = CatRentalRequest.where(cat_id: params[:cat_id])
    render :index
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_params)
    @cat = Cat.find(@cat_rental_request.cat_id)
    if @cat_rental_request.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def new
    @cat_rental_request = CatRentalRequest.new
    @cats = Cat.all
    @cat_id = params[:cat_id]
    render :new
  end

  private

  def cat_rental_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
