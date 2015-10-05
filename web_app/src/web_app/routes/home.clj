(ns web-app.routes.home
  (:require [web-app.layout :as layout]
            [compojure.core :refer [defroutes GET POST PUT DELETE]]
            [ring.util.http-response :refer [ok]]
            [clojure.java.io :as io]
            [clj-http.client :as client]))

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

(defn get-lists-following [username]
  (str "lists " username " is following"))

(defn get-lists-unfollowed [username]
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
  (let [response (client/get 
                   "http://localhost:4567/users/akxs14/lists"
                   {:accept :json})]
  {:body (:body response)}))

(defn crawl-url [fetch-url]
  (let [crawled-page (client/get fetch-url)]
    (:body crawled-page)))

(defroutes home-routes
  (GET "/users/:username/lists" [username]
       (get-lists username))
  (GET "/users/:username/lists/public" [username]
       (get-public-lists))
  (GET "/users/:username/lists/private" [username]
       (get-private-lists))
  (GET "/users/:username/lists/:listid" [username, listid]
       (get-list))
  (POST "/users/:username/lists" [username]
        (create-list))
  (PUT "/users/:username/lists/:listid" [username, listid]
       (update-list))
  (DELETE "/users/:username/lists/:listid" [username, listid]
          (delete-list))
  (POST "/users/:username/lists/:listid/products" [username, listid]
        (add-product))
  (GET "/users/:username/lists/:listid/products" [username, listid]
       (get-list-products))
  (GET "/users/:username/lists/:listid/products/:productid"
       [username, listid, productid]
       (get-product))
  (DELETE "/users/:username/lists/:listid/products/:productid"
          [username, listid, productid]
          (delete-product))
  (POST "/users/:username/users/following/:following_username"
        [username, following_username]
        (follow-user))
  (GET "/users/:username/users/following" [username]
       (get-following-users))
  (GET "/users/:username/users/unfollowed" [username]
       (get-unfollowed-users))
  (GET "/users/:username/users/followers" [username]
       (get-followers))
  (GET "/users/:username/users/unfollowers" [username]
       (get-unfollowers))
  (DELETE "/users/:username/users/following/:following_username"
          [username, following_username]
          (unfollow-user))
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
  (GET "/crawler" [fetch-url]
       (crawl-url fetch-url))
  (GET "/" [] (home-page))
  (GET "/docs" [] (ok (-> "docs/docs.md" io/resource slurp))))
