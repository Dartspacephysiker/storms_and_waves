;2016/01/01
FUNCTION TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES,DO_DESPUN=do_despun, $
   DSTCUTOFF=dstCutoff, $
   SMOOTH_DST=smooth_dst

  smoothStr            = ''
  IF KEYWORD_SET(smooth_dst) THEN BEGIN
     smoothStr         = '--smDst'
  ENDIF

  indDir               = '/SPENCEdata/Research/database/temps/'
  filePref             = 'todays_nonstorm_mainphase_and_recoveryphase_fastdb_inds--dstCutoff_' + STRCOMPRESS(dstCutoff,/REMOVE_ALL) + "nT" + $
                         (KEYWORD_SET(do_despun) ? '--despun' : '')
  hoyDia               = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  todaysFile           = indDir+filePref+smoothStr+'--'+hoyDia+'.sav'

  RETURN,todaysFile

END