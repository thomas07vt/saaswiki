

class AssignedWikisController < ApplicationController
  respond_to :html, :js

  def index
    @user = current_user
    @wiki = Wiki.find(params[:wiki_id])
    @assigned_wikis = AssignedWiki.where(wiki_id: @wiki.id)
    @collaborator = Collaborator.new

    redirect_to wiki_path(@wiki) unless policy(@wiki).access?
  end

  def new
    @wiki = Wiki.find(params[:wiki_id])
    respond_with() do |f|
      f.html { redirect_to wiki_assigned_wikis_path(@wiki.id) }
    end
  end

  def create

    @collaborator = Collaborator.new(collaborator_params)
    collaborator_info = @collaborator.create(params)
    @assignedwiki = collaborator_info[:assigned_wiki]
    authorize(@assignedwiki)
    
    if !@assignedwiki.save
      flash[:error] = "There was an error while adding the collaborator. #{collaborator_info[:error]}" 
    end

    respond_with(@assignedwiki) do |f|
      f.html { redirect_to wiki_assigned_wikis_path(@assignedwiki.wiki_id) }
    end

  end

  def update
    @assignedWiki = AssignedWiki.find(params[:id])
    authorize(@assignedWiki)

    if @assignedWiki.update_attributes(assigned_wiki_params)
      redirect_to wiki_assigned_wikis_path(@assignedWiki.wiki_id)
    else
      flash[:error] = 'There was a problem updating the Wiki. Please try again.'
      redirect_to wiki_assigned_wikis_path(@assignedWiki.wiki_id)
    end

  end

  def destroy
    @assigned_wiki = AssignedWiki.find(params[:id])
    authorize(@assigned_wiki)

    if @assigned_wiki.destroy
      flash[:notice] = "\"#{@assigned_wiki.user.username}\" was successfully removed."
      redirect_to wiki_assigned_wikis_path(@assigned_wiki.wiki) 
    else
      flash[:error] = "There was an error removing \"#{@assigned_wiki.user.username}\". Please try again."
      redirect_to wiki_assigned_wikis_path(@assigned_wiki.wiki)
    end
  end

  def username_suggestions
    render json: UsernameSuggestion.terms_for(params[:term])
  end

  private 
  def assigned_wiki_params
    params.require(:assigned_wiki).permit(:editor, :wiki_id, :user_id)
  end

  def collaborator_params
    params.require(:collaborator).permit(:username, :editor)
  end
end
