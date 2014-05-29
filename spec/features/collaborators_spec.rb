require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!


feature 'Wiki Creator should be able to see Add Collaborators button from Wiki View' do 
  scenario  'Successfully' do  
    wiki = FactoryGirl.create(:wiki)
    user = wiki.creator
    login_as(user, :scope => :user)
    visit wiki_path(wiki)
    expect(page).to have_content 'Add Collaborators'
  end
end

feature 'Wiki Creator should be able to click Add Collaborators button from Wiki View' do 
  scenario  'Successfully' do  
    wiki = FactoryGirl.create(:wiki)
    user = wiki.creator
    login_as(user, :scope => :user)
    visit wiki_path(wiki)
    click_link 'Add Collaborators'
    current_path.should == wiki_assigned_wikis_path(wiki)
  end
end

feature 'Wiki editor should be able to edit Wiki' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = FactoryGirl.create(:user)
    assigned_wiki = AssignedWiki.new(
      wiki_id: wiki.id,
      user_id: user.id,
      editor: true
    )
    assigned_wiki.save
    login_as(user, scope: :user)
    visit edit_wiki_path(wiki)
    current_path.should == edit_wiki_path(wiki)
  end
end

feature 'Wiki collaborator without edit permissions should not be able to edit Wiki' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = FactoryGirl.create(:user)
    assigned_wiki = AssignedWiki.new(
      wiki_id: wiki.id,
      user_id: user.id,
      editor: false
    )
    assigned_wiki.save
    login_as(user, scope: :user)
    visit edit_wiki_path(wiki)
    current_path.should == '/'
  end
end

feature 'Wiki collaborator should be able to see private wiki' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = FactoryGirl.create(:user)
    assigned_wiki = AssignedWiki.new(
      wiki_id: wiki.id,
      user_id: user.id,
      editor: false
    )
    assigned_wiki.save
    wiki.public = false
    wiki.save
    login_as(user, scope: :user)
    visit wiki_path(wiki)
    current_path.should == wiki_path(wiki)
  end
end

feature 'Wiki editor should be able to edit private wiki' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = FactoryGirl.create(:user)
    assigned_wiki = AssignedWiki.new(
      wiki_id: wiki.id,
      user_id: user.id,
      editor: true
    )
    assigned_wiki.save
    wiki.public = false
    wiki.save
    login_as(user, scope: :user)
    visit edit_wiki_path(wiki)
    current_path.should == edit_wiki_path(wiki)
  end
end
