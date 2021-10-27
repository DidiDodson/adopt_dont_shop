class AdminController < ApplicationController
  def index
    @admins = Admin.all

    @us_10 = @admins.s_query
  end

  def new
  end

  def create
    @admin = Admin.create!
    redirect_to '/admin/shelters'
  end
end
