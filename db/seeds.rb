# config
users_count = 0
resources_count = 0
networks_count = 0
list_count = 0

p 'Creating admin user with email \'admin@greencommons.org\' and password \'thecommons\'...'
admin = FactoryGirl.create(:user, email: 'admin@greencommons.org',
                                  password: 'thecommons')

p "Creating #{users_count} users..."
FactoryGirl.create_list(:user, users_count)

p "Creating #{resources_count} resources..."
(resources_count / 2).times do |n|
  # unowned resources
  FactoryGirl.create(:resource)

  # owned resources
  FactoryGirl.create(:resource, user: User.all.sample)
end

p "Creating #{list_count} lists with 10-50 resources for each user..."
User.all.each do |user|
  FactoryGirl.create_list(:list, list_count, owner: user,
                                    resources: Resource.order('RANDOM()').limit(rand(10..50)))
end

p "Creating #{networks_count} networks and 3-5 lists with 30-80 resources for each network..."
networks_count.times do |n|
  network = FactoryGirl.create(:network)
  users = User.order('RANDOM()').limit(rand(2..10)).to_a

  network.add_admin(admin)
  network.add_admin(users.shift)
  users.each { |user| network.add_user(user) }

  FactoryGirl.create_list(:list, rand(3..5), owner: network,
                                             resources: Resource.order('RANDOM()').limit(rand(30..80)))
end
