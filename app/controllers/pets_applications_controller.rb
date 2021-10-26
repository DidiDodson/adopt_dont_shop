class PetsApplicationsController < ApplicationController

  def show
    application = Application.find(params[:application_id])

    @pet_app = PetsApplication.create!(pets_application_params)

    redirect_to "/applications/#{application.id}"
  end

  private

  def pets_application_params
    params.permit(:pet_id, :application_id)
  end
end
