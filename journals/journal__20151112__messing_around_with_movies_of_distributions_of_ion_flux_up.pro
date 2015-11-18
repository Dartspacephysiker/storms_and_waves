
PRO JOURNAL__20151112__MESSING_AROUND_WITH_MOVIES_OF_DISTRIBUTIONS_OF_ION_FLUX_UP

  h_bs     = 10.0
  es_bs    = 0.25

  xRange   = [4,11]

  yRange_d = [0,1500]
  yRange_n = [0,400]

  ;;dayside
  histoplot_epochslices_of_alfvendbquantities,MAXIND=16, $
     EPOCHSLICE_HISTBINSIZE=es_bs, $
     EPOCHSLICE_XPLOTRANGE=xRange, $
     EPOCHSLICE_YPLOTRANGE=yRange_d, $
     HISTOBINSIZE=h_bs, $
     /USE_DARTDB_START_ENDDATE,STORMTYPE=1, $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     PLOTPREFIX='dayside--', $
     /MAKE_MOVIE, $
     MOVIE_FRAMERATE=1

  ;;nightside
  histoplot_epochslices_of_alfvendbquantities,MAXIND=16, $
     EPOCHSLICE_HISTBINSIZE=es_bs, $
     EPOCHSLICE_XPLOTRANGE=xRange, $
     EPOCHSLICE_YPLOTRANGE=yRange_n, $
     HISTOBINSIZE=h_bs, $
     /USE_DARTDB_START_ENDDATE,STORMTYPE=1, $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     PLOTPREFIX='nightside--', $
     /MAKE_MOVIE, $
     MOVIE_FRAMERATE=1

  

END