class CatsController < ApplicationController
  before_action only: [:new, :create] do
    redirect_to cats_url unless logged_in?
  end

  before_action only: [:update, :edit] do
    if logged_in?
      @cat = Cat.find(params[:id])
      redirect_to cats_url unless @cat.user_id == current_user.id
    else
      redirect_to cats_url
    end
  end

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @cat_rental_requests = @cat.cat_rental_requests.order(:start_date)
    render :show
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      # flash
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      # flash
      render :edit
    end
  end

  def new
    @cat = Cat.new
    render :new
  end

  private

  def cat_params
    params.require(:cat).permit(:birth_date, :color, :name, :sex, :description)
  end
end
