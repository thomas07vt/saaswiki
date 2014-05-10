class WikisController < ApplicationController
  def index
    @wikis = Wiki.where(creator_id: current_user.id)
  end

  def show
    @wiki = Wiki.find(params[:id])
    @creator = @wiki.creator
  end

  def new
    @user = current_user
    @wiki = Wiki.new
  end

  def create
    @user = current_user
    @wiki = @user.wikis.build(wiki_params)
    @wiki.creator_id = @user.id
    #authorize(@wiki)

    if @wiki.save
      flash[:notice] = 'The Wiki was successfully saved.'
      redirect_to wiki_path(@wiki)
    else
      flash[:error] = 'There was a problem saving the Wiki. Please try again.'
      render :new
    end

  end

  def edit
    @user = current_user
    @wiki = Wiki.find(params[:id])
  end

  def update
    @user = current_user
    @wiki = Wiki.find(params[:id])
    @wiki.creator_id = @user.id
    #authorize(@wiki)

    if @wiki.update_attributes(wiki_params)
      flash[:notice] = 'The Wiki was updated successfully.'
      redirect_to wiki_path(@wiki)
    else
      flash[:error] = 'There was a problem updating the Wiki. Please try again.'
      render :edit
    end
  end

  private 

  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end
end
