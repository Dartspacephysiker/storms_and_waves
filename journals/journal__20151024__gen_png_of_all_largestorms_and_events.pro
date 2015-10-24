;2015/10/24
;And now I want combined plots of every single large storm's Dst trace and the corresponding Alfven events. Chris has encouraged
;me to pick the most awesome ones.

PRO JOURNAL__20151024__GEN_PNG_OF_ALL_LARGESTORMS_AND_EVENTS

  ;;************************************************************
  ;;to be outputted
  savePlotPref='20151024--Largestorms_combinee--'
  scOutPref='20151024--Largestorms_combinee--scatterplots--'  ;scatter plots, N and S Hemi

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  rmDupes = 1

  FOR i = 0, N_ELEMENTS(q1_st)-1 DO BEGIN
  ;;SSC-centered here
     scOutFilePref  = STRING(FORMAT='(A0,I0,".png")',scOutPref,i)
     savePlotFile   = STRING(FORMAT='(A0,I0,".png")',savePlotPref,i)
;
     stackplots_storms_nevents_overlaid,STORMTYPE=1,STORMINDS=q1_st[i],SSC_TIMES_UTC=q1_utc[i], $
                                        /USE_DARTDB_START_ENDDATE,TBEFORESTORM=15.,TAFTERSTORM=60., $
                                        MAXIND=maxInd, REMOVE_DUPES=rmDupes, $
                                        RETURNED_NEV_TBINS_AND_HIST=stormtime_returned_tbins_and_nevhist,YRANGE_MAXIND=yRange_maxInd, $
                                        SAVEPLOTNAME=savePlotFile, $
                                        /DO_SCATTERPLOTS,SCPLOT_COLORLIST=['red'], $
                                        SCATTEROUTPREFIX=scOutFilePref
  ENDFOR

END