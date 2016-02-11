;;Auteur: Didier COURTY
;;Pour Autocad map 3D 2016 avec Covadis 14 (http://www.geo-media.com/covadis.htm) et nuage de points Recap
;;Création de points topo Covadis avec un clic pour la position XY et un clic ,avec acrochage au nuage de point, pour le Z

(defun c:rcpptstopo ( / oldosmode pt1Z pt2 listXYZ Filtre) ;;   ( variable_entré / var_local)
	 (setmode)
	 (princ "\n")
	 (if (= *znuage* nil)
		(progn 
			(setq Filtre(list (cons 0 "ACDBPOINTCLOUDEX"))) ; filtre de sélection(0 . ACDBPOINTCLOUDEX)
			(setq maSelec (ssget "x" Filtre))
			;(princ maSelec)(princ "\n")	;debug
			(if (= maSelec nil)
				(progn 
					(setvar "ERRNO" 0)
					(princ "\nPas de nuage de point Autocad Recap\n")
					(exit)
				);
				(progn 
					(setq cntr 0)									;initialise le conteur
					(while (< cntr (sslength maSelec))				;parcourt la sélection
						(setq enlist(entget (ssname maSelec cntr)))	;get the DXF group codes of the entity
						(cond
						((= *znuage* nil) (setq *znuage* (caddr(cdr (assoc 12 enlist)))))
						((/= *znuage* (caddr(cdr (assoc 12 enlist)))) 
								(princ "\nDeux des nuages ont des origines différentes\n")
								(setq *znuage* nil)
								(setvar "ERRNO" 0)
								(exit)
						)
						(setq *znuage* (caddr(cdr (assoc 12 enlist))))
						);cond
						(setq cntr (+ cntr 1))
					)	;while
				)		;progn
			)			;if
		(princ "Nouveau décalage Z du nuage\n")
		)		;progn
	 )			;if
	 (princ "Décalage Z du nuage : ")(princ *znuage*)
	 (setvar "osmode" 69)(setvar "3DOSMODE" 0)			;; accrochage au objets : extrémité et point d'insertion
	 (setq pt2 (getpoint "\nCoordones XY:"))			;; récupération des coordonnées X et Y
	 (setvar "osmode" 0)(setvar "3DOSMODE" 128)			;; accrochage au objets : noeud du nuage de point
	 (setq pt1Z (caddr (getpoint "\nAltitude Z:")))		;; récupération de l'altitude
	 (if (/= pt1Z 0)(setq pt1Z (- pt1Z *znuage*)) )
	 ;(princ pt1Z)(princ "\n")	;debug
	 (if (<= pt1Z 0)
		(progn (resetmode) (err "Z null ou négatif") )
		(progn
			(setq listXYZ (list (car pt2) (cadr pt2) pt1Z))
			;(princ "\nX,Y,Z:")(princ listXYZ)
			(setvar "osmode" 0)(setvar "3DOSMODE" 0)	;;Désactive l'accrochage aux objets
			(command-s "__CovaConsPTop" listXYZ "")
		) ; end progn
	) ; end if
	 (resetmode)
	 (princ)
)
;

(defun c:rcpptstoporeset()
(setmode)
(setq *znuage* nil)
(princ "Suppresion de la valeur du décallage du nuage de point")
(resetmode)
(princ)
)
;

(defun err (s)
  (if (or (= s "Function cancelled") (= (getvar "ERRNO") 0))
    (princ "Commande annulée\n")
    (progn (princ "Erreur: ")
	   (princ s)
	   (terpri)
    ) ;_ progn
  ) ; if
  (resetmode)
  (princ "Variables systemes restaurées\n")
  (princ)
)
;
(defun setmode  ()
	 (setq oldosmode (getvar "osmode"))(setvar "osmode" 0)
	 (setq old3dosmode (getvar "3dosmode"))(setvar "3dosmode" 0)
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
	 (setvar "3dosmode" old3dosmode)
	 (setvar "cmdecho" oldcmdecho)
	 (setvar "attdia" oldattdia)
	 (setvar "CLAYER" derplan)
	 (setq *error* oerr)
)
;
