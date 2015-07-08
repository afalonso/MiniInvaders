(require 2htdp/image)
(require 2htdp/universe)

; 
; Alien Invasion: Defend Earth!
; 
; Aliens are coming and want to invade Earth and annihilate humankind.
; 
; Earth's destiny is in your hands. The first alien wave has just arrived 
; and you can stop them with the most advanced warship in the world.
; 
; Use the left and right keys to move your ship around and the "s" key to 
; launch a missile.
; 
; Sadly, the missiles are not powerful enough to destroy the alien ships, 
; but can you even hit them? It is not so easy as it seems at first!
; 
; Good luck, warrior, and enjoy!
;  
; 
; Note for the peer assessment:
; -----------------------------
; Joking apart, this program lets you move a ship around the bottom edge
; of the screen and launch a missile to the enemy ships. While a missile 
; is moving, no other missile can be launched.
; If the missile reaches the top edge without hitting any enemy ship, it
; disappears and a new missile can be launched. 
; If the missile hits an enemy ships, the missile disappears and a new one 
; can be launched then. However, the enemy ship will remain on the screen. 
; I've not figured out a simple mechanism to explode and destroy the alien
; ships and I think that it might be beyond our current knowledge level. 
; In any case, I hope you enjoy trying to hit the alien ships.
; 



;; =================
;; Constants:
(define WIDTH 600)
(define HEIGHT 400)

(define SHIP-Y 370)
(define UFO1-Y 50)
(define UFO2-Y 100)

(define MTS (empty-scene WIDTH HEIGHT "midnight blue"))

(define SHIP-IMAGE 
  (above (triangle 12 "solid" "white")
         (ellipse 60 15 "solid" "white")))
(define SHIP-WIDTH (round (/ (image-width SHIP-IMAGE) 2)))

(define UFO1-IMAGE
  (beside (rotate 270 (triangle 10 "solid" "yellow"))
          (ellipse 20 15 "solid" "yellow")
          (rotate 90 (triangle 10 "solid" "yellow"))))
(define UFO1-WIDTH (round (/ (image-width UFO1-IMAGE) 2)))

(define UFO2-IMAGE
  (beside (rotate 270 (triangle 15 "solid" "red"))
          (ellipse 30 20 "solid" "red")
          (rotate 90 (triangle 15 "solid" "red"))))
(define UFO2-WIDTH (round (/ (image-width UFO2-IMAGE) 2)))

(define MISSILE-IMAGE
  (rectangle 4 12 "solid" "green"))

(define SHIP-SPEED 5)
(define UFO1-SPEED 3)
(define UFO2-SPEED 7)
(define MISSILE-SPEED 10)



;; =================
;; Data definitions:

(define-struct ship (x dx))
;; Ship is (make-ship Natural[SHIP-WIDTH, WIDTH - SHIP-WIDTH] Integer)
;; interp. (make-ship x dx) is a ship with x-coordinate x and x-velocity dx
;;         the x is the center of the ship
;;         x  is in screen coordinates (pixels)
;;         dx is in pixels per tick
;;         The interval represents valid x screen coordinates, so the complete
;;         ship falls inside the screen (no side goes across the screen edges)
;;
(define S1 (make-ship SHIP-WIDTH  3))           ; at SHIP-WIDTH, moving left -> right at speed 3
(define S2 (make-ship 200        -4))           ; at 200, moving left <- right at speed -4
(define S3 (make-ship (- WIDTH SHIP-WIDTH) -2)) ; at WIDTH - SHIP-WIDTH, moving left <- right at speed -2
#;
(define (fn-for-ship c)
  (... (ship-x c)      ; Natural[SHIP-WIDTH, WIDTH - SHIP-WIDTH]
       (ship-dx c)))   ; Integer

;; Template rules used:
;;  - compound: 2 fields


