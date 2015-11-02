(ns web-app.core
  (:require [reagent.core :as reagent :refer [atom]]
            [reagent.session :as session]
            [secretary.core :as secretary :include-macros true]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [markdown.core :refer [md->html]]
            [ajax.core :refer [GET POST]]
            [reagent-modals.modals :as modal]
            [clojure.walk :as walk]
            [cognitect.transit :as transit])
  (:import goog.History))

(def session-state (atom {:lists nil :current-list-products nil
                          :username "akxs14" :current-list-id 0}))
(def wishlist-server "http://localhost:4567")
(def jquery (js* "$"))
(def r (transit/reader :json))

;; -------------------------
;; Event Handlers
(defn get-textbox-text [textbox-id]
  (-> (jquery textbox-id)
      (.val)))

(defn save-new-product
  "Saves a product in the current list"
  [url prod_name price description]
  (let [new-product-url (str wishlist-server "/users/"
                             (:username @session-state) "/lists/"
                             (:current-list-id @session-state) "/products")]
    (POST new-product-url
          {:params {:name prod_name :price price :description description}
           :format :json :response-format :json :keywords? true})
  (modal/close-modal!)))

(defn load-website
  "Loads the crawled HTML in the preview area"
  [crawled-html]
  (-> (jquery "#website-preview-area")
      (.html crawled-html)))

(defn preview-product-page
  "Crawls the given url and returns the html"
  [url]
  (GET "/crawler" {:params {:fetch-url url}
                   :handler load-website}))

(defn get-products-handler [response]
  (let [str-products (transit/read r response)]
    (swap! session-state assoc :current-list-products str-products)))

(defn get-list-products
  "Fetches list products from wishlist service"
  [username list-id]
  (GET (str wishlist-server "/users/" username "/lists/" list-id "/products")
       {:handler get-products-handler}))

(defn get-lists-handler
  "Stores lists in session-state and loads the first list products"
  [response]
  (let [str-lists (js->clj (.parse js/JSON response))
        lists (map walk/keywordize-keys str-lists)]
    (swap! session-state assoc :lists lists)
    (swap! session-state assoc :current-list-id (:id (first lists)))
    (get-list-products (:username @session-state) (:current-list-id @session-state))))

(defn delete-product [list-id product-id]
  (let [products (:current-list-products @session-state)
        updated-products (remove #(= (get % "id") product-id) products)]
    (.log js/console products)
    (.log js/console updated-products)
    ))

;; -------------------------
;; Components
(defn user-list-menu []
  (for [list (:lists @session-state)]
    [:li {:key (str "list-" (:id list))}
     [:a {:href "#" :on-click #(get-list-products (:username @session-state) (:id list))}
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
      [:button.col-md-3.col-md-offset-1 {:data-dismiss "modal"} "Cancel"]]]]])

(defn first-cell []
  [:p [:a {:on-click #(modal/modal! (add-product-page) {:size :lg})} "Click to add a product"]])

(defn product-cell [id prod_name price description]
  [:div.col-md-3.item-cell.product-cell [:p [:a {:href "http://www.google.com"} 
                                             (str prod_name " | " price " | " description)]]
   [:div.delete-product-icon [:a {:on-click #(delete-product (:current-list-id @session-state) id)} 
                              [:img {:src "img/x_icon.png"}]]]])

(defn first-row [products]
   [:div#first-row.row
    [:div#first-cell.col-md-3.item-cell]
    (for [product products]
      (product-cell (get product "id") (get product "name") (get product "price") (get product "description")))])

(defn product-row [products]
   [:div.row
    (for [product products]
      (product-cell (get product "id") (get product "name") (get product "price") (get product "description")))])

(defn product-grid [list-products]
  (map #(product-row %) (partition-all 4 list-products)))

;; -------------------------
;; Pages
(defn home-page []
  (let [list-products (:current-list-products @session-state)
        first-row-end-index (min 3 (count list-products))
        first-row-products (subvec list-products 0 first-row-end-index)]
  [:div#grid-container.container-fluid
   [first-row first-row-products]
   (if (> (count list-products) 3)
     (product-grid (subvec list-products 3)))   
   [modal/modal-window]]))

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
