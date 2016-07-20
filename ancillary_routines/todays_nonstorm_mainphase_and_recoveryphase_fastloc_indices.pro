;2016/02/17
FUNCTION TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTLOC_INDICES, $
   STORMSTRING=stormString, $
   DSTCUTOFF=DstCutoff

  indDir               = '/SPENCEdata/Research/database/temps/'
  CASE KEYWORD_SET(stormString) OF
     1: BEGIN
        filePref       = 'todays_' + stormString + '_fastLoc_inds--Dstcutoff_' + STRCOMPRESS(DstCutoff,/REMOVE_ALL) + '--'
     END
     ELSE: BEGIN
        filePref       = 'todays_ns_mp_rp_fastLoc_inds--Dstcutoff_' + STRCOMPRESS(DstCutoff,/REMOVE_ALL) + '--'
     END
  ENDCASE

  hoyDia               = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  todaysFile           = indDir+filePref+hoyDia+'.sav'

  RETURN,todaysFile

END