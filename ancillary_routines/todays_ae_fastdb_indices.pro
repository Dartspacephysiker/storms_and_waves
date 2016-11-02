;2016/01/01
FUNCTION TODAYS_AE_FASTDB_INDICES,DO_DESPUN=do_despun, $
                                  AE_STR=AE_str, $
                                  AECUTOFF=AECutoff, $
                                  SMOOTH_AE=smooth_AE

  smoothStr            = ''
  IF KEYWORD_SET(smooth_AE) THEN BEGIN
     smoothStr         = '--smAE'
  ENDIF

  indDir               = '/SPENCEdata/Research/database/temps/'
  filePref             = 'todays_' + AE_str + '_fastdb_inds--AECutoff_' + STRCOMPRESS(AEcutoff,/REMOVE_ALL) + "nT" + $
                         (KEYWORD_SET(do_despun) ? '--despun' : '')
  hoyDia               = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  todaysFile           = indDir+filePref+smoothStr+'--'+hoyDia+'.sav'

  RETURN,todaysFile

END