require 'redis'
require 'json'

class User
  # new_list = { :title, :public, :created_at, :updated_at }
  def self.add_list redis, username, new_list
    new_list = new_list.to_json if new_list.class == Hash
    new_id = redis.incr("users:#{username}:lists:cnt")
    redis.hmset("users:#{username}:lists", new_id, new_list)
  end


  def self.get_lists redis, username
    redis.hgetall("users:#{username}:lists")
  end


  def self.get_private_lists redis, username
    lists = redis.hgetall("users:#{username}:lists").each {|k,v| JSON.parse(v)}
    lists.select {|k,v| JSON.parse(v)["public"] == false}
  end


  def self.get_public_lists redis, username
    lists = redis.hgetall("users:#{username}:lists")
    lists.select {|k,v| JSON.parse(v)["public"] == true}
  end


  def self.get_list redis, username, list_id
    redis.hget("users:#{username}:lists", list_id)
  end


  def self.update_list redis, username, list_id, updated_list
    updated_list = updated_list.to_json if updated_list.class == Hash
    redis.hset("users:#{username}:lists", list_id, updated_list)
  end


  def self.delete_list redis, username, list_id
    redis.hdel("users:#{username}:lists", list_id)
  end

  ###############################################################################
  #
  # => Lists followed and unfollowed
  #
  ###############################################################################

  def self.follow_list redis, username, following_username, list_id
    redis.zadd("users:#{username}:lists:following", Time.now.to_f, "#{following_username}:#{list_id}")
  end


  def self.unfollow_list redis, username, following_username, list_id
    redis.zrem("users:#{username}:lists:following", "#{following_username}:#{list_id}")
    redis.zadd("users:#{username}:lists:unfollowed", Time.now.to_f, "#{following_username}:#{list_id}")
  end


  def self.get_lists_following redis, username
    redis.zrevrange("users:#{username}:lists:following", 0, -1)
  end


  def self.get_lists_unfollowed redis, username
    redis.zrevrange("users:#{username}:lists:unfollowed", 0, -1)
  end

  ###############################################################################
  #
  # => Users followed and unfollowed
  #
  ###############################################################################

  def self.follow_user redis, username, following_username
    redis.zadd("users:#{username}:users:following", Time.now.to_f, following_username)
  end


  def self.unfollow_user redis, username, following_username
    redis.zrem("users:#{username}:users:following", following_username)
    redis.zadd("users:#{username}:users:unfollowed", Time.now.to_f, following_username)
  end


  def self.get_users_following redis, username
    redis.zrevrange("users:#{username}:users:following", 0, -1)
  end


  def self.get_users_unfollowed redis, username
    redis.zrevrange("users:#{username}:users:unfollowed", 0, -1)
  end
end

class List
  # new_list = { :description, :name, :url, :img_url, :price, :created_at, :updated_at }
  def self.add_product redis, username, list_id, new_product
    new_product = new_product.to_json if new_product.class == Hash
    new_id = redis.incr("users:#{username}:lists:#{list_id}:products:cnt")
    redis.hmset("users:#{username}:lists:#{list_id}:products", new_id, new_product)
  end

  def self.get_products redis, username, list_id
    redis.hgetall("users:#{username}:lists:#{list_id}:products")
  end


  def self.get_product redis, username, list_id, product_id
    redis.hget("users:#{username}:lists:#{list_id}:products", product_id)
  end


  def self.update_product redis, username, list_id, product_id, updated_product
    updated_product = updated_product.to_json if updated_product.class == Hash
    redis.hset("users:#{username}:lists:#{list_id}:products", product_id, updated_product)
  end


  def self.delete_product redis, username, list_id, product_id
    redis.hdel("users:#{username}:lists:#{list_id}:products", product_id)
  end
end