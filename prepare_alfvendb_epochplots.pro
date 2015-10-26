PRO PREPARE_ALFVENDB_EPOCHPLOTS,MINMAXDAT=minMaxDat,MAXDAT=maxDat,MINDAT=minDat, $
                                ALF_IND_LIST=alf_ind_list, $
                                LOG_DBQUANTITY=log_DBQuantity,NEG_AND_POS_SEPAR=neg_and_pos_separ
                                

     IF ( log_DBQuantity AND (alf_ind_list[1,0] NE -1)) OR neg_and_pos_separ THEN BEGIN

        ;Are there negs? Handle, if so
        IF (alf_ind_list[0])[0] NE -1 THEN BEGIN

           temp=WHERE(minMaxDat[*,1] GE 0.,/NULL)
           IF N_ELEMENTS(temp) GT 0 THEN maxDat=LIST(MAX(ABS(minMaxDat[temp,1]))) ELSE maxDat=LIST(!NULL)
           temp=WHERE(minMaxDat[*,0] GE 0.,/NULL)
           IF N_ELEMENTS(temp) GT 0 THEN minDat=LIST(MIN(ABS(minMaxDat[temp,0]))) ELSE minDat=LIST(!NULL)

        ENDIF ELSE BEGIN
           maxDat=LIST(!NULL)
           minDat=LIST(!NULL)
        ENDELSE

        IF (alf_ind_list[1])[0] NE -1 THEN BEGIN

           PRINT,"There are negs in this quantity, and you've asked me to log it. Can't do it"
           RETURN
           neg_and_pos_separ = 1

           temp=WHERE(minMaxDat[*,1] LT 0.,/NULL)
           IF N_ELEMENTS(temp) GT 0 THEN maxDat.add,MAX(ABS(minMaxDat[temp,1])) ELSE maxDat.add,!NULL
           temp=WHERE(minMaxDat[*,0] LT 0.,/NULL)
           IF N_ELEMENTS(temp) GT 0 THEN minDat.add,MIN(ABS(minMaxDat[temp,0])) ELSE minDat.add,!NULL

           ENDIF ELSE BEGIN
           maxDat.add,!NULL
           minDat.add,!NULL
        ENDELSE

        IF (alf_ind_list[0])[0] NE -1 AND (alf_ind_list[1])[0] NE -1 THEN BEGIN
           
           IF N_ELEMENTS(maxDat[0]) EQ 0 THEN BEGIN
              IF N_ELEMENTS(maxDat[1]) EQ 0 THEN BEGIN
                 PRINT,"something's up; neither maxdat_pos nor maxdat_neg are defined..."
                 RETURN
              ENDIF
              maxDat[0]=maxDat[1]
           ENDIF
           IF N_ELEMENTS(maxDat[1]) EQ 0 THEN BEGIN
              maxDat[1]=maxDat[0]
           ENDIF

           IF N_ELEMENTS((minDat[0])) EQ 0 THEN BEGIN
              IF N_ELEMENTS((minDat[1])) EQ 0 THEN BEGIN
                 PRINT,"something's up; neither maxdat_pos nor maxdat_neg are defined..."
                 RETURN
              ENDIF
              minDat[0]=minDat[1]
           ENDIF
           IF N_ELEMENTS((minDat[1])) EQ 0 THEN BEGIN
              minDat[1]=minDat[0]
           ENDIF

           IF (maxDat[0]) GE (maxDat[1]) THEN maxDat[1]=maxDat[0] $
           ELSE maxDat[0]=maxDat[1]

           IF (minDat[0]) LE (minDat[1]) THEN minDat[1]=minDat[0] $
           ELSE minDat[0]=minDat[1]
        ENDIF

     ENDIF ELSE BEGIN
        maxDat=MAX(minMaxDat[*,1])
        minDat=MIN(minMaxDat[*,0])
     ENDELSE

END