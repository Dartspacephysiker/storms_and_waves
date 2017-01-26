;;01/26/17
PRO READ_SEASONS_GMT_FILE

  COMPILE_OPT IDL2

  inDir         = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/seasons/'
  inFile        = 'seasons_GMT.txt'

  tmpltFile     = 'seasons_GMT_tmplt__idl.sav'

  outDir        = '/SPENCEdata/Research/database/storm_data/seasons/'
  outFile       = 'seasons_v0_0__idl.sav'

  ;; tmplt      = ASCII_TEMPLATE(inDir+inFile)
  ;; SAVE,tmplt,FILENAME=inDir+tmpltFile

  RESTORE,inDir+tmpltFile

  tmpSeason     = READ_ASCII(inDir+inFile,TEMPLATE=tmplt)

  nElem         = N_ELEMENTS(tmpSeason.y)

  julDay        = JULDAY(tmpSeason.m,tmpSeason.d,tmpSeason.y, $
                         tmpSeason.h+tmpSeason.h_offset,tmpSeason.min,MAKE_ARRAY(nElem,VALUE=0,/LONG))

  i_12          = WHERE(tmpSeason.delim EQ 12,n12)
  i_23          = WHERE(tmpSeason.delim EQ 23,n23)
  i_34          = WHERE(tmpSeason.delim EQ 34,n34)
  i_41          = WHERE(tmpSeason.delim EQ 41,n41)

  ii_12         = SORT(julDay[i_12])
  ii_23         = SORT(julDay[i_23])
  ii_34         = SORT(julDay[i_34])
  ii_41         = SORT(julDay[i_41])

  julDay[i_12]  = julDay[i_12[[ii_12]]]
  julDay[i_23]  = julDay[i_23[[ii_23]]]
  julDay[i_34]  = julDay[i_34[[ii_34]]]
  julDay[i_41]  = julDay[i_41[[ii_41]]]

  tags          = TAG_NAMES(tmpSeason)
  FOR k=0,N_ELEMENTS(tags)-1 DO BEGIN
     IF N_ELEMENTS(tmpSeason.(k)) EQ nElem THEN BEGIN
        PRINT,"Sorting " + tags[k] + ' ...'
        tmpSeason.(k)[i_12] = tmpSeason.(k)[i_12[ii_12]]
        tmpSeason.(k)[i_23] = tmpSeason.(k)[i_23[ii_23]]
        tmpSeason.(k)[i_34] = tmpSeason.(k)[i_34[ii_34]]
        tmpSeason.(k)[i_41] = tmpSeason.(k)[i_41[ii_41]]
     ENDIF
  ENDFOR
  
  ;;Recalc
  i_12          = WHERE(tmpSeason.delim EQ 12,n12)
  i_23          = WHERE(tmpSeason.delim EQ 23,n23)
  i_34          = WHERE(tmpSeason.delim EQ 34,n34)
  i_41          = WHERE(tmpSeason.delim EQ 41,n41)

  READ_SEASONS__SORT,julDay, $
                     n41,n12,i_41,i_12, $
                     transSp_i
  sp       = julDay[transSp_i]

  READ_SEASONS__SORT,julDay, $
                     n12,n23,i_12,i_23, $
                     transSu_i
  su       = julDay[transSu_i]

  READ_SEASONS__SORT,julDay, $
                     n23,n34,i_23,i_34, $
                     transFa_i
  fa       = julDay[transFa_i]

  READ_SEASONS__SORT,julDay, $
                     n34,n41,i_34,i_41, $
                     transWi_i
  wi       = julDay[transWi_i]

  time     = !NULL
  FOR k=0,nElem-1 DO BEGIN
     t     = STRING(FORMAT='(I4,"-",I02,"-",I02,"/",I02,":",I02,":",I02)', $
                    tmpSeason.y[k],tmpSeason.m[k],tmpSeason.d[k],tmpSeason.h[k]+tmpSeason.h_offset[k],tmpSeason.min[k],0L)
     time  = [time,t]
  ENDFOR

  utc      = JULDAY_TO_UTC(julDay)

  spring   = {julDay : sp, $
              UTC    : UTC[transSp_i], $
              time   : time[transSp_i]}
  summer   = {julDay : su, $
              UTC    : UTC[transSu_i], $
              time   : time[transSu_i]}
  fall     = {julDay : fa, $
              UTC    : UTC[transFa_i], $
              time   : time[transFa_i]}
  winter   = {julDay : wi, $
              UTC    : UTC[transWi_i], $
              time   : time[transWi_i]}

  info     = CREATE_STRUCT('timezone','Greenwich Mean Time (GMT)', $
                           'creation_date',GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
                           'version',0.1, $
                           'generating_routine','READ_SEASONS_GMT_FILE')
  
  season   = CREATE_STRUCT('time',time, $
                           'julday',julDay, $
                           'utc',utc, $
                           tmpSeason, $
                           'info',info)

  PRINT,"Saving season structs to " + outFile + ' ...'

  SAVE,season,spring,summer,fall,winter, $
       FILENAME=outDir+outFile

END

PRO READ_SEASONS__SORT,julDay, $
                       n00,n01,i_00,i_01, $
                       transSeason_i

  ;; maxNSeason = MIN([n00,n01])
  ;; Season_Inds    = [0:(maxNSeason-1)]
  ;; Season_i_00    = i_00[Season_Inds]
  ;; Season_i_01    = i_01[Season_Inds]
  Season_i_00    = i_00
  Season_i_01    = i_01

  transSeason_ii = -1
  shift          = 0
  CASE 1 OF
     (n00 GT n01): BEGIN
        transSeason_ii = WHERE((SHIFT(julDay,shift))[Season_i_00] LT julDay[Season_i_01])
        WHILE transSeason_ii[0] EQ -1 DO BEGIN
           shift++
           transSeason_ii = WHERE((SHIFT(julDay,shift))[Season_i_00] LT julDay[Season_i_01])
        ENDWHILE
        Season_i_00    = Season_i_00[transSeason_ii]-shift
        Season_i_01    = Season_i_01[transSeason_ii]
     END
     (n00 LT n01): BEGIN
        transSeason_ii = WHERE(julDay[Season_i_00] LT (SHIFT(julDay,shift))[Season_i_01])
        WHILE transSeason_ii[0] EQ -1 DO BEGIN
           shift--
           transSeason_ii = WHERE(julDay[Season_i_00] LT (SHIFT(julDay,shift))[Season_i_01])
        ENDWHILE
        Season_i_00    = Season_i_00[transSeason_ii]-shift
        Season_i_01    = Season_i_01[transSeason_ii]
     END
     ELSE: BEGIN
        transSeason_ii = WHERE(julDay[Season_i_00] LT (SHIFT(julDay,shift))[Season_i_01])
        WHILE transSeason_ii[0] EQ -1 DO BEGIN
           shift++
           transSeason_ii = WHERE(julDay[Season_i_00] LT (SHIFT(julDay,shift))[Season_i_01])
        ENDWHILE
        Season_i_00    = Season_i_00[transSeason_ii]-shift
        Season_i_01    = Season_i_01[transSeason_ii]
     END
  ENDCASE
  transSeason_i  = TRANSPOSE([[Season_i_00],[Season_i_01]])

END