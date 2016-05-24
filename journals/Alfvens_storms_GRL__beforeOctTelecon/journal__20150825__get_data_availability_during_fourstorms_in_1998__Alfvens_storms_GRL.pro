PRO JOURNAL__20150825__get_data_availability_during_fourstorms_in_1998__Alfvens_storms_GRL

  outDir = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/saves_output_etc/'
  ;; outFile = 'data_availability_during_fourStorms_in_1998--GE32Hz.sav'
  outFile = 'data_availability_during_fourStorms_in_1998.sav'
  journalFile= 'JOURNAL__20150825__get_data_availability_during_fourstorms_in_1998__Alfvens_storms_GRL.pro'

  ;; dataAvailSummary = 'data_availability_during_fourStorms_in_1998--GE32Hz.txt'
  ;; dataAvailSummary = 'data_availability_during_fourStorms_in_1998.txt'
  IF N_ELEMENTS(dataAvailSummary) GT 0 THEN OPENW,lun,dataAvailSummary,/GET_LUN

  datDir = outDir
  datStartStopFile = 'datStartStop_for_four_1998_storms--20150825.sav'

  RESTORE,datDir+datStartStopFile

  load_maximus_and_cdbtime,maximus,cdbTime

  nStorms=N_ELEMENTS(dss[*,0])    ;dss is dataStartStop, obtained from JOURNAL__20150825__get_startstop_for_four_storms__Alfvens_storms_GRL.pro

  ;;only restriction is on mag sampling frequency
  good_i = WHERE(maximus.sample_t LE 0.01)
  ;; good_i = WHERE(maximus.sample_t LE 0.034)

  FOR i=0,nStorms-1 DO BEGIN
     PRINT,''
     PRINT,'********************'
     PRINT,'STORM #' + STRCOMPRESS(i+1,/REMOVE_ALL)
     PRINT,'********************'
     PRINT,''
     GET_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=dss[i,0],T2=dss[i,1], $
                                         MAXIMUS=maximus,CDBTIME=cdbtime,RESTRICT_W_THESEINDS=good_i, $
                                         OUT_INDS=out_inds, $
                                         UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                         INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs,TSPANS_ORBS=tspans_orbs

     PRINT_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=dss[i,0],T2=dss[i,1], $
                                           UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                           INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs,TSPANS_ORBS=tspans_orbs, $
                                           EXTRA=1,LUN=lun

     IF i EQ 0 THEN BEGIN
        storm_indlist = LIST(out_inds)

        uniq_orbsList = LIST(uniq_orbs)
        uniq_orb_indsList=LIST(uniq_orb_inds)

        inds_orbsList = LIST(inds_orbs)
        tranges_orbsList = LIST(tranges_orbs)
        tspans_orbsList = LIST(tspans_orbs)

     ENDIF ELSE BEGIN
        storm_indList.add,out_inds

        uniq_orbsList.add,uniq_orbs
        uniq_orb_indsList.add,uniq_orb_inds

        inds_orbsList.add,inds_orbs
        tranges_orbsList.add,tranges_orbs
        tSpans_orbsList.add,tSpans_orbs
     ENDELSE
  ENDFOR

  IF N_ELEMENTS(lun) GT 0 THEN CLOSE,lun

  ;; STOP

  PRINT,'Saving ' + outDir + outFile
  save,inds_orbsList,tranges_orbsList,tSpans_orbsList,uniq_orb_indslist,uniq_orbslist,storm_indlist,journalFile,FILENAME=outDir+outFile

END