(ns web-app.routes.home
  (:require [web-app.layout :as layout]
            [compojure.core :refer [defroutes GET]]
            [ring.util.http-response :refer [ok]]
            [clojure.java.io :as io]))

(defn home-page []
  (layout/render "home.html"))

(defn get-following-users [username]
  (str "followers of " username))

(defn get-unfollowed-users [username]
  (str username " unfollowed"))

(defn follow-user [username, following_username]
  (str username " now follows " following_username))

(defn unfollow-user [username, following_username]
  (str username " stopped following " following_username))

(defn get-followers [username]
  (str username " followers"))

(defn get-unfollowers [username]
  (str username " unfollowers"))

(def get-lists-following [username]
  (str "lists " username " is following"))

(def get-lists-unfollowed [username]
  (str "lists " username " has unfollowed"))

(defn follow-list [username, following_username, listid]
  (str username " follows " following_username " list " listid))

(defn unfollow-list [username, following_username, listid]
  (str username " stopped following " following_username " list " listid))

(defn get-list-followers [username, listid]
  (str "followers of user's " username " list " listid))

(defn get-list-unfollowers [username, listid]
  (str "unfollowers of user's " username " list " listid))

(defn add-product [username, listid, new-product]
  (str "added new product in " username "'s " listid))

(defn get-list-products [username, listid]
  (str "user " username " list " listid " products"))

(defn get-product [username, listid, productid]
  (str "user " username " list " listid " product " productid))

(defn delete-product [username, listid, productid]
  (str "user " username " list " listid " product " productid))

(defn get-public-lists [username]
  (str username " public lists"))

(defn get-private-lists [username]
  (str username " public lists"))

(defn create-list [username, new-list]
  (str username " created new list"))

(defn delete-list [username, listid]
  (str username " deleted list " listid))

(defn get-list [username, listid]
  (str username " get list " listid))

(defn update-list [username, listid]
  (str username " update list " listid))

(defn get-lists [username]
  (str username " lists"))


(defroutes home-routes
  (GET "/" [] (home-page))
  (GET "/docs" [] (ok (-> "docs/docs.md" io/resource slurp)))
  (GET "/users/:username/users/following" [username]
    (get-following-users))
  (GET "/users/:username/users/unfollowed" [username]
    (get-unfollowed-users))
  (POST "/users/:username/users/following/:following_username"
    [username, following_username]
    (follow-user))
  (DELETE "/users/:username/users/following/:following_username"
    [username, following_username]
    (unfollow-user))
  (GET "/users/:username/users/followers" [username]
    (get-followers))
  (GET "/users/:username/users/unfollowers" [username]
    (get-unfollowers))
  (GET "/users/:username/lists/following" [username]
    (get-lists-following))
  (GET "/users/:username/lists/unfollowed" [username]
    (get-lists-unfollowed))
  (GET "/users/:username/lists/following/:following_username/:listid"
    [username, following_username, listid]
    (follow-list))
  (GET "/users/:username/lists/following/:following_username/:listid"
    [username, following_username, listid]
    (unfollow-list))
  (GET "/users/:username/lists/:listid/followers" [username, listid]
    (get-list-followers))
  (GET "/users/:username/lists/:listid/unfollowers" [username, listid]
    (get-list-unfollowers))
  (POST "/users/:username/lists/:listid/products" [username, listid, {}]
    (add-product))
  (GET "/users/:username/lists/:listid/products" [username, listid]
    (get-list-products))
  (GET "/users/:username/lists/:listid/products/:productid"
    [username, listid, productid]
    (get-product))
  (DELETE "/users/:username/lists/:listid/products/:productid"
    [username, listid, productid]
    (delete-product))
  (GET "/users/:username/lists/public" [username]
    (get-public-lists))
  (GET "/users/:username/lists/private" [username]
    (get-private-lists))
  (POST "/users/:username/lists" [username, {}]
    (create-list))
  (DELETE "/users/:username/lists/:listid" [username, listid]
    (delete-list))
  (GET "/users/:username/lists/:listid" [username, listid]
    (get-list))
  (PUT "/users/:username/lists/:listid" [username, listid]
    (update-list))
  (GET "/users/:username/lists" [username]
    (get-lists)))
