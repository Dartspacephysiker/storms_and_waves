;2016/01/01
FUNCTION TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES

  indDir               = '/SPENCEdata/Research/Cusp/database/temps/'
  filePref             = 'todays_nonstorm_mainphase_and_recoveryphase_fastdb_inds--'
  hoyDia               = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  todaysFile           = indDir+filePref+hoyDia+'.sav'

  RETURN,todaysFile

END