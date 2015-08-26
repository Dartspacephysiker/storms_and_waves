;2015/08/26
;This journal might have just been outmoded by print_data_availability_utc

PRO JOURNAL__20150825__inspect_data_availability_during_fourstorms_in_1998__Alfvens_storms_GRL

  datDir = '/SPENCEdata/Research/Cusp/storms_Alfvens/saves_output_etc/'
  datFile = 'data_availability_during_fourStorms_in_1998.sav'
  ;; datFile = 'data_availability_during_fourStorms_in_1998--GE32Hz.sav'

  RESTORE,datDir+datFile

  load_maximus_and_cdbtime,maximus,cdbTime

;; UNIQ_ORB_INDSLIST
;; uniq_ORBSLIST

;; STORM_INDLIST 

;; INDS_ORBSLIST
;; TRANGES_ORBSLIST
;; tSpans_orbsList

  ;; N_ELEMENTS(uniq_orb_indslist(1))
  
  nStorms=4
  ;;times for each orb
  FOR i=0,nStorms-1 DO BEGIN
     tRanges = tRanges_orbsList[i]
     print,'i:',i
     help,tranges_orbslist[i]
     nElem=N_ELEMENTS(tRanges[i,0])
     print,nElem
     IF nElem GT 1 THEN BEGIN
        print,'start t: ',TIME_TO_STR(tRanges[i,0])
        print,'stop t : ',TIME_TO_STR(tRanges[i,1])
        dur=(tSpans_orbslist[i]/3600.
     ENDIF ELSE BEGIN
        dur = 0.0
     ENDELSE
     print,FORMAT='("duration of orbit data: ",F0.2," hours")',dur
     ;; FOR j=0,N_ELEMENTS(tList[*,0]) DO BEGIN
     ;;    ;; print,'j:',j
     ;; ENDFOR
  ENDFOR

END