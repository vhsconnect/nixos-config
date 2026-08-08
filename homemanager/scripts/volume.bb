#! /usr/bin/env bb

(require '[babashka.process :refer [sh shell]]
         '[cheshire.core :as json]
         '[clojure.string :as str])

(def ^:private IC-BT-ON "󰂯")
(def ^:private IC-BT-OFF "󰂲")
(def ^:private IC-VOL "󰕾")
(def ^:private IC-MIC "󰍬")
(def ^:private IC-MIC-MUTE "󰍭")

(defn spy [val]
  (println "DEBUG:" val)
  val)

(def dump (json/parse-string (:out (sh "pw-dump")) true))

(defn fmt-vol [{:keys [mute vol]}]
  (cond
    mute      "Muted"
    (some? vol) (str (Math/round (* 100.0 vol)) "%")
    :else     "—"))

(defn link-sink-id [nodes stream-id]
  (let [link (->> nodes
                  (filter #(and (= (:type %) "PipeWire:Interface:Link")
                                (= (get-in % [:info :output-node-id]) stream-id)))
                  first)]
    (get-in link [:info :input-node-id])))

(defn link-source-id [nodes stream-id]
  (let [link (->> nodes
                  (filter #(and (= (:type %) "PipeWire:Interface:Link")
                                (= (get-in % [:info :input-node-id]) stream-id)))
                  first)]
    (get-in link [:info :output-node-id])))

