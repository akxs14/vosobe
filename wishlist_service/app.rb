require "sinatra"
require 'sinatra/cross_origin'
require_relative 'redis_adapter'

configure do
  enable :cross_origin
end

redis = Redis.new(:host => "127.0.0.1", :port => 6379)

###############################################################################
#
# => Handle preflight OPTIONS request (for CORS)
#
###############################################################################
options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
  200
end

###############################################################################
#
# => Users followed and unfollowed
#
###############################################################################

# get the users followed
get "/users/:username/users/following" do
  {"users_following" => User.get_users_following(redis, params[:username])}.to_json
end

# get the users the user has unfollowed
get "/users/:username/users/unfollowed" do
  {"users_unfollowed" => User.get_users_unfollowed(redis, params[:username])}.to_json
end

# add a user in the list of following
post "/users/:username/users/following/:following_username" do
  {"result" => User.follow_user(redis,
    params[:username],
    params[:following_username])}.to_json
end

# stop following a user
delete "/users/:username/users/following/:following_username" do
  {"result" => User.unfollow_user(redis,
    params[:username],
    params[:following_username])}.to_json
end

# get followers (users)
get "/users/:username/users/followers" do
  {"followers" => User.get_user_followers(redis,
    params[:username])}.to_json
end

# get followers (users)
get "/users/:username/users/unfollowers" do
  {"unfollowers" => User.get_user_unfollowers(redis,
    params[:username])}.to_json
end


###############################################################################
#
# => Lists followed and unfollowed
#
###############################################################################

# get the lists the user is following
get "/users/:username/lists/following" do
  {"lists_following" => User.get_lists_following(redis, params[:username])}.to_json
end

# get the lists the user has unfollowed
get "/users/:username/lists/unfollowed" do
  {"lists_unfollowed" => User.get_lists_unfollowed(redis, params[:username])}.to_json
end

# add a list in the list of following
post "/users/:username/lists/following/:following_username/:listid" do
  {"result" => User.follow_list(redis,
    params[:username],
    params[:following_username],
    params[:listid])}.to_json
end

# stop following a list
delete "/users/:username/lists/following/:following_username/:listid" do
  {"result" => User.unfollow_list(redis,
    params[:username],
    params[:following_username],
    params[:listid])}.to_json
end

# get list followers
get "/users/:username/lists/:listid/followers" do
  {"followers" => User.get_list_followers(redis,
    params[:username],
    params[:listid])}.to_json
end

# get list followers
get "/users/:username/lists/:listid/unfollowers" do
  {"unfollowers" => User.get_list_unfollowers(redis,
    params[:username],
    params[:listid])}.to_json
end


###############################################################################
#
# => Product CRUD
#
###############################################################################

# add a new product in a list
post "/users/:username/lists/:listid/products" do
  response.headers["Access-Control-Allow-Origin"] = "*"
  puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  puts request.body.read
  puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  # payload = JSON.parse(request.body.read)
  # payload["created_at"] = Time.now.to_f
  # payload["updated_at"] = Time.now.to_f
  # id = List.add_product(redis, params[:username], params[:listid], payload)

  {"id" => "1", "results" => "product created"}.to_json
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

# return a list
get "/users/:username/lists/:listid" do
  list = User.get_list(redis, params[:username], params[:listid])
  list.to_json
end

# get the user's lists
get "/users/:username/lists" do
  User.get_lists(redis, params[:username]).to_json
end

# delete a list
delete "/users/:username/lists/:listid" do
  {"result" => User.delete_list(redis,
    params[:username],
    params[:listid])}.to_json
end

# update a list
put "/users/:username/lists/:listid" do
  payload = JSON.parse(request.body.read)
  payload["updated_at"] = Time.now.to_f
  User.update_list(redis, params[:username], params[:listid], payload).to_json
end
