;2015/08/25
;Try this out with all storms, not just large

PRO JOURNAL__20150825__Fig4_SEA_of_upflowing_ions__QUAD1AND2__background_overlaid__Alfvens_storms_GRL

  ;; ;the ins
 nEvBinsize=150.D
  ;; ;

  ;; ;the outs
  ;; date='20150818'
  date='20150824'

  outMaxFile='Fig_4--all_storms--ion_flux_up--'+ STRING(FORMAT='(I0)',nEvBinsize/60) + $
             '-HOUR_AVG.png'

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q12_st=qi[0].list_i[0]
  q12_1=qi[1].list_i[0]
  
  q12_st=[q12_st,qi[0].list_i[1]]
  q12_1=[q12_1,qi[1].list_i[1]]

  q12_st=q12_st[SORT(q12_st)]
  q12_1=q12_1[SORT(q12_1)]

  q12_utc=conv_julday_to_utc(ssc1.julday[q12_1])

  ;;now plot 'em!!
  maxInd=16 ;ion_flux_up
  maxStr='--ion_flux_up'

  sufStr = '--24hourdiff'

  rmDupes = 1
  IF rmDupes THEN sufStr = '--rmDupes' + sufStr

  ;get random ion_flux_up
  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,RANDOMTIMES=65,/NOPLOTS,/NOMAXPLOTS,OUT_BKGRND_MAXIND=bkgrnd_maxInd,OUT_TBINS=tBins,/USE_DARTDB_START_ENDDATE, $
                           MAXIND=maxInd,NEVBINSIZE=nEvBinsize,TBEFORESTORM=60.0D,TAFTERSTORM=60.0D,AVG_TYPE_MAXIND=1,/LOG_DBQUANTITY

  ;ION_FLUX_UP
  SUPERPOSE_STORMS_ALFVENDBQUANTITIES,STORMTYPE=2,STORMINDS=q12_st,SSC_TIMES_UTC=q12_utc,REMOVE_DUPES=rmDupes, $
                           /USE_DARTDB_START_ENDDATE, $
                           TBEFORESTORM=60.0D,TAFTERSTORM=60.0D, $
                           NEVBINSIZE=nEvBinsize, $
                           MAXIND=maxInd, $
                           AVG_TYPE_MAXIND=1, $
                           BKGRND_MAXIND=bkgrnd_maxInd, TBINS=tBins, $
                           SAVEMAXPLOTNAME=outMaxFile, $
                           /LOG_DBQUANTITY, $
                           YRANGE_MAXIND=[1e5,1e10], $
                           YTITLE_MAXIND="Maximum upward ion flux (N $cm^{-3} s^{-1}$)"

END