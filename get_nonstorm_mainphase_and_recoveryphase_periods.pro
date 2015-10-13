PRO GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS

  SET_STORMS_NEVENTS_DEFAULTS,tBeforeStorm=tBeforeStorm,tAfterStorm=tAfterStorm,$
                              swDBDir=swDBDir,swDBFile=swDBFile, $
                              stormDir=stormDir,stormFile=stormFile, $
                              DST_AEDir=DST_AEDir,DST_AEFile=DST_AEFile, $
                              dbDir=dbDir,dbFile=dbFile,db_tFile=db_tFile, $
                              dayside=dayside,nightside=nightside, $
                              restrict_charERange=restrict_charERange,restrict_altRange=restrict_altRange, $
                              MAXIND=maxInd,avg_type_maxInd=avg_type_maxInd,log_DBQuantity=log_DBQuantity, $
                              neg_and_pos_separ=neg_and_pos_separ,pos_layout=pos_layout,neg_layout=neg_layout, $
                              use_SYMH=use_SYMH,USE_AE=use_AE, $
                              OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity,USE_DATA_MINMAX=use_data_minMax, $
                              nEvBinsize=nEvBinsize,min_NEVBINSIZE=min_NEVBINSIZE, $
                              saveFile=saveFile,SAVESTR=saveStr, $
                              noPlots=noPlots,noMaxPlots=noMaxPlots, $
                              DO_SCATTERPLOTS=do_scatterPlots,SCPLOT_COLORLIST=scPlot_colorList,SCATTEROUTPREFIX=scatterOutPrefix, $
                              RANDOMTIMES=randomTimes

  ;;Load Dst, AE & Co.
  restore,dataDir+swDBDir+swDBFile
  restore,dataDir+stormDir+stormFile

  restore,dataDir+DST_AEDir+DST_AEFile 

  IF KEYWORD_SET(use_dartdb_start_enddate) THEN BEGIN
     startDate=str_to_time(maximus.time(0))
     stopDate=str_to_time(maximus.time(-1))
     PRINT,'Using start and stop time from Dartmouth/Chaston database.'
     PRINT,'Start time: ' + maximus.time(0)
     PRINT,'Stop time: ' + maximus.time(-1)
  ENDIF
  

  ;;Make sure Dst data has no big gaps
  CHECK_DST_FOR_GAPS,dst,STARTDATE=str_to_time(maximus.time(0)),STOPDATE=str_to_time(maximus.time(-1))
  ;;Smooth Dst data
  SMOOTH

END