(define-struct ufo (x dx hw))
;; Ufo is (make-ufo Natural[UFO-WIDTH, WIDTH - UFO-WIDTH] Integer Natural)
;; interp. (make-ufo x dx) is an UFO with x-coordinate x and x-velocity dx
;;         The x is the center of the UFO
;;         x  is in screen coordinates (pixels)
;;         dx is in pixels per tick
;;         width is the half-width of the UFO
;;         The interval represents valid x screen coordinates, so the complete
;;         UFO falls inside the screen (no side goes across the screen edges)
;;
(define U1 (make-ufo UFO1-WIDTH  3           UFO1-WIDTH)) ; at UFO1-WIDTH, moving left -> right at speed 3
(define U2 (make-ufo 200        -4           UFO1-WIDTH)) ; at 200, moving left <- right at speed -4
(define U3 (make-ufo (- WIDTH UFO2-WIDTH) -2 UFO2-WIDTH)) ; at WIDTH - UFO2-WIDTH, moving left <- right at speed -2
#;
(define (fn-for-ufo c)
  (... (ufo-x  u)      ; Natural[UFO-WIDTH, WIDTH - UFO-WIDTH]
       (ufo-dx u)      ; Integer
       (ufo-hw u)))    ; Natural

;; Template rules used:
;;  - compound: 3 fields


(define-struct missile (x y dy s))
;; Missile is (make-missile Natural[0, WIDTH) Natural[0, HEIGHT) Natural Boolean)
;; interp. (make-missile x y dy s) is a missile with x-coordinate x, y-coordinate y, 
;;         y-velocity dy, and shot (or not)
;;         The (x, y) is the center of the missile
;;         x, y are in screen coordinates (pixels)
;;         dy   is in pixels per tick
;;         s    is true if the missile was shot (false otherwise)
;;         The interval represents valid x and y screen coordinates
;;
(define M1 (make-missile 300  50 MISSILE-SPEED true))  ; at position (300,  50), speed MISSILE-SPEED and shot
(define M2 (make-missile 300 100 MISSILE-SPEED false)) ; at position (300, 100), speed MISSILE-SPEED and not shot
#;
(define (fn-for-missile m)
  (... (missile-x  m)      ; Natural[0, WIDTH)
       (missile-y  m)      ; Natural[0, HEIGHT)
       (missile-dy m)      ; Natural       
       (missile-s  m)))    ; Boolean

;; Template rules used:
;;  - compound: 4 fields


(define-struct world (s u1 u2 m))
;; World is (make-world Ship Ufo Ufo Missile)
;; interp. (make-world s u1 u2) is the world scenario that contains a ship and two UFOs.
;;         s  is a Ship struct
;;         u1 is an Ufo struct
;;         u2 is an Ufo struct
;;         m  is a Missile struct
;;         Each Ship and UFO structs contains the required data to locate and
;;         represent them inside the world. This world scenario is required to 
;;         handle the complete world with big-bang
(define W1 (make-world S1 U1 U3 M1))  ; Ship, UFOs and missile are already defined
(define W2 (make-world S2 U3 U2 M2))
(define W3 (make-world S1 U2 U1 M1))
#;
(define (fn-for-world w)
  (... (world-s  w)     ; Ship
       (world-u1 w)     ; Ufo1
       (world-u2 w)     ; Ufo2
       (world-m  w)))   ; Missile

;; Template rules used:
;;  - compound: 4 fields



;; =================
;; Functions:

;; ========= Functions for World
;; World -> World
;; called to start the defense of Earth
;; start with:
#;
(main (make-world (make-ship (/ WIDTH 2) SHIP-SPEED) 
                  (make-ufo (- WIDTH UFO1-WIDTH) (- UFO1-SPEED) UFO1-WIDTH)
                  (make-ufo UFO2-WIDTH UFO2-SPEED UFO2-WIDTH)
                  (make-missile 300 400 0 false)))
      
(define (main w)
  (big-bang w                     ; World
      (on-tick   update-world)    ; World -> World
      (to-draw   render-world)    ; World -> Image
      (on-key    handle-key)))    ; World KeyEvent -> World


;; World -> World
;; update the world scenario according to the actions performed by the ship and the UFO
;; No tests required as they are checked separately by each element of the world (ship, UFO and missile) 

