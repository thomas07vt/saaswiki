require 'spec_helper'

feature 'User can click Sign Up link in header' do 
  scenario 'Successfully' do 
    visit root_path
    click_link('hSignUp')
    current_path.should == '/users/sign_up'
  end
end

# feature 'User can click free option under Pricing to sign up' do 
#   scenario 'Successfully' do 
#     visit root_path
#     click_link('pricingFreeSignUp')
#     current_path.should == '/users/sign_up'
#   end
# end

feature 'User can Sign Up with Username, Email, and PW' do
  scenario 'Successfully' do
    visit new_user_registration_path
    within('#new_user') do 
      fill_in 'user_username', with: 'userName'
      fill_in 'user_email', with: 'email@email.com'
      fill_in 'user_password', with: 'password1'
      fill_in 'user_password_confirmation', with: 'password1'
    end 
    click_button 'Sign up'
    current_path.should ==  authenticated_root_path
    expect(page).to have_content ' A message with a confirmation link has been sent to your email address.'
  end
end

feature 'User cannot Sign Up without Username' do
  scenario 'Successfully' do
    visit new_user_registration_path
    fill_in 'Username', with: ''
    fill_in 'Email', with: 'email@email.com'
    fill_in 'Password', with: 'password1'
    fill_in 'Password confirmation', with: 'password1'
    click_button 'Sign up'
    current_path.should ==  '/users'
    expect(page).to have_content 'Username can\'t be blank'
  end
end

feature 'User cannot Sign Up with a Username that is less than 3 characters' do
  scenario 'Successfully' do
    visit new_user_registration_path
    fill_in 'Username', with: 'ab'
    fill_in 'Email', with: 'email@email.com'
    fill_in 'Password', with: 'password1'
    fill_in 'Password confirmation', with: 'password1'
    click_button 'Sign up'
    current_path.should ==  '/users'
    expect(page).to have_content 'Username is too short (minimum is 3 characters)'
  end
end

feature 'User cannot Sign Up without Email' do
  scenario 'Successfully' do
    visit new_user_registration_path
    fill_in 'Username', with: 'userName'
    fill_in 'Email', with: ''
    fill_in 'Password', with: 'password1'
    fill_in 'Password confirmation', with: 'password1'
    click_button 'Sign up'
    current_path.should ==  '/users'
    expect(page).to have_content 'Email can\'t be blank'
  end
end


feature 'User cannot Sign Up without password' do
  scenario 'Successfully' do
    visit new_user_registration_path
    fill_in 'Username', with: ''
    fill_in 'Email', with: 'email@email.com'
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: 'password1'
    click_button 'Sign up'
    current_path.should ==  '/users'
    expect(page).to have_content 'Password can\'t be blank'
  end
end

feature 'User cannot Sign Up without password confirmation' do
  scenario 'Successfully' do
    visit new_user_registration_path
    fill_in 'Username', with: ''
    fill_in 'Email', with: 'email@email.com'
    fill_in 'Password', with: 'password1'
    fill_in 'Password confirmation', with: ''
    click_button 'Sign up'
    current_path.should ==  '/users'
    expect(page).to have_content 'Password confirmation doesn\'t match Password'
  end
end





