(ns vosobe.web-app.app
  (:require [vosobe.web-app.core :as core]))

;;ignore println statements in prod
(set! *print-fn* (fn [& _]))

(core/init!)
