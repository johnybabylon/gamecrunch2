class WelcomeController < ApplicationController

  def home

  end






  def index
    @countries = Country.all
    @cities = City.where("country_id = ?", Country.first.id)
    @user = current_user
  end

  def show
    @country = Country.find_by("id = ?", params[:trip][:country_id])
    @city = City.find_by("id = ?", params[:trip][:city_id])
    @user = current_user
    @user.team = @city.name
    @user.league = @country.name
    @user.save
  end

  def update_cities
    @cities = City.where("country_id = ?", params[:country_id])
    respond_to do |format|
      format.js
    end
  end



end
