;;Auteur: Didier COURTY
;;Pour Autocad Map 3D et Cloudworx Basic (http://leica-geosystems.com/products/laser-scanners/software/leica-cloudworx)


(defun c:cwcoupe ( / oldosmode oldcmdecho derplan oldattdia)
   (setmode)
	 (setq coupe (entsel "plan de coupe :") )
	 (setq coupeobj (entget (car coupe)) )
	 (princ "\n l'objet est une polyligne \n")
	 (command-s "_.ucs" "_object" (cadr coupe))
	 (princ "Isoler les objets\n")
	 (command-s _isolateobjects (list -10 -0.2) (list 50 0.2) )	; cache le reste du dessin
	 (princ "Slice CloudWorx\n")
	 (Command "_cwslice" "_Y" "0,0.1" "0,-0.1")
	 (command-s "_.ucs" "x" "-100")
	 (command-s "_plan" "Courant")
	 (command-s "_.ucs" "g")
	 ;(command-s _unisolateobjects)	; affiche tout
	 (resetmode)
)
;
(defun err (s)
  (if (= s "Function cancelled")
    (princ "Commande annulee")
    (progn (princ "Erreur: ")
	   (princ s)
	   (terpri)
    ) ;_ progn
  ) ; if
  (resetmode)
  (princ "Variables systemes restaurees\n")
  (princ)
)
;
(defun setmode  ()
	 (setq oldosmode (getvar "osmode"))(setvar "osmode" 0)
	 (setq oldcmdecho (getvar "cmdecho"))(setvar "cmdecho" 0)
	 (setq oldattdia (getvar "attdia"))(setvar "attdia" 0)
	 (setq derplan (getvar "clayer"))
	 (setq oerr *error*)
	 (setq *error* err)
	 (vl-load-com)
     (setq thisdrawing (vla-get-activedocument (vlax-get-acad-object)))
	 (vla-StartUndoMark  thisdrawing)
)
;
(defun resetmode  ()
	 (vla-EndUndoMark  thisdrawing)
	 (setvar "osmode" oldosmode)
	 (setvar "cmdecho" oldcmdecho)
	 (setvar "attdia" oldattdia)
	 (setvar "CLAYER" derplan)
	 (setq *error* oerr)
)
