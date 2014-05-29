
# Create the Plan objects that are necessary for this app to run
plan1 = Plan.new(
  name: "basic",
  price: "0.00",
  pid: 0
)
plan1.save

plan2 = Plan.new(
  name: "premium",
  price: "10.00",
  pid: 1
)
plan2.save

plan3 = Plan.new(
  name: "enterprise",
  price: "50.00",
  pid: 2
)
plan3.save


# Create admin user
admin = User.new(
  username: 'admin',
  email: 'admin@example.com', 
  password: ENV['BLOCCIT_DEFAULT_PASS'], 
  password_confirmation: ENV['BLOCCIT_DEFAULT_PASS'],
  role: "premium",
  plan: 0
)
admin.skip_confirmation!
admin.save



# Create the Markdown Wiki Cheatsheet template to secure wiki_id of 1
wiki = Wiki.new(
  title: "Wiki Cheatsheet",
  body: "Update this.",
  creator_id: 1,
  public: true
)
wiki.save

puts "Seed finished"
puts "#{Plan.count} plans created"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"

