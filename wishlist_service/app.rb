require "sinatra"

# get the user's lists
get "/username/:username/lists" do
  "Hello!"
end

# get the lists from other users which
# the user is following
get "/username/:username/lists/following" do
  "Hello!"
end

# get user's public lists
get "/username/:username/lists/public" do
  "Hello!"
end

# get user's private lists
get "/username/:username/lists/private" do
  "Hello!"
end

# create a new list
post "/username/:username/lists" do
  "Hello!"
end

# return the data about a specific list
get "/username/:username/lists/:listid" do
  "Hello!"
end

# delete a list
delete "/username/:username/lists/:listid" do
  "Hello!"
end

# get the list followers
get "/username/:username/lists/:listid/followers" do
  "Hello!"
end


# add a new product in a list
post "/username/:username/lists/:listid/products" do
  "Hello!"
end


# return the products from a list
get "/username/:username/lists/:listid/products" do
  "Hello!"
end

# return the data about a specific product
get "/username/:username/lists/:listid/products/:productid" do
  "Hello!"
end

# delete a product
get "/username/:username/lists/:listid/products/:productid" do
  "Hello!"
end

