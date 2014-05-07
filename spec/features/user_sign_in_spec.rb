require 'spec_helper'

feature 'User can click Sign In link in header' do 
  scenario 'Successfully' do 
    visit root_path
    click_link('hSignIn')
    current_path.should == '/users/sign_in'
  end
end

feature 'User can Sign in with Username and PW' do
  scenario 'Successfully' do
    visit new_user_session_path
    user = FactoryGirl.create(:user)
    fill_in 'user_login', with: user.username
    fill_in 'user_password', with: user.password
    click_button 'Sign in'
    current_path.should ==  authenticated_root_path
  end
end

feature 'User can Sign in with Email and PW' do
  scenario 'Successfully' do
    visit new_user_session_path
    user = FactoryGirl.create(:user)
    fill_in 'user_login', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Sign in'
    current_path.should ==  authenticated_root_path
  end
end

feature 'User cannot Sign in without login' do
  scenario 'Successfully' do
    visit new_user_session_path
    user = FactoryGirl.create(:user)
    fill_in 'user_login', with: ''
    fill_in 'user_password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content 'Invalid login or password'
  end
end

feature 'User cannot Sign in with fake login' do
  scenario 'Successfully' do
    visit new_user_session_path
    user = FactoryGirl.create(:user)
    fill_in 'user_login', with: 'fake'
    fill_in 'user_password', with: user.password
    click_button 'Sign in'
    expect(page).to have_content 'Invalid login or password'
  end
end


feature 'User cannot Sign in without password' do
  scenario 'Successfully' do
    visit new_user_session_path
    user = FactoryGirl.create(:user)
    fill_in 'user_login', with: user.username
    fill_in 'user_password', with: ''
    click_button 'Sign in'
    expect(page).to have_content 'Invalid login or password'
  end
end


