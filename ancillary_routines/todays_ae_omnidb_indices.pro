;2016/08/19
FUNCTION TODAYS_AE_OMNIDB_INDICES, $
   AECUTOFF=AECutoff, $
   AE_STR=ae_str, $
   SMOOTH_AE=smooth_AE

  smoothStr            = ''
  IF KEYWORD_SET(smooth_AE) THEN BEGIN
     smoothStr         = '--sm' + AE_str
  ENDIF

  indDir               = '/SPENCEdata/Research/database/temps/'
  filePref             = 'todays_AE_OMNIdb_inds--' + $
                         'AECutoff_' + STRCOMPRESS(AECutoff,/REMOVE_ALL) + "nT"
  hoyDia               = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  todaysFile           = indDir+filePref+smoothStr+'--'+hoyDia+'.sav'

  RETURN,todaysFile

END