;(define (update-world w) w)   ; stub

;<use template from World>

(define (update-world w)
  (make-world (update-ship    (world-s  w))    ; Ship
              (update-ufo     (world-u1 w))    ; Ufo
              (update-ufo     (world-u2 w))    ; Ufo
              (update-missile (world-m  w) (world-u1 w) (world-u2 w))))  ; Missile


;; World -> Image
;; render the world scenario placing the different elements at their correspondings locations
(check-expect (render-world (make-world (make-ship 300 5) 
                                        (make-ufo   50 5 UFO1-WIDTH)
                                        (make-ufo  100 5 UFO2-WIDTH)
                                        (make-missile 300 50 MISSILE-SPEED true)))
              (place-images 
               (list SHIP-IMAGE
                     UFO1-IMAGE
                     UFO2-IMAGE
                     MISSILE-IMAGE)
               (list (make-posn 300 SHIP-Y)
                     (make-posn 50  UFO1-Y)
                     (make-posn 100 UFO2-Y)
                     (make-posn 300 50))
               MTS))
(check-expect (render-world (make-world (make-ship 300 5) 
                                        (make-ufo   50 5 UFO1-WIDTH)
                                        (make-ufo  100 5 UFO2-WIDTH)
                                        (make-missile 300 50 MISSILE-SPEED false)))
              (place-images 
               (list SHIP-IMAGE
                     UFO1-IMAGE
                     UFO2-IMAGE)
               (list (make-posn 300 SHIP-Y)
                     (make-posn 50  UFO1-Y)
                     (make-posn 100 UFO2-Y))
               MTS))

;(define (render-world w) MTS)   ; stub

;<use template from World>

(define (render-world w)
  (if (missile-s (world-m w))
      (place-images 
       (list SHIP-IMAGE
             UFO1-IMAGE
             UFO2-IMAGE
             MISSILE-IMAGE)
       (list (make-posn (ship-x (world-s  w)) SHIP-Y)
             (make-posn (ufo-x  (world-u1 w)) UFO1-Y)
             (make-posn (ufo-x  (world-u2 w)) UFO2-Y)
             (make-posn (missile-x (world-m w)) (missile-y (world-m w))))
       MTS)
      (place-images 
       (list SHIP-IMAGE
             UFO1-IMAGE
             UFO2-IMAGE)
       (list (make-posn (ship-x (world-s  w)) SHIP-Y)
             (make-posn (ufo-x  (world-u1 w)) UFO1-Y)
             (make-posn (ufo-x  (world-u2 w)) UFO2-Y))
       MTS)))
      
  

;; World KeyEvent -> World
;; update the world scenario according to the key pressed (if any)
;; No tests required as they are checked by the handle-key function for the Ship and
;; the Missile
                          
;(define (handle-key w ke) w)   ; stub

;<use template from World>

(define (handle-key w ke)
  (make-world
   (ship-handle-key (world-s w) ke)
   (world-u1 w)
   (world-u2 w)
   (missile-handle-key (world-m w) (world-s w) ke)))
  
  

;; ========= Functions for Ship
;; Ship -> Ship
;; increase ship x-coodinate by dx and then zeros the current speed (dx), so the 
;; ship will move only while key is kept pressed
(check-expect (update-ship (make-ship 100  5)) (make-ship (+ 100 5) 0)) ; along the x-axis
(check-expect (update-ship (make-ship 100 -5)) (make-ship (- 100 5) 0))
  
(check-expect (update-ship (make-ship (- WIDTH SHIP-WIDTH 5)  5)) ; reach edges
              (make-ship (- WIDTH SHIP-WIDTH) 0))
(check-expect (update-ship (make-ship (+ SHIP-WIDTH 5)       -5))
              (make-ship SHIP-WIDTH           0))

(check-expect (update-ship (make-ship (- WIDTH SHIP-WIDTH 4)  5)) ; try to pass edges
              (make-ship (- WIDTH SHIP-WIDTH) 0))
(check-expect (update-ship (make-ship (+ SHIP-WIDTH 4)       -5))
              (make-ship SHIP-WIDTH           0))
   
