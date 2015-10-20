;2015/10/19
;A copy of journal__20150824__REDO_w_BrettNOAA__Fig4_SEA_of_upflowing_ions__background_overlaid__Alfvens_storms_GRL.pro
;I'm trying to restrict to a given MLT range.

PRO JOURNAL__20151019__FIG5_SEA_OF_PFLUX_AND_ION__ENERGY__LARGESTORMS__MLT_RESTRICTION__ALFSTORM2

  ;; ;the ins
  nEvBinsize=600.D
  minM = -6
  maxM = 6
  maxInd=16                     ;ion_flux_up
  maxStr='--ion_flux_up'
  rmDupes = 1

  ;; ;the outs
  date='20151019'
  outMaxFile='Fig_4--ion_flux_up--'+ STRING(FORMAT='(F0.1)',nEvBinsize/60) + $
             '-HOUR_AVG--'+date+'.png'

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  ;get random ion_flux_up
  superpose_storms_nevents,RANDOMTIMES=40,/NOPLOTS,/NOMAXPLOTS,OUT_BKGRND_MAXIND=bkgrnd_maxInd,OUT_TBINS=tBins,/USE_DARTDB_START_ENDDATE, $
                           MAXIND=maxInd,NEVBINSIZE=nEvBinsize,TBEFORESTORM=60.0D,TAFTERSTORM=60.0D,AVG_TYPE_MAXIND=1,/LOG_DBQUANTITY, $
                           MINMLT=minM,MAXMLT=maxM

  ;ION_FLUX_UP
  superpose_storms_nevents,STORMTYPE=1,STORMINDS=q1_st,SSC_TIMES_UTC=q1_utc,REMOVE_DUPES=rmDupes, $
                           /USE_DARTDB_START_ENDDATE, $
                           TBEFORESTORM=60.0D,TAFTERSTORM=60.0D, $
                           NEVBINSIZE=nEvBinsize, $
                           /NEVENTHISTS, /OVERPLOT_HIST, $
                           MAXIND=maxInd, $
                           AVG_TYPE_MAXIND=1, $
                           BKGRND_MAXIND=bkgrnd_maxInd, $
                           TBINS=tBins, $
                           ;;SAVEMAXPLOTNAME=outMaxFile, $
                           /LOG_DBQUANTITY, $
                           YRANGE_MAXIND=[1e5,1e10], $
                           YTITLE_MAXIND="Maximum upward ion flux (N $cm^{-3} s^{-1}$)", $
                           MINMLT=minM,MAXMLT=maxM


END