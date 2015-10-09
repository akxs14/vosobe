require 'redis'
require 'json'

class User
  # new_list = { :title, :public, :created_at, :updated_at }
  def self.add_list redis, username, new_list
    new_list = new_list.to_json if new_list.class == Hash
    new_id = redis.incr("users:#{username}:lists:cnt")
    redis.hmset("users:#{username}:lists", new_id, new_list)
    new_id
  end


  def self.get_lists redis, username
    lists = redis.hgetall("users:#{username}:lists")
    list_array = []

    lists.each do |k,v|
      tmp_list = JSON.parse(v)
      tmp_list["id"] = k
      list_array << tmp_list
    end
    list_array
  end

  # get lists which are not visible from other users
  def self.get_private_lists redis, username
    lists = redis.hgetall("users:#{username}:lists")
    lists.each {|k,v| lists[k] = JSON.parse(v)}.select {|_,v| v["public"] == false}
  end

  # get lists which are visible from other users
  def self.get_public_lists redis, username
    lists = redis.hgetall("users:#{username}:lists")
    lists.each {|k,v| lists[k] = JSON.parse(v)}.select {|_,v| v["public"] == true}
  end


  def self.get_list redis, username, list_id
    JSON.parse(redis.hget("users:#{username}:lists", list_id))
  end


  def self.update_list redis, username, list_id, updated_list
    old_list = get_list(redis, username, list_id)

    if old_list["created_at"]
      updated_list["created_at"] = old_list["created_at"]
    else
      updated_list["created_at"] = Time.now.to_f
    end
    updated_list = updated_list.to_json if updated_list.class == Hash

    redis.hset("users:#{username}:lists", list_id, updated_list)
    get_list(redis, username, list_id)
  end


  def self.delete_list redis, username, list_id
    redis.hdel("users:#{username}:lists", list_id)
    "list \##{list_id} deleted"
  end

  ###############################################################################
  #
  # => Lists followed and unfollowed
  #
  ###############################################################################

  # follow a list
  def self.follow_list redis, username, following_username, list_id
    redis.zadd("users:#{username}:lists:following", Time.now.to_f, "#{following_username}:#{list_id}")
    redis.zrem("users:#{username}:lists:unfollowed", "#{following_username}:#{list_id}")

    redis.zadd("users:#{following_username}:lists:#{list_id}:followers", Time.now.to_f, "#{username}:#{list_id}")
    redis.zrem("users:#{following_username}:lists:#{list_id}:unfollowers", "#{following_username}:#{list_id}")
  end

  # unfollow a list
  def self.unfollow_list redis, username, following_username, list_id
    redis.zrem("users:#{username}:lists:following", "#{following_username}:#{list_id}")
    redis.zadd("users:#{username}:lists:unfollowed", Time.now.to_f, "#{following_username}:#{list_id}")

    redis.zadd("users:#{following_username}:lists:#{list_id}:unfollowers", Time.now.to_f, "#{following_username}:#{list_id}")
    redis.zrem("users:#{following_username}:lists:#{list_id}:followers", "#{username}:#{list_id}")
  end

  # get the lists the user is following
  def self.get_lists_following redis, username
    redis.zrevrange("users:#{username}:lists:following", 0, -1) || []
  end

  # get the lists the user stopped following
  def self.get_lists_unfollowed redis, username
    redis.zrevrange("users:#{username}:lists:unfollowed", 0, -1) || []
  end

  # get the users who follow a list
  def self.get_list_followers redis, username, list_id
    redis.zrevrange("users:#{username}:lists:#{list_id}:followers", 0, -1) || []
  end

  # get the users who unfollow a list
  def self.get_list_unfollowers redis, username, list_id
    redis.zrevrange("users:#{username}:lists:#{list_id}:unfollowers", 0, -1) || []
  end


  ###############################################################################
  #
  # => Users followed and unfollowed
  #
  ###############################################################################

  # follow a user
  def self.follow_user redis, username, following_username
    redis.zadd("users:#{username}:users:following", Time.now.to_f, following_username)
    redis.zrem("users:#{username}:users:unfollowed", following_username)

    redis.zadd("users:#{following_username}:followers", Time.now.to_f, username)
    redis.zrem("users:#{following_username}:unfollowers", username)
  end

  # stop following a user
  def self.unfollow_user redis, username, following_username
    redis.zrem("users:#{username}:users:following", following_username)
    redis.zadd("users:#{username}:users:unfollowed", Time.now.to_f, following_username)

    redis.zadd("users:#{following_username}:unfollowers", Time.now.to_f, username)
    redis.zrem("users:#{following_username}:followers", username)
  end

  # get the users the user is following
  def self.get_users_following redis, username
    redis.zrevrange("users:#{username}:users:following", 0, -1)
  end

  # get the users the user stopped following
  def self.get_users_unfollowed redis, username
    redis.zrevrange("users:#{username}:users:unfollowed", 0, -1)
  end

  # get the users who follow the user
  def self.get_user_followers redis, username
    redis.zrevrange("users:#{username}:followers", 0, -1) || []
  end

  # get the users who unfollow the user
  def self.get_user_unfollowers redis, username
    redis.zrevrange("users:#{username}:unfollowers", 0, -1) || []
  end
end

class List
  # new_list = { :description, :name, :url, :img_url, :price, :created_at, :updated_at }
  def self.add_product redis, username, list_id, new_product
    new_product = new_product.to_json if new_product.class == Hash
    new_id = redis.incr("users:#{username}:lists:#{list_id}:products:cnt")
    redis.hmset("users:#{username}:lists:#{list_id}:products", new_id, new_product)
    new_id
  end

  def self.get_products redis, username, list_id
    lists = redis.hgetall("users:#{username}:lists:#{list_id}:products")
    lists.each {|k,v| lists[k] = JSON.parse(v)}
  end


  def self.get_product redis, username, list_id, product_id
    JSON.parse(redis.hget("users:#{username}:lists:#{list_id}:products", product_id))
  end


  def self.update_product redis, username, list_id, product_id, updated_product
    updated_product = updated_product.to_json if updated_product.class == Hash
    redis.hset("users:#{username}:lists:#{list_id}:products", product_id, updated_product)
  end


  def self.delete_product redis, username, list_id, product_id
    redis.hdel("users:#{username}:lists:#{list_id}:products", product_id)
    "product \##{list_id} deleted"
  end
end
