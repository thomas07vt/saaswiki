require 'spec_helper'
require 'pundit/rspec'
include Warden::Test::Helpers
Warden.test_mode!


feature 'User can click Edit Wiki link' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = wiki.creator
    login_as(user, :scope => :user)
    visit wiki_path(wiki.id)
    click_link('Edit Wiki')
    current_path.should == edit_wiki_path(wiki)
  end
end

feature 'User can update wiki Title' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = wiki.creator
    login_as(user, :scope => :user)
    visit edit_wiki_path(wiki)
    fill_in 'wiki_title', with: 'new wiki title' 
    click_button('btnSaveWiki')
    newWiki = Wiki.find(wiki.id)
    newWiki.title.should == 'new wiki title'
  end
end

feature 'User can update wiki body' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = wiki.creator
    login_as(user, :scope => :user)
    visit edit_wiki_path(wiki)
    fill_in 'wiki_body', with: 'new wiki body' 
    click_button('btnSaveWiki')
    newWiki = Wiki.find(wiki.id)
    newWiki.body.should == 'new wiki body'
  end
end

feature 'Wiki creator can see edit Wiki button from Wiki View' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = wiki.creator
    login_as(user, :scope => :user)
    visit wiki_path(wiki)
    expect(page).to have_content 'Edit Wiki'
  end
end


feature 'Wiki creator can see delete Wiki button from Wiki View' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = wiki.creator
    login_as(user, :scope => :user)
    visit wiki_path(wiki)
    expect(page).to have_content 'Delete Wiki'
  end
end

feature 'Wiki creator can select edit Wiki button from Wiki View' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = wiki.creator
    login_as(user, :scope => :user)
    visit wiki_path(wiki)
    click_link('Edit Wiki')
    current_path.should == edit_wiki_path(wiki)
  end
end

feature 'Wiki creator can delete Wiki button from Wiki View' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = wiki.creator
    login_as(user, :scope => :user)
    visit wiki_path(wiki)
    click_link('Delete Wiki')
    Wiki.where(id: wiki.id).any?.should == false
  end
end

feature 'Non Wiki creator should NOT be able to see Delete Wiki from Wiki view' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
    visit wiki_path(wiki)
    current_path.should == wiki_path(wiki)
    expect(page).to_not have_content 'Delete Wiki'
  end
end

feature 'Non Wiki collaborator should NOT be able to see Edit Wiki from Wiki view' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
    visit wiki_path(wiki)
    current_path.should == wiki_path(wiki)
    expect(page).to_not have_content 'Edit Wiki'
  end
end

feature 'Non Wiki editor should NOT be able to edit Wiki' do 
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
    visit edit_wiki_path(wiki)
    current_path.should == '/'
  end
end

