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
        flash[:alert] = "Error: #{error_message(@application.errors)}"
        render :new
      end
  end

  def show
    @application = Application.find(params[:id])
    @application.app_status

    if params[:search].present?
      @pets = Pet.search(params[:search])
    end
  end

  def update
    @application = Application.find(params[:id])
    @application.update(application_params)
    @application.save

   redirect_to "/applications/#{@application.id}"
  end

  private

  def application_params
    params.permit(:id, :name, :street_address, :city, :state, :zip_code, :description)
  end
end