(defn- wpctl-volume [id]
  (let [line (:out (sh "wpctl" "get-volume" (str id)))
        toks (str/split (str/trim line) #"\s+")]
    {:mute (str/includes? line "MUTED")
     :vol  (when (and (= (first toks) "Volume:") (second toks))
             (Double/parseDouble (second toks)))}))

(defn- streams [nodes]
  (->> nodes
       (filterv #(= (:class %) "Stream/Output/Audio"))))

(defn- input-streams [nodes]
  (->> nodes
       (filterv #(= (:class %) "Stream/Input/Audio"))))

(defn- sinks [nodes]
  (->> nodes
       (filterv #(= (:class %) "Audio/Sink"))))

(defn- sources [nodes]
  (->> nodes
       (filterv #(= (:class %) "Audio/Source"))))

(defn- node-desc-from-id [nodes id]
  (let [node (->> nodes
                  (filterv #(= (:id %) id))
                  first)]
    (get-in node [:info :props :node.description])))

;; a node can be either 
;; - a midi bridge 
;; - a sink 
;; - a source 
;; - a stream
;; and a couple of more things

(defn get-nodes [all]
  (->> all
       (filterv #(= (:type %) "PipeWire:Interface:Node"))
       (mapv (fn [x]
               (let [id (:id x)
                     name (get-in x [:info :props :node.name])
                     stream? (= (get-in x [:info :props :media.class])
                                "Stream/Output/Audio")
                     sink-id (when stream? (link-sink-id all id))
                     sink-name (when sink-id (node-desc-from-id all sink-id))
                     input-stream? (= (get-in x [:info :props :media.class])
                                      "Stream/Input/Audio")
                     source-id (when input-stream? (link-source-id all id))
                     source-name (when source-id (node-desc-from-id all source-id))]

                 {:desc         (get-in x [:info :props :node.description])
                  :nick         (get-in x [:info :props :node.nick])
                  :name         name
                  :class        (get-in x [:info :props :media.class])
                  :serial       (get-in x [:info :props :object.serial])
                  :sink-id      sink-id
                  :sink-name    sink-name
                  :source-id    source-id
                  :source-name  source-name
                  :priority   (get-in x [:info :props :node.priority.session])
                  :app        (or (get-in x [:info :props :application.name])
                                  (get-in x [:info :props :node.name]))

                  :vol        (:vol (wpctl-volume id))
                  :mute       (:mute (wpctl-volume id))
                  :id         id})))))

(def nodes (get-nodes dump))

(defn volume-lines [nodes]
  (let [ss (streams nodes)]
    (if (empty? ss)
      [(str "VOL " IC-VOL "  — (no playback)")]
      (for [s ss
            :let [label (if (seq (:sink-name s))
                          (str (:app s) "  →  " (:sink-name s))
                          (:app s))]]
        (str "VOL "
             IC-VOL
             "  "
             label
             ": "
             (fmt-vol  s))))))

(defn input-lines [nodes]
  (let [ss (input-streams nodes)]
    (if (empty? ss)
      [(str "IN  " IC-MIC "  — (no input)")]
      (for [s ss
            :let [label (if (seq (:source-name s))
                          (str " ←  " (:source-name s))
                          (:app s))]]
        (str "IN  "
             IC-MIC
             "  "
             label
             ": "
             (fmt-vol  s))))))

;; display ;;

(defn- bluetooth-line []
  (let [show (:out (sh "bluetoothctl" "show"))
        devs (->> (:out (sh "bluetoothctl" "devices" "Connected"))
                  str/split-lines
                  (map #(str/replace % #"^Device\s+\S+\s+" ""))
                  (remove str/blank?))]
    (cond
      (not (str/includes? show "Powered: yes")) (str "Bluetooth  " IC-BT-OFF "  Off")
      (seq devs)                  (str "Bluetooth  " IC-BT-ON  "  Connected: " (str/join ", " devs))
      :else                       (str "Bluetooth  " IC-BT-OFF "  On (no devices)"))))

(defn- default-device-line [kind coll label]
  (let [default-name (->> (:out (sh "pactl" "info"))
                          (re-find (re-pattern (str "(?i)Default " kind ": (.+)")))
                          second
                          str/trim)
        node (some #(when (= (:name %) default-name) %) coll)]
    (str label (or (:desc node) default-name))))

(defn- default-sink-line []
  (default-device-line "Sink" (sinks nodes) "Default device: "))

(defn- default-source-line []
  (default-device-line "Source" (sources nodes) "Default input: "))

(defn- mic-line []
  (let [out (:out (sh "pactl" "get-source-mute" "@DEFAULT_SOURCE@"))]
    (if (str/includes? out "yes")
      (str "MIC " IC-MIC-MUTE "  Muted")
      (str "MIC " IC-MIC "  On"))))

(defn- display []
  (let [nodes (get-nodes dump)]
    (println (bluetooth-line))
    (println (default-sink-line))
    (println (default-source-line))
    (println (mic-line))
    (doseq [l (volume-lines nodes)] (println l))
    (doseq [l (input-lines nodes)] (println l))))

;; change ;;

(defn- fzf-select [lines prompt header]
  (when (seq lines)
    (try
      (let [res (shell {:in (str/join "\n" lines) :out :string :err :inherit}
                       "fzf" "--prompt" prompt "--header" header
                       "--reverse" "--height=40%" "--no-sort")]
        (some-> (:out res) str/trim not-empty))
      (catch Exception _ nil))))                    ; Esc / non-zero -> abort

(defn- first-token [s] (first (str/split s #"\s+")))

(defn- change []
  (let [ss    (streams nodes)
        sks   (sinks nodes)]
    (if (empty? ss)
      (do (println "No playback streams to move.") (System/exit 1))
      (let [stream-lines (for [s ss]
                           (str (:id s) "  " (:app s) "  " (:sink-name s)))
            sel (fzf-select stream-lines "Stream› " "Select the playback stream to move")]
        (cond
          (nil? sel) (do (println "Aborted.") (System/exit 0))
          :else
          (let [stream-id (first-token sel)
                {cur :sink-id app :app sid :serial} (some #(when (= (str (:id %)) stream-id) %) ss)
                sink-lines (for [sk sks
                                 :let [mark (if (= (:id sk) cur) "▶" " ")]]
                             (str (:id sk) "  " mark "  " (:desc sk) "  (" (fmt-vol sk) ")"))
                ssel (fzf-select sink-lines "Sink› "
                                 (str "Move \"" app "\" to a sink  (▶ = current)"))]
            (cond
              (nil? ssel) (do (println "Aborted.") (System/exit 0))
              :else
              (let [sink-id (first-token ssel)
                    sink-node (some #(when (= (str (:id %)) sink-id) %) sks)
                    sink-name (:desc sink-node)]
                (sh "pactl" "move-sink-input" (str sid) (str (:serial sink-node)))
                (println (str "Moved \"" app "\" → " sink-name))))))))))

(defn- change-default-output-sink []
  (let [options (sinks nodes)
        lines (for [o options] (str (:id o) "  " (:desc o)))
        ssel (fzf-select lines ">default" "Pick a default sink")]

    (cond
      (nil? ssel) (do (println "Aborted.") (System/exit 0))
      :else
      (let [sink-id (first-token ssel)
            sink-node (some #(when (= (str (:id %)) sink-id) %) options)]
        (sh "wpctl" "set-default" (str (:id sink-node)))))))

(defn- change-default-input-sink []
  (let [options (sources nodes)
        lines (for [o options] (str (:id o) "  " (:desc o)))
        ssel (fzf-select lines ">default" "Pick a default source")]

    (cond
      (nil? ssel) (do (println "Aborted.") (System/exit 0))
      :else
      (let [source-id (first-token ssel)
            source-node (some #(when (= (str (:id %)) source-id) %) options)]
        (sh "wpctl" "set-default" (str (:id source-node)))))))

;; cli ;;

(let [args (set *command-line-args*)]
  (cond
    (or (args "-h") (args "--help"))
    (do (println "Usage: vol-bb [-c|--change]")
        (println "  (no args)  show bluetooth, per-app volume, and mic status")
        (println "  -co         interactively move a playback stream to another sink")
        (println "  -do         change default output sink")
        (println "  -di         change default input source"))

    (or (args "-co") (args "--change-out")) (change)
    (or (args "-do") (args "--default-out")) (change-default-output-sink)
    (or (args "-di") (args "--default-in")) (change-default-input-sink)
    :else (display)))
