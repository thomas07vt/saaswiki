class WikisController < ApplicationController
  def index
  end

  def show
  end

  def new
    @user = current_user
    @wiki = Wiki.new
  end

  def edit
  end
end
