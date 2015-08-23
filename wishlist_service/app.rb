require "sinatra"
require_relative 'redis_adapter'


redis = Redis.new(:host => "127.0.0.1", :port => 6379)


###############################################################################
#
# => Product CRUD
#
###############################################################################

# add a new product in a list
post "/users/:username/lists/:listid/products" do
  payload = JSON.parse(request.body.read)
  payload["created_at"] = Time.now.to_f
  payload["updated_at"] = Time.now.to_f
  id = List.add_product(redis, params[:username], params[:listid], payload)

  {"id" => id, "results" => "product created"}.to_json
end

# return the products from a list
get "/users/:username/lists/:listid/products" do
  List.get_products(redis, params[:username], params[:listid]).to_json
end

# return the data about a specific product
get "/users/:username/lists/:listid/products/:productid" do
  List.get_product(redis,
    params[:username],
    params[:listid],
    params[:productid]).to_json
end

# delete a product
delete "/users/:username/lists/:listid/products/:productid" do
  {"result" => List.delete_product(redis,
    params[:username],
    params[:listid],
    params[:productid])}.to_json
end


###############################################################################
#
# => Get lists by access level
#
###############################################################################

# get user's public lists
get "/users/:username/lists/public" do
  lists = User.get_public_lists(redis, params[:username])
  puts "public: #{lists}"
  lists.to_json
end

# get user's private lists
get "/users/:username/lists/private" do
  lists = User.get_private_lists(redis, params[:username])
  puts "private: #{lists}"
  lists.to_json
end


###############################################################################
#
# => Lists CRUD
#
###############################################################################

# create a new list
post "/users/:username/lists" do
  payload = JSON.parse(request.body.read)
  payload["created_at"] = Time.now.to_f
  payload["updated_at"] = Time.now.to_f
  id = User.add_list(redis, params[:username], payload)

  {"id" => id, "results" => "list created"}.to_json
end

# get the user's lists
get "/users/:username/lists" do
  lists = User.get_lists(redis, params[:username])
  lists.to_json
end

# delete a list
delete "/users/:username/lists/:listid" do
  {"result" => User.delete_list(redis,
    params[:username],
    params[:listid])}.to_json
end

# return a list
get "/users/:username/lists/:listid" do
  list = User.get_list(redis, params[:username], params[:listid])
  list.to_json
end

# update a list
put "/users/:username/lists/:listid" do
  payload = JSON.parse(request.body.read)
  payload["updated_at"] = Time.now.to_f
  User.update_list(redis, params[:username], params[:listid], payload).to_json
end

###############################################################################
#
# => Lists followed and unfollowed
#
###############################################################################

# get the lists the user is following
get "/username/:username/lists/following" do
  "Hello!"
end

# add a list in the list of following
post "/username/:username/lists/following/:listid" do
  "Hello!"
end

# stop following a list
delete "/username/:username/lists/following/:listid" do
  "Hello!"
end

###############################################################################
#
# => Users followed and unfollowed
#
###############################################################################

# get the users followed
get "/username/:username/users/following" do
  "Hello!"
end

# add an user in the list of following
post "/username/:username/users/following/:username" do
  "Hello!"
end

# stop following a user
delete "/username/:username/users/following/:username" do
  "Hello!"
end

###############################################################################
#
# => List of list followers and unfollowers
#
###############################################################################

# get the list followers
get "/users/:username/lists/:listid/followers" do
  "Hello!"
end

# adds a follower
post "/users/:username/lists/:listid/followers/:username" do
  "Hello!"
end

# deletes a list follower
delete "/users/:username/lists/:listid/followers/:username" do
  "Hello!"
end

# get the list of unfollowers
get "/users/:username/lists/:listid/unfollowers" do
  "Hello!"
end

# adds an unfollower
post "/users/:username/lists/:listid/unfollowers/:username" do
  "Hello!"
end


###############################################################################
#
# => List of user followers and unfollowers
#
###############################################################################

# get the list of the user's followers
get "/users/:username/users/followers" do
  "Hello!"
end

# add user follower
post "/users/:username/users/followers" do
  "Hello!"
end

# delete user follower
delete "/users/:username/users/followers/:username" do
  "Hello!"
end

# get the list of the user's unfollowers
get "/users/:username/users/unfollowers" do
  "Hello!"
end

# add user unfollower
post "/users/:username/users/unfollowers" do
  "Hello!"
end
