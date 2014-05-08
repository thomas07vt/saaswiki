require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'User can click Sign Out link in header' do 
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user) 
    visit root_path
    click_link('hSignOut')
    expect(page).to have_content "Signed out successfully."
  end
end