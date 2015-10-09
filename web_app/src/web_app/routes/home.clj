(ns web-app.routes.home
  (:require [web-app.layout :as layout]
            [compojure.core :refer [defroutes GET POST PUT DELETE]]
            [ring.util.http-response :refer [ok]]
            [clojure.java.io :as io]
            [clj-http.client :as client]))

(defn home-page []
  (layout/render "home.html"))

(defn crawl-url [fetch-url]
  (let [crawled-page (client/get fetch-url)]
    (:body crawled-page)))

(defroutes home-routes
  (GET "/crawler" [fetch-url]
       (crawl-url fetch-url))
  (GET "/" [] (home-page)))
