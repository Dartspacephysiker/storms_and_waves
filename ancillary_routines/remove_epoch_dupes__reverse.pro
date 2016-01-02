PRO REMOVE_EPOCH_DUPES__REVERSE,NEPOCHS=nEpochs, $
                                CENTERTIME=centerTime, $
                                TSTAMPS=tStamps,$
                                DATSTARTSTOP=datStartStop, $
                                HOURS_BEF_FOR_NO_DUPES=hours_bef_for_no_dupes, $
                                TBEFOREEPOCH=tBeforeEpoch


  PRINT,'Finding and trashing epochs that would otherwise appear twice in the superposed epoch analysis, working in reverse...'
     
  IF N_ELEMENTS(hours_bef_for_no_dupes) EQ 0 THEN BEGIN
     PRINT,'No time before epochs provided! Using tBeforeEpoch...'
     tBefNoDupes = tBeforeEpoch
     
  ENDIF ELSE BEGIN
     PRINT,'Using hours_bef_for_no_dupes = ' + STRCOMPRESS(hours_bef_for_no_dupes,/REMOVE_ALL) + $
           ' for duplicate removal...'
     tBefNoDupes = hours_bef_for_no_dupes
  ENDELSE
  
  keep_arr = MAKE_ARRAY(nEpochs,/INTEGER,VALUE=1)
  
  ;; FOR i=0,nEpochs-1 DO BEGIN
     
  ;;    FOR j=i+1,nEpochs-1 DO BEGIN
  FOR i=nEpochs-1,0,-1 DO BEGIN
     
     FOR j=i-1,0,-1 DO BEGIN
        IF keep_arr[i] AND keep_arr[j] THEN BEGIN
           IF ( centerTime[i]-centerTime[j] )/3600. LT tBefNoDupes THEN keep_arr[j] = 0
           ;; PRINT,i,j,( centerTime[i]-centerTime[j] )/3600.
        ENDIF
     ENDFOR
  ENDFOR
  
  keep_i = WHERE(keep_arr,nKeep,COMPLEMENT=bad_i,NCOMPLEMENT=nBad,/NULL)
  ;; ;resize everythang
  IF nBad GT 0 THEN BEGIN
     PRINT,'Losing ' + STRCOMPRESS(N_ELEMENTS(bad_i),/REMOVE_ALL) + ' epochs that would otherwise be duplicated in the SEA...'
     
     FOR j=0,N_ELEMENTS(bad_i)-1 DO print,FORMAT='("Epoch ",I0,":",TR5,A0)',bad_i[j],tStamps[bad_i[j]] ;show me where!
     
     datStartStop = datStartStop[keep_i,*]
     nEpochs = nKeep
     centerTime = centerTime[keep_i]
     tStamps = tStamps[keep_i]
     
  ENDIF ELSE PRINT,"No dupes to be had in reverse!!"
  
END