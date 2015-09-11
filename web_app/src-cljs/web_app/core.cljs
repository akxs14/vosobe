(ns web-app.core
  (:require [reagent.core :as reagent :refer [atom]]
            [reagent.session :as session]
            [secretary.core :as secretary :include-macros true]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [markdown.core :refer [md->html]]
            [ajax.core :refer [GET POST]])
  (:import goog.History))

(def state (atom nil))

(defn navbar []
  [:div.navbar.navbar-inverse.navbar-fixed-top
   [:div.container
    [:div.navbar-header
     [:a.navbar-brand {:href "#/"} "vosobe"]]
    [:div.navbar-collapse.collapse
     [:form.navbar-form.navbar-left {:role "search"}
      [:div.form-group
       [:input#search-txtbox.form-control {:type "text" :placeholder "Find friends or lists"}]]]
     [:ul.nav.navbar-nav.navbar-right
      [:li {:class (when (= :about (session/get :page)) )}
       [:a {:href "#/settings"} "Settings"]]
      [:li {:class (when (= :about (session/get :page)) )}
       [:a {:href "#/login"} "Login"]]]
     ]]])

(defn first-cell []
  [:p "Click to add a product"])

(defn about-page []
  [:div.container
   [:div.row
    [:div.col-md-12
     "this is the story of web_app... work in progress"]]])

(defn home-page []
  [:div#grid-container.container-fluid
   [:div#first-row.row
    [:div#first-cell.col-md-3.item-cell]]])

(def pages
  {:home #'home-page
   :about #'about-page})

(defn not-found []
  [:div [:h1 "404: Page doesn't exist"]])

(defn page []
  [(pages (session/get :page))])

;; -------------------------
;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
  (session/put! :page :home))

(secretary/defroute "/about" []
  (session/put! :page :about))

(secretary/defroute "*" [] (page not-found))

;; -------------------------
;; History
;; must be called after routes have been defined
(defn hook-browser-navigation! []
  (doto (History.)
        (events/listen
          EventType/NAVIGATE
          (fn [event]
              (secretary/dispatch! (.-token event))))
        (.setEnabled true)))

;; -------------------------
;; Initialize app
(defn fetch-docs! []
  (GET "/docs" {:handler #(session/put! :docs %)}))

(defn mount-components []
  (reagent/render [#'navbar] (.getElementById js/document "navbar"))
  (reagent/render [#'page] (.getElementById js/document "app"))
  (reagent/render [#'first-cell] (.getElementById js/document "first-cell")))

(defn init! []
  (fetch-docs!)
  (hook-browser-navigation!)
  (mount-components))
