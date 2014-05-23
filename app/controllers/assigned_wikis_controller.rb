class AssignedWikisController < ApplicationController
  respond_to :html, :js

  def new
    @wiki = Wiki.find(params[:wiki_id])
    @assignedwiki = AssignedWiki.new
    @assignedwiki.wiki_id = @wiki.id

    respond_with(@assignedwiki) do |f|
      f.html { redirect_to wiki_access_path(@wiki.id) }
    end
  end

  def create
    #TODO form object
    @username = params[:username]
    @wiki = Wiki.find(params[:wiki_id])
    @users = User.where(username: params[:username])
    if @users.any?
      @collaborator = @users[0]
    else
      # Throw some error
      flash[:error] = "The username: '#{@username}' does not exist."
      return redirect_to wiki_access_path(@wiki)
    end

    @assignedwiki = AssignedWiki.new
    @assignedwiki.user_id = @collaborator.id
    @assignedwiki.wiki_id = @wiki.id
    @assignedwiki.editor = params[:editor]

    #authorize(@todo)
    if @assignedwiki.save
    else
      flash[:error] = "There was an error while adding '#{@username}' as a collaborator."
    end

    respond_with(@assignedwiki) do |f|
      f.html { redirect_to wiki_access_path(@wiki) }
    end

  end

  def update
    @assignedWiki = AssignedWiki.find(params[:id])
    authorize(@assignedWiki)

    if @assignedWiki.update_attributes(assigned_wiki_params)
      redirect_to wiki_access_path(@assignedWiki.wiki_id)
    else
      flash[:error] = 'There was a problem updating the Wiki. Please try again.'
      redirect_to wiki_access_path(@assignedWiki.wiki_id)
    end

  end

  def destroy
    @assigned_wiki = AssignedWiki.find(params[:id])
    authorize(@assigned_wiki)

    if @assigned_wiki.destroy
      flash[:notice] = "\"#{@assigned_wiki.user.username}\" was successfully removed."
      redirect_to wiki_access_path(@assigned_wiki.wiki) 
    else
      flash[:error] = "There was an error removing \"#{@assigned_wiki.user.username}\". Please try again."
      redirect_to wiki_access_path(@assigned_wiki.wiki)
    end
  end

  private 
  def assigned_wiki_params
    params.require(:assigned_wiki).permit(:editor, :wiki_id, :user_id)
  end
end
