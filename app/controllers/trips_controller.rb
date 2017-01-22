# Trip Controller
class TripsController < ApplicationController
  before_filter :require_login, only: [:new]
  impressionist actions: [:show], unique: [:session_hash]

  def new
    @trip = Trip.new
  end

  def show
    @users = User.all
    @trip = Trip.find(params[:id])
    @trips = Trip.all
    @likeable = @trip.like(@trip, current_user)
    impressionist(@trip)
    @user = @trip.user
    respond_to do |format|
      format.html {}
    end
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.waypoints = @trip.checkpoint_address(params["trip"])
    @trip.user_id = current_user.id
    if @trip.valid? && @trip.errors.blank?
      @trip.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Trip Created!' }
      end
    else
      redirect_to root_path, notice: 'Trip cannot be Created!'
    end
  end

  def edit
    @users = User.all
    @trip = Trip.find(params[:id])
    respond_to do |format|
      format.html {}
    end
  end

  def update
    @trip = Trip.find(params[:id])
    params["trip"]["main_image"] = Trip.find(params[:id]).main_image if params["trip"]["main_image"].present? == false
    @trip.waypoints = @trip.checkpoint_address(params["trip"])
    if @trip.valid? && @trip.errors.blank?
      @trip.update(trip_params)
      # elastic search update index
      Trip.searchkick_index.refresh 
      respond_to do |format|
        format.html { redirect_to trip_path, notice: 'Trip Updated!' }
      end
    else
      redirect_to trip_path, notice: 'Trip cannot be Updated!'
    end
  end

  def index
    if params[:query].present?
      @trips = Trip.search(params)
    else
      @trips = Trip.all.page(params[:page]).per(6)
    end
    @trips.each do |trip|
      if trip.present?
        @trip = @trips.first
      else
        redirect_to trips_path, notice: 'No events'
      end
    end
  end

  def like
    @trip = Trip.find(params[:trip])
    Like.create(likeable: @trip, user: current_user, like: params[:like])
    respond_to do |format|
      format.html do
        flash[:success] = "Like Counted!"
        redirect_to :back
      end
      format.js
    end
  end

  def list_trip
    if params[:query].present?
      @trips = Trip.search(params)
    else
      @trips = Trip.order("updated_at desc").page(params[:page]).per(5)
    end
    @recent_trips = Trip.all.order("updated_at desc")
  end

  private

  def trip_params
    params.require(:trip).permit(:title, :description, :content, :main_image, :from_address, :to_address, :waypoints)
  end
end
