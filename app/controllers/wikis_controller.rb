class WikisController < ApplicationController
  def index
  end

  def show
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
      redirect_to new_wiki_path
    end

  end

  def edit
  end

  private 

  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end
end
