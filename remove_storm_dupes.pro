PRO REMOVE_STORM_DUPES,NSTORMS=nStorms,CENTERTIME=centerTime,TSTAMPS=tStamps,$
                       HOURS_AFT_FOR_NO_DUPES=hours_aft_for_no_dupes,TAFTERSTORM=tAfterStorm

  PRINT,'Finding and trashing storms that would otherwise appear twice in the superposed epoch analysis...'
     
  IF N_ELEMENTS(hours_aft_for_no_dupes) EQ 0 THEN BEGIN
     PRINT,'No time before/after storms provided! Using tAfterStorm...'
     tAftNoDupes = tAfterStorm
     
  ENDIF ELSE BEGIN
     PRINT,'Using hours_aft_for_no_dupes = ' + STRCOMPRESS(hours_aft_for_no_dupes,/REMOVE_ALL) + $
           ' for duplicate removal...'
     tAftNoDupes = hours_aft_for_no_dupes
  ENDELSE
  
  keep_i = MAKE_ARRAY(nStorms,/INTEGER,VALUE=1)
  
  FOR i=0,nStorms-1 DO BEGIN
     
     FOR j=i+1,nStorms-1 DO BEGIN
        IF keep_i[i] AND keep_i[j] THEN BEGIN
           IF ( centerTime(j)-centerTime[i] )/3600. LT tAftNoDupes THEN keep_i[j] = 0
        ENDIF
     ENDFOR
  ENDFOR
  
  keep = WHERE(keep_i,nKeep,COMPLEMENT=bad_i,NCOMPLEMENT=nBad,/NULL)
  ;; ;resize everythang
  IF nBad GT 0 THEN BEGIN
     PRINT,'Losing ' + STRCOMPRESS(N_ELEMENTS(bad_i),/REMOVE_ALL) + ' storms that would otherwise be duplicated in the SEA...'
     
     FOR j=0,N_ELEMENTS(bad_i)-1 DO print,FORMAT='("Storm ",I0,":",TR5,A0)',bad_i(j),tStamps(bad_i(j)) ;show me where!
     
     nStorms = nKeep
     centerTime = centerTime(keep)
     tStamps = tStamps(keep)
     
  ENDIF ELSE PRINT,"No dupes to be had here!"
  
END