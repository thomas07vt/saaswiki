require 'spec_helper'
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