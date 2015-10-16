(ns web-app.core
  (:require [reagent.core :as reagent :refer [atom]]
            [reagent.session :as session]
            [secretary.core :as secretary :include-macros true]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [markdown.core :refer [md->html]]
            [ajax.core :refer [GET POST]]
            [reagent-modals.modals :as modal]
            [clojure.walk :as walk])
  (:import goog.History))

(def session-state (atom {:lists nil :current-list-products nil
                          :username "akxs14" :current-list-id 0}))
(def wishlist-server "http://localhost:4567")
(def jquery (js* "$"))

;; -------------------------
;; Ajax call handlers
(defn load-list-products [username list-id]
  (GET (str wishlist-server "/users/" username "/lists/" list-id "/products")
       {:handler #(.log js/console %)}))

(defn get-lists-handler [response]
  (let [str-lists (js->clj (.parse js/JSON response))
        lists (map walk/keywordize-keys str-lists)]
    (swap! session-state assoc :lists lists)
    (swap! session-state assoc :current-list-id (:id (first lists)))
    (load-list-products (:username @session-state) (:current-list-id @session-state))))

(defn load-website [response]
  (-> (jquery "#website-preview-area")
      (.html response)))

(defn get-textbox-text [textbox-id]
  (-> (jquery textbox-id)
      (.val)))

(defn save-product-result [response]
  (.log js/console response))

;; -------------------------
;; Event Handlers
(defn save-new-product [url prod_name price description]
  (let [new-product-url (str wishlist-server "/users/" 
                             (:username @session-state) "/lists/" 
                             (:current-list-id @session-state) "/products")]
    (POST new-product-url
          {:params {:name prod_name :price price :description description}
           :format :json :response-format :json :keywords? true})
  (modal/close-modal!)))

(defn preview-product-page [url]
  (GET "/crawler" {:params {:fetch-url url}
                   :handler load-website}))

;; -------------------------
;; Components
(defn user-list-menu []
  (for [list (:lists @session-state)]
    [:li {:key (str "list-" (:id list))}
     [:a {:href "#" :on-click #(load-list-products (:username @session-state) (:id list))}
      (:title list)]]))

(defn navbar []
  [:div.navbar.navbar-inverse.navbar-fixed-top
   [:div.container
    [:div.navbar-header
     [:a.navbar-brand {:href "#/"} "vosobe"]]
    [:div.navbar-collapse.collapse
     [:form.navbar-form.navbar-left {:role "search"}
      [:div.form-group
       [:input#search-txtbox.form-control {:type "text" :placeholder "Find friends or lists"}]]
      ]
     [:ul.nav.navbar-nav.navbar-right
      [:li.dropdown
       [:a.dropdown-toggle {:href "#"
                            :data-toggle "dropdown"
                            :role "button"
                            :aria-haspopup "true"
                            :aria-expanded "false"}
        "My Lists" [:span.caret]]
        [:ul.dropdown-menu
         (user-list-menu)]]
      [:li {:class (when (= :settings (session/get :page)) )}
       [:a {:href "#/settings"} "Settings"]]
      [:li {:class (when (= :login (session/get :page)) )}
       [:a {:href "#/login"} "Login"]]]
     ]]])

(defn add-product-page []
  [:div#product-preview-modal
   [:div.row
    [:label.col-md-3 {:for "product_url"} "Enter product address"]
    [:input#product_url.col-md-9 {:type "text"
                                  :on-change #(preview-product-page (-> % .-target .-value))}
    ]]
   [:div.row
    [:div#website-preview-area.col-md-8]
    [:div#product-preview-form.col-md-4
     [:div.row
      [:label.col-md-4 {:for "product_name"} "Name"]
      [:input#product_name.col-md-8 {:type "text"}]]
     [:br]
     [:div.row
      [:label.col-md-4 {:for "product_price"} "Price"]
      [:input#product_price.col-md-8 {:type "text"}]]
     [:br]
     [:div.row
      [:label.col-md-4 {:for "product_descr"} "Description"]
      [:textarea#product_descr.col-md-8 {:rows 4}]]
     [:br]
     [:div.row
      [:button.col-md-3.col-md-offset-1
       {:on-click #(save-new-product
                     (get-textbox-text "#product_url")
                     (get-textbox-text "#product_name")
                     (get-textbox-text "#product_price")
                     (get-textbox-text "#product_descr"))} "Add"]
      [:button.col-md-3.col-md-offset-1 {:data-dismiss "modal"} "Cancel"]]
     ]]])

(defn first-cell []
  [:p [:a {:on-click #(modal/modal! (add-product-page) {:size :lg})} "Click to add a product"]])


;; -------------------------
;; Pages
(defn home-page []
  [:div#grid-container.container-fluid
   [:div#first-row.row
    [:div#first-cell.col-md-3.item-cell]]
   [modal/modal-window]])

(def pages
  {:home #'home-page})

(defn not-found []
  [:div [:h1 "404: Page doesn't exist"]])

(defn page []
  [(pages (session/get :page))])


;; -------------------------
;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
  (session/put! :page :home))

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
(defn mount-components []
  (reagent/render [#'navbar] (.getElementById js/document "navbar"))
  (reagent/render [#'page] (.getElementById js/document "app"))
  (reagent/render [#'first-cell] (.getElementById js/document "first-cell")))

(defn init! []
  (hook-browser-navigation!)
  (mount-components)
  (GET (str wishlist-server "/users/" (:username @session-state) "/lists")
       {:handler get-lists-handler}))
