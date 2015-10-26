PRO JOURNAL__20151013__CHECK_FOR_GAPS_IN_DST


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
                              DO_SCATTERPLOTS=do_scatterPlots,epochPlot_colorNames=scPlot_colorList,SCATTEROUTPREFIX=scatterOutPrefix, $
                              RANDOMTIMES=randomTimes

  ;;Load Dst, AE & Co.
  restore,dataDir+swDBDir+swDBFile
  restore,dataDir+stormDir+stormFile

  restore,dataDir+DST_AEDir+DST_AEFile 

  diffDst_hr=(shift(dst.time,-1)-dst.time)/3600
  bigDiff=where(diffDst_hr GT 1.01,/NULL)
  help,bigdiff
  ;;She's null!

  sort_i=sort(dst.time)
  dst_tsort=dst.time[sort_i]
  print,array_equal(dst_tsort,dst.time)
  ;; 1; Good!

END