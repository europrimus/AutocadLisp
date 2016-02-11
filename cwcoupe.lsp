;;Auteur: Didier COURTY
;;Pour Autocad Map 3D et Cloudwoks (http://leica-geosystems.com/products/laser-scanners/software/leica-cloudworx)

(defun c:cwcoupe ( / oldosmode oldcmdecho derplan oldattdia)
	 (setq oldosmode (getvar "osmode"))(setvar "osmode" 0)
	 (setq oldcmdecho (getvar "cmdecho"))(setvar "cmdecho" 0)
	 (setq oldattdia (getvar "attdia"))(setvar "attdia" 0)
	 (setq coupe (entsel "plan de coupe :") )
	 (setq coupeobj (entget (car coupe)) )
	 (if (= (cdr (assoc 0 coupeobj)) "LWPOLYLINE")
		 (progn
		     (princ "\n l'objet est une polyligne \n")
	     	 (command "_.ucs" "_object" (cadr coupe))
			 (Command "_cwslice" "_Y" "0,0.1" "0,-0.1")
	         (command "_cwworkplane" "_elevation")
			 (command "_cwworkplane" "_align")
	     )
		 (princ "\nerreur: selectionez une plyligne \n")
	 )
	 (setvar "osmode" oldosmode)
	 (setvar "cmdecho" oldcmdecho)
	 (setvar "attdia" oldattdia) 

)
