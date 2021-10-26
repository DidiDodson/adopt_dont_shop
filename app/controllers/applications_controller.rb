class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def new
  end

  def create
    @application = Application.new(application_params)

      if @application.save
        redirect_to "/applications/#{@application.id}"
      else
        redirect_to '/applications/new'
        flash[:alert] = "Error: #{error_message(@application.errors)}"
      end
  end

  def show
    @application = Application.find(params[:id])
    @application.app_status

    if @application.application_status == "In Progress"

      if params[:search].present?
        @pets = Pet.search(params[:search])
      end
    else
      flash[:alert] = "Please submit a new application."
    end
  end

  private

  def application_params
    params.permit(:id, :name, :street_address, :city, :state, :zip_code, :description)
  end
end
