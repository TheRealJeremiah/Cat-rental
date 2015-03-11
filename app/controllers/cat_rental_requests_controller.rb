class CatRentalRequestsController < ApplicationController
  before_action only: [:create, :new] do
    redirect_to cats_url unless logged_in?
  end

  before_action only: [:approve, :deny] do
    if !logged_in?
      redirect_to cats_url
    else
      set_rental_request_cat
      redirect_to cat_url(@cat) unless @cat.user_id == current_user.id
    end
  end

  def index
    @cat_rental_requests = CatRentalRequest.where(cat_id: params[:cat_id])
    render :index
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_params)
    @cat_rental_request.user_id = current_user.id
    @cat = Cat.find(@cat_rental_request.cat_id)

    if @cat_rental_request.save
      redirect_to cat_url(@cat)
    else
      set_cat_id_for_new_request
      render :new
    end
  end

  def new
    set_cat_id_for_new_request
    render :new
  end

  def approve
    set_rental_request_cat
    @cat_rental_request.approve!
    redirect_to cat_url(@cat)
  end

  def deny
    set_rental_request_cat
    @cat_rental_request.deny!
    redirect_to cat_url(@cat)
  end

  private

  def cat_rental_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

  def set_rental_request_cat
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat = Cat.find(@cat_rental_request.cat_id)
  end

  def set_cat_id_for_new_request
    @cat_rental_request = CatRentalRequest.new
    @cats = Cat.all
    @cat_id = params[:cat_id]
  end
end
