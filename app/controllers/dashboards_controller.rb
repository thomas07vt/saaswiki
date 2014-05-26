class DashboardsController < ApplicationController
  def show
    @dashboard = Dashboard.new(current_user) 
    @user = @dashboard.user
    @plan  = Plan.where(pid: @user.plan).first
  end
end
