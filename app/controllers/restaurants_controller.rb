class RestaurantsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_current_user, only: [:destroy, :update]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    # if @restaurant.user_id != current_user.id
    #   flash[:notice] = 'You cannot edit this restaurant'
    #   redirect_to restaurants_path
    # else
      render 'edit'
    # end
  end

  def update
    unless @restaurant.update(restaurant_params)
      errors = @restaurant.errors[:base].join(', ')
      flash[:notice] = errors
    end
    redirect_to '/restaurants'
  end

  def destroy
    if @restaurant.destroy
      flash[:notice] = 'Restaurant deleted successfully'
      redirect_to '/restaurants'
    else
      errors = @restaurant.errors[:base].join(', ')
      flash[:notice] = errors
      redirect_to '/restaurants'
    end
  end

  private

  def set_current_user
    @restaurant = Restaurant.find(params[:id])
    @restaurant.current_user = current_user
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end

end