;(define (update-ship s) s)   ; stub

;<use template from Ship>

(define (update-ship s)
  (cond [(< (+ (ship-x s) (ship-dx s)) SHIP-WIDTH)
         (make-ship SHIP-WIDTH 0)]
        [(> (+ (ship-x s) (ship-dx s)) (- WIDTH SHIP-WIDTH))
         (make-ship (- WIDTH SHIP-WIDTH) 0)]
        [else
         (make-ship (+ (ship-x s) (ship-dx s))
                    0)]))


;; Ship KeyEvent -> Ship
;; move the ship to left or right when left or right arrows are pressed respectively
;; any other pressed key has no effect on its movement
(check-expect (ship-handle-key (make-ship (/ WIDTH 2) 0)  "left")  ; ship is not moving
              (make-ship (/ WIDTH 2) (- SHIP-SPEED)))
(check-expect (ship-handle-key (make-ship (/ WIDTH 2) 0) "right")
              (make-ship (/ WIDTH 2) SHIP-SPEED))

(check-expect (ship-handle-key (make-ship (/ WIDTH 2)  5)  "left")  ; ship is moving
              (make-ship (/ WIDTH 2) (- SHIP-SPEED)))
(check-expect (ship-handle-key (make-ship (/ WIDTH 2) -5) "right")
              (make-ship (/ WIDTH 2) SHIP-SPEED))

(check-expect (ship-handle-key (make-ship (/ WIDTH 2) 5) " ")  ; no key or any other key is pressed
              (make-ship (/ WIDTH 2) 5))
(check-expect (ship-handle-key (make-ship (/ WIDTH 2) 0) " ")
              (make-ship (/ WIDTH 2) 0))

;(define (ship-handle-key s ke) s)   ; stub

;<template according to KeyEvent>

(define (ship-handle-key s ke)
  (cond [(key=? ke "left")  (make-ship (ship-x s) (- SHIP-SPEED))]
        [(key=? ke "right") (make-ship (ship-x s) SHIP-SPEED)]
        [else s]))



;; ========= Functions for Ufo
;; Ufo -> Ufo
;; increase UFO x-coodinate by dx; when gets to edge, change direction (sign of dx)
;; besides change of direction, dx value does not change
(check-expect (update-ufo (make-ufo 100  3 UFO1-WIDTH)) (make-ufo (+ 100 3)  3 UFO1-WIDTH)) ; along the x-axis
(check-expect (update-ufo (make-ufo 100 -3 UFO1-WIDTH)) (make-ufo (- 100 3) -3 UFO1-WIDTH))
  
(check-expect (update-ufo (make-ufo (- WIDTH UFO1-WIDTH 3)  3 UFO1-WIDTH)) ; reach edges
              (make-ufo (- WIDTH UFO1-WIDTH)  3 UFO1-WIDTH))
(check-expect (update-ufo (make-ufo (+ UFO1-WIDTH 3)       -3 UFO1-WIDTH))
              (make-ufo UFO1-WIDTH           -3 UFO1-WIDTH))

(check-expect (update-ufo (make-ufo (- WIDTH UFO1-WIDTH 2)  3 UFO1-WIDTH)) ; try to pass edges
              (make-ufo (- WIDTH UFO1-WIDTH) -3 UFO1-WIDTH))
(check-expect (update-ufo (make-ufo (+ UFO1-WIDTH 2)       -3 UFO1-WIDTH))
              (make-ufo UFO1-WIDTH           3 UFO1-WIDTH))
   
;(define (update-ufo u) u)   ; stub

;<use template from Ufo>

(define (update-ufo u)
  (cond [(< (+ (ufo-x u) (ufo-dx u)) (ufo-hw u))
         (make-ufo (ufo-hw u) (- (ufo-dx u)) (ufo-hw u))]
        [(> (+ (ufo-x u) (ufo-dx u)) (- WIDTH (ufo-hw u)))
         (make-ufo (- WIDTH (ufo-hw u)) (- (ufo-dx u)) (ufo-hw u))]
        [else
         (make-ufo (+ (ufo-x u) (ufo-dx u))                   
                   (ufo-dx u)
                   (ufo-hw u))]))



