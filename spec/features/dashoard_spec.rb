require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'User can see plan details' do
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    plan = Plan.where(pid: user.plan).first
    login_as(user, :scope => :user)
    visit authenticated_root_path(user)
    expect(page).to have_content plan.name.titleize
    expect(page).to have_content plan.cost
  end
end

feature 'User can change plan from Dashboard' do
  scenario 'Successfully' do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit authenticated_root_path(user)
    click_link('btnChangePlan')
    current_path.should == edit_subscription_path(user)
  end
end

feature 'User can see recent Wiki info' do
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = FactoryGirl.create(:user)
    wiki.creator = user
    wiki.save
    plan = Plan.where(pid: user.plan).first
    login_as(user, :scope => :user)
    visit authenticated_root_path(user) 
    expect(page).to have_content wiki.title
    expect(page).to have_content 'View Wiki'
    expect(page).to have_content 'Edit Wiki'
  end
end

feature 'User can edit Wiki from recent Wiki section' do
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = FactoryGirl.create(:user)
    wiki.creator = user
    wiki.save
    plan = Plan.where(pid: user.plan).first
    login_as(user, :scope => :user)
    visit authenticated_root_path(user) 
    click_link('View Wiki')
    current_path.should == wiki_path(wiki)
  end
end

feature 'User can edit Wiki from recent Wiki section' do
  scenario 'Successfully' do
    wiki = FactoryGirl.create(:wiki)
    user = FactoryGirl.create(:user)
    wiki.creator = user
    wiki.save
    plan = Plan.where(pid: user.plan).first
    login_as(user, :scope => :user)
    visit authenticated_root_path(user) 
    click_link('Edit Wiki')
    current_path.should == edit_wiki_path(wiki)
  end
end
