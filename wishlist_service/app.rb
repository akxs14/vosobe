require "sinatra"
require_relative 'redis_adapter'

###############################################################################
#
# => Lists CRUD
#
###############################################################################

# get the user's lists
get "/username/:username/lists" do
  "Hello!"
end

# create a new list
post "/users/:username/lists" do
  "Hello!"
end

# delete a list
delete "/users/:username/lists/:listid" do
  "Hello!"
end

# return the data about a specific list
get "/users/:username/lists/:listid" do
  "Hello!"
end

###############################################################################
#
# => Get lists by access level
#
###############################################################################

# get user's public lists
get "/username/:username/lists/public" do
  "Hello!"
end

# get user's private lists
get "/users/:username/lists/private" do
  "Hello!"
end

###############################################################################
#
# => Product CRUD
#
###############################################################################

# add a new product in a list
post "/users/:username/lists/:listid/products" do
  "Hello!"
end

# return the products from a list
get "/users/:username/lists/:listid/products" do
  "Hello!"
end

# return the data about a specific product
get "/users/:username/lists/:listid/products/:productid" do
  "Hello!"
end

# delete a product
delete "/users/:username/lists/:listid/products/:productid" do
  "Hello!"
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