;; ========= Functions for Missile
;; Missile Ufo Ufo -> Missile
;; decrease Missile y-coodinate by dy. If it hits any UFO or reachs the top edge, it
;; dissapears quietly. At this moment, it does not destroy any UFO it may hit.
(check-expect (update-missile (make-missile 100 50 10 false)  ; missile not shot
                              (make-ufo 100 5 UFO1-WIDTH)
                              (make-ufo 100 7 UFO2-WIDTH))
              (make-missile 0 0 0 false))
(check-expect (update-missile (make-missile 200 200 10 true)  ; missile does not hit UFOs
                              (make-ufo 100 5 UFO1-WIDTH)
                              (make-ufo 100 7 UFO2-WIDTH))
              (make-missile 200 190 10 true))
(check-expect (update-missile (make-missile 100 0 10 true)  ; missile reaches top edge
                              (make-ufo 100 5 UFO1-WIDTH)
                              (make-ufo 100 7 UFO2-WIDTH))
              (make-missile 0 0 0 false))
(check-expect (update-missile (make-missile 100 50 10 true) ; missile hits UFO
                              (make-ufo 100 5 UFO1-WIDTH)
                              (make-ufo 100 7 UFO2-WIDTH))
              (make-missile 0 0 0 false))

;(define (update-missile m u1 u2) m)   ; stub

;<use template from Missile>

(define (update-missile m u1 u2)
  (if (missile-s m)
      (if (or (<= (missile-y m) 0)
              (hit-ufo m u1 UFO1-Y (image-height UFO1-IMAGE))
              (hit-ufo m u2 UFO2-Y (image-height UFO2-IMAGE)))
          (make-missile 0 0 0 false)
          (make-missile (missile-x m) (- (missile-y m) (missile-dy m)) (missile-dy m) true))
      (make-missile 0 0 0 false)))


;; Missile Ufo Natural Natural -> Boolean
;; produce true if the Missile hits the Ufo, given its y-coordinate and height, 
;; by checking whether the center of the missile lies inside the boundaries of the UFO.
;; Otherwise, it produces false
(check-expect (hit-ufo (make-missile 100 50 10 true)
                       (make-ufo 100 5 UFO1-WIDTH)
                       UFO1-Y (image-height UFO1-IMAGE)) true)
(check-expect (hit-ufo (make-missile 100 50 10 true)
                       (make-ufo 50 5 UFO1-WIDTH)
                       UFO1-Y (image-height UFO1-IMAGE)) false)

;(define (hit-ufo m u y h) false)  ; stub

;<use template from Missile>

(define (hit-ufo m u y h)
  (and (>= (missile-x m) (- (ufo-x u) (ufo-hw u)))
       (<= (missile-x m) (+ (ufo-x u) (ufo-hw u)))
       (>= (missile-y m) (- y (ufo-hw u)))
       (<= (missile-y m) (+ y (ufo-hw u)))))
          

;; Missile Ship KeyEvent -> Missile
;; shoots a missile if the "s" key is pressed and there is no missile on the screen
;; any other pressed key has no effect. If a missile was already on the screen, it 
;; continues its way
(check-expect (missile-handle-key (make-missile 100 50 10 true) ; missile already shot
                                  (make-ship (/ WIDTH 2) 5)
                                  "s")
              (make-missile 100 50 MISSILE-SPEED true))

(check-expect (missile-handle-key (make-missile 0 0 0 false) ; no missile on the screen
                                  (make-ship (/ WIDTH 2) 5)
                                  "s")
              (make-missile (/ WIDTH 2) SHIP-Y MISSILE-SPEED true))

;(define (missile-handle-key m s ke) m)   ; stub

;<template according to KeyEvent>

(define (missile-handle-key m s ke)
  (if (missile-s m)
      m
      (if (key=? ke "s")
          (make-missile (ship-x s) SHIP-Y MISSILE-SPEED true)
          m)))
