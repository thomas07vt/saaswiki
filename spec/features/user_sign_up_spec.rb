require 'spec_helper'

feature 'User can click Sign Up link in header' do 
  scenario 'Successfully' do 
    visit root_path
    click_link('hSignUp')
    current_path.should == '/users/sign_up'
  end
end

feature 'User can click free option under Pricing to sign up' do 
  scenario 'Successfully' do 
    visit root_path
    click_link('pricingFreeSignUp')
    current_path.should == '/users/sign_up'
  end
end

feature 'User can Sign Up with Username, Email, and PW' do
  scenario 'Successfully' do
    visit new_user_registration_path
    fill_in 'Username', with: 'userName'
    fill_in 'Email', with: 'email@email.com'
    fill_in 'Password', with: 'password1'
    fill_in 'Password confirmation', with: 'password1'
    click_button 'Sign up'
    current_path.should ==  authenticated_root_path
    expect(page).to have_content ' A message with a confirmation link has been sent to your email address.'
  end
end






