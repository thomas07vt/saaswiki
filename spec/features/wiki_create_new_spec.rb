require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'User can click New Wiki link from dashboard home' do 
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user) 
    visit authenticated_root_path
    click_link('New Wiki')
    current_path.should == '/wikis/new'
  end
end

feature 'User can create New Wiki with Title, and Body' do 
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user) 
    visit new_wiki_path
    fill_in 'wiki_title', with: 'This is the title'
    fill_in 'wiki_body', with: 'This is the body of the wiki.'
    click_button 'Save Wiki'
    expect(page).to have_content 'The Wiki was successfully saved.'
  end
end 

feature 'User cannot create a new wiki without a Title' do 
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user) 
    visit new_wiki_path
    fill_in 'wiki_title', with: ''
    fill_in 'wiki_body', with: 'This is the body of the wiki.'
    click_button 'Save Wiki'
    expect(page).to have_content 'There was a problem saving the Wiki. Please try again.'
  end
end 