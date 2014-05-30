namespace :username_suggestions do
  desc "Generate username suggestions from Users"
  task :index => :environment do
    UsernameSuggestion.index_products
  end
end