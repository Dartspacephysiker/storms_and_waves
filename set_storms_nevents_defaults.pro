PRO SET_STORMS_NEVENTS_DEFAULTS,tBeforeStorm=tBeforeStorm,tAfterStorm=tAfterStorm,$
                                swDBDir=swDBDir,swDBFile=swDBFile, $
                                stormDir=stormDir,stormFile=stormFile, $
                                DST_AEDir=DST_AEDir,DST_AEFile=DST_AEFile, $
                                dbDir=dbDir,dbFile=dbFile,db_tFile=db_tFile, $
                                dayside=dayside,nightside=nightside, $
                                restrict_charERange=restrict_charERange,restrict_altRange=restrict_altRange, $
                                MAXIND=maxInd,avg_type_maxInd=avg_type_maxInd,log_DBQuantity=log_DBQuantity, $
                                neg_and_pos_separ=neg_and_pos_separ,pos_layout=pos_layout,neg_layout=neg_layout, $
                                use_SYMH=use_SYMH,USE_AE=use_AE, $
                                OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity, $
                                nEvBinsize=nEvBinsize,min_NEVBINSIZE=min_NEVBINSIZE, $
                                saveFile=saveFile,SAVESTR=saveStr, $
                                PLOTTITLE=plotTitle,SAVEPLOTNAME=savePlotName, $
                                noPlots=noPlots,noMaxPlots=noMaxPlots, $
                                DO_SCATTERPLOTS=do_scatterPlots,SCPLOT_COLORLIST=scPlot_colorList,SCATTEROUTPREFIX=scatterOutPrefix
  

  defTBeforeStorm      = 60.0D                                                                       ;in hours
  defTAfterStorm       = 60.0D                                                                       ;in hours
  defStormType         =  2
                       
  defswDBDir           = 'sw_omnidata/'
  defswDBFile          = 'sw_data.dat'
                       
  defStormDir          = 'sw_omnidata/'
  defStormFile         = 'large_and_small_storms--1985-2011--Anderson.sav'
                       
  defDST_AEDir         = 'processed/'
  defDST_AEFile        = 'idl_ae_dst_data.dat'
                       
  defDBDir             = 'dartdb/saves/'
  ;; defDBFile            = 'Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'  
  ;; defDB_tFile          = 'Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'
  defDBFile            = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  defDB_tFile          = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'
                       
  defUse_SYMH          = 0
  defUse_AE            = 0

  defOmni_Quantity     = 0
  defLog_omni_quantity = 0

  defRestrict_altRange = 0
  defRestrict_charERange = 0

  defMaxInd            = 6
  defavg_type_maxInd   = 0
  defLogDBQuantity     = 0

  defNeg_and_pos_separ = 0
  defPos_layout= [1,1,1]
  defNeg_layout= [1,1,1]

  defSaveFile          = 0

  defnEvBinsize        = 150.0D                                                                        ;in minutes

  defNoPlots = 0 
  defNoMaxPlots = 0

  defDo_scatterPlots = 0
  defScatterOutPrefix = 'stackplots_storms_nevents--scatterplot'
  ;; defScPlot_colorList = ''

  ;;set defaults
  IF N_ELEMENTS(tBeforeStorm) EQ 0 THEN tBeforeStorm = defTBeforeStorm
  IF N_ELEMENTS(tAfterStorm) EQ 0 THEN tAfterStorm = defTAfterStorm

  IF N_ELEMENTS(swDBDir) EQ 0 THEN swDBDir=defswDBDir
  IF N_ELEMENTS(swDBFile) EQ 0 THEN swDBFile=defswDBFile

  IF N_ELEMENTS(stormDir) EQ 0 THEN stormDir=defStormDir
  IF N_ELEMENTS(stormFile) EQ 0 THEN stormFile=defStormFile

  IF N_ELEMENTS(DST_AEDir) EQ 0 THEN DST_AEDir=defDST_AEDir
  IF N_ELEMENTS(DST_AEFile) EQ 0 THEN DST_AEFile=defDST_AEFile

  IF N_ELEMENTS(dbDir) EQ 0 THEN dbDir=defDBDir
  IF N_ELEMENTS(dbFile) EQ 0 THEN dbFile=defDBFile
  IF N_ELEMENTS(db_tFile) EQ 0 THEN db_tFile=defDB_tFile

  IF KEYWORD_SET(dayside) THEN print,"Only considering dayside stuff!"
  IF KEYWORD_SET(nightside) THEN print,"Only considering nightside stuff!"

  IF N_ELEMENTS(restrict_charERange) EQ 0 THEN restrict_charERange = defRestrict_charERange
  IF N_ELEMENTS(restrict_altRange) EQ 0 THEN restrict_altRange = defRestrict_altRange

  IF N_ELEMENTS(maxInd) EQ 0 THEN maxInd =defMaxInd
  IF N_ELEMENTS(avg_type_maxInd) EQ 0 THEN avg_type_maxInd=defAvg_type_maxInd

  IF N_ELEMENTS(log_DBQuantity) EQ 0 THEN log_DBQuantity=defLogDBQuantity

  IF N_ELEMENTS(neg_and_pos_separ) EQ 0 THEN neg_and_pos_separ=defNeg_and_pos_separ
  IF N_ELEMENTS(pos_layout) EQ 0 Then pos_layout=defPos_layout
  IF N_ELEMENTS(neg_layout) EQ 0 Then neg_layout=defNeg_layout

  IF N_ELEMENTS(use_SYMH) EQ 0 THEN use_SYMH = defUse_SYMH
  IF N_ELEMENTS(use_AE)   EQ 0 THEN use_AE = defUse_AE
  IF N_ELEMENTS(omni_quantity) EQ 0 THEN omni_quantity = defOmni_quantity
  IF N_ELEMENTS(log_omni_quantity) EQ 0 THEN log_omni_quantity = defOmni_quantity

  IF N_ELEMENTS(nEvBinsize) EQ 0 THEN nEvBinsize=defnEvBinsize
  ;; nEvBinsize = nEvBinsize/60.0D
  min_NEVBINSIZE = nEvBinsize/60.0D

  IF N_ELEMENTS(saveFile) EQ 0 THEN saveFile=defSaveFile

  IF N_ELEMENTS(noPlots) EQ 0 THEN noPlots=defNoPlots
  IF N_ELEMENTS(noMaxPlots) EQ 0 THEN noMaxPlots=defNoMaxPlots

  IF N_ELEMENTS(do_scatterPlots) EQ 0 THEN do_scatterPlots = defdo_scatterPlots
  ;; IF N_ELEMENTS(scPlot_colorList) EQ 0 THEN scPlot_colorList = defscPlot_colorList

  IF KEYWORD_SET(savePlotName) THEN BEGIN
     IF SIZE(savePlotName,/TYPE) NE 7 THEN scatterOutPrefix=defScatterOutPrefix
  ENDIF

  IF saveFile THEN BEGIN 
     saveStr='save' 
     IF SIZE(saveFile,/TYPE) NE 7 THEN saveFile='superpose_storms_alfven_db_quantities.dat'
  ENDIF ELSE saveStr=''

  IF KEYWORD_SET(savePlotName) THEN BEGIN
     IF SIZE(savePlotName,/TYPE) NE 7 THEN savePlotName="SYM-H_plus_histogram.png"
  ENDIF

END