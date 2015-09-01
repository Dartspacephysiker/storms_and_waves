;2015/08/31
;Based on my inspection of Fig_1--four_storms_from_1998--data_avail_overlaid--20150826.png, it seems to me that the SSC identified on
;1998-09-24/23:45:00 will work nicely. This should have i=3 in dss, the 'dataStartStop' structure picked up via the journal file
;JOURNAL__20150825__get_startstop_for_four_storms__Alfvens_storms_GRL.pro.
;Looks like I'll go with orbit 8277


PRO JOURNAL__20150831__picking_an_orb_for_FAST_stacked_plot_to_show_Alf_identification__Alfvens_storms_GRL

  outDir = '/SPENCEdata/Research/Cusp/storms_Alfvens/saves_output_etc/'
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

  i=3 
  tSSC = STR_TO_TIME('1998-09-24/23:45:00')
  PRINT,''
  PRINT,'********************'
  PRINT,'STORM #' + STRCOMPRESS(i+1,/REMOVE_ALL)
  PRINT,'********************'
  PRINT,''
  GET_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=dss[i,0],T2=dss[i,1], $
                                      MAXIMUS=maximus,CDBTIME=cdbtime,RESTRICT_W_THESEINDS=good_i, $
                                      OUT_INDS=out_inds, $
                                      UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                      INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs,TSPANS_ORBS=tspans_orbs, $
                                      /PRINT_DATA_AVAILABILITY,/VERBOSE
  
  STOP
  ;;Do scatterplots?
  load_maximus_and_cdbtime,maximus,cdbtime & KEY_SCATTERPLOTS_POLARPROJ,/NORTH,JUST_PLOT_I=WHERE(maximus.orbit EQ 8277 AND maximus.sample_t LE 0.01 AND maximus.ilat GT 0),OUTFILE='scatterplot--orb_8277--sample_t_LT_0.01--NORTH--less_transp.png',/OVERLAYAURZONE,PLOTTITLE='Orbit 8277, Northern Hemisphere',COLOR_LIST='purple',STRANS=76

load_maximus_and_cdbtime,maximus,cdbtime & KEY_SCATTERPLOTS_POLARPROJ,/SOUTH,JUST_PLOT_I=WHERE(maximus.orbit EQ 8277 AND maximus.sample_t LE 0.01 AND maximus.ilat LT 0),OUTFILE='scatterplot--orb_8277--sample_t_LT_0.01--SOUTH--less_transp.png',/OVERLAYAURZONE,PLOTTITLE='Orbit 8277, Southern Hemisphere',COLOR_LIST='purple',STRANS=76

END

;Partial output from the above. Let's do orb...
;; Checking out orb8273  (4 / 32)
;; nInds : 206

;; Checking out orb8274  (5 / 32)
;; nInds : 148

;; Checking out orb8275  (6 / 32)
;; nInds : 244

;; Checking out orb8276  (7 / 32)
;; nInds : 715

;; Checking out orb8277  (8 / 32)
;; nInds : 352

;; Checking out orb8278  (9 / 32)
;; nInds : 80

;; Checking out orb8279  (10 / 32)
;; nInds : 352

;; Checking out orb8281  (11 / 32)
;; nInds : 86
