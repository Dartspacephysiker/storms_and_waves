;2017/11/29
PRO PRINT_KATUS_EVENTS,Dst,int_i,mod_i,mp_i,rp_i,numInt,numMod, $
                       DONT_PRINT_INTENSE_EVTS=noInts, $
                       DONT_PRINT_MODERATE_EVTS=noMods, $
                       DUPLICADO_INT_I=duplicado_int_i, $
                       DUPLICADO_MOD_I=duplicado_mod_i

  evtHeader = STRING(FORMAT='(A0,T10,A0,T35,A0,T45,A0,T55,A0,T65,A0)', $
                     "Index", $
                     "Time", $
                     "Dst Δind", $
                     "DST_MP", $
                     "DST_MIN", $
                     "DST_RP")

  IF ~KEYWORD_SET(noInts) THEN BEGIN

     duplicadoStr = MAKE_ARRAY(numInt,/STRING,VALUE='')
     IF N_ELEMENTS(duplicado_int_i) GT 0 THEN BEGIN
        duplicadoStr[duplicado_int_i] = '*'
     ENDIF

     PRINT,""
     PRINT,"**************"
     PRINT,"INTENSE EVENTS"
     PRINT,"**************"
     PRINT,""
     PRINT,evtHeader
     lastInd = int_i[0]
     FOR k=0,numInt-1 DO BEGIN
        ind = int_i[k]
        PRINT,FORMAT='(A1,T3,I5,T10,A0,T35,I8,T45,I5,T55,I5,T65,A0)', $
              duplicadoStr[k], $
              k, $
              Dst.date[ind], $
              ind-lastInd, $
              Dst.dst[mp_i.ints[k]], $
              Dst.dst[ind], $
              Dst.dst[rp_i.ints[k]]
        lastInd = ind
     ENDFOR
  ENDIF

  IF ~KEYWORD_SET(noMods) THEN BEGIN

     duplicadoStr = MAKE_ARRAY(numMod,/STRING,VALUE='')
     IF N_ELEMENTS(duplicado_mod_i) GT 0 THEN BEGIN
        duplicadoStr[duplicado_mod_i] = '*'
     ENDIF

     PRINT,""
     PRINT,"***************"
     PRINT,"MODERATE EVENTS"
     PRINT,"***************"
     PRINT,""
     PRINT,evtHeader
     lastInd = mod_i[0]
     FOR k=0,numMod-1 DO BEGIN
        ind = mod_i[k]
        PRINT,FORMAT='(A1,T3,I5,T10,A0,T35,I8,T45,I5,T55,I5,T65,A0)', $
              duplicadoStr[k], $
              k, $
              Dst.date[ind], $
              ind-lastInd, $
              Dst.dst[mp_i.modr[k]], $
              Dst.dst[ind], $
              Dst.dst[rp_i.modr[k]]
        lastInd = ind
     ENDFOR
  ENDIF

END

PRO GET_KATUS_ET_AL_2013_STORM_PHASE_IDENTIFICATION, $
   USE_SYMH=use_SYMH, $
   FAST_ELECTRONDB_TIMES=FAST_electronDB_times

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__dst_and_ae_db.pro

  IF N_ELEMENTS(DST__dst) EQ 0 OR ~KEYWORD_SET(DST__fullMonty) THEN BEGIN
     LOAD_DST_AE_DBS,$
        DST_AE_DIR=Dst_AE_dir, $
        DST_AE_FILE=Dst_AE_file, $
        /FULL_DST_DB, $
        NO_AE=no_AE, $
        FORCE_LOAD_DB=force_load_DB, $
        LUN=lun
  ENDIF

  IF KEYWORD_SET(FAST_electronDB_times) THEN BEGIN
     earliest_UTC    = STR_TO_TIME('1996-10-06/16:26:02.417')

     ;; latest_UTC   = STR_TO_TIME('2001-12-31/23:59:59.999')
     latest_UTC    = STR_TO_TIME('2002-10-24/23:59:59.999')
  ENDIF

  Dst = TEMPORARY(DST__Dst)

  ;;0. Identify period [t1 to t2] and index (SYM-H or Dst) of interest
  ;;==================================================================
  ;; i. Electron DB runs late 1996 to ~2005 or something? (up to orbit 24634,
  ;;    which is up to 2002-10-24/23:35:00)
  ;;ii. Easy to do for both SYM-H and Dst? (But start with Dst)

  qualifier_i = LINDGEN(N_ELEMENTS(Dst.dst))

  IF KEYWORD_SET(earliest_JulDay) OR KEYWORD_SET(earliest_UTC) THEN BEGIN
     IF N_ELEMENTS(earliest_JulDay) EQ 0 THEN earliest_JulDay = UTC_TO_JULDAY(earliest_UTC)
     qualifier_i = CGSETINTERSECTION(qualifier_i,WHERE(Dst.JulDay GE earliest_JulDay))
  ENDIF

  IF KEYWORD_SET(latest_JulDay) OR KEYWORD_SET(latest_UTC) THEN BEGIN
     IF N_ELEMENTS(latest_JulDay) EQ 0 THEN latest_JulDay = UTC_TO_JULDAY(latest_UTC)
     qualifier_i = CGSETINTERSECTION(qualifier_i,WHERE(Dst.JulDay LE latest_JulDay))
  ENDIF

  ;;==================================
  ;;I. Identify candidate storm minima
  ;;==================================
  ;;i. Locate all intense (moderate) events by locating all storm peaks with
  ;;   Dst ≤ -100 nT (-50 nT). (This is the beginning of the recovery phase)
  
  ;; events list
  int_i = WHERE(dst.dst LE -100)
  mod_i = WHERE((dst.dst LE -50) AND (dst.dst GT -100))

  ;; isMin_i    = WHERE(( (dst.dst[int_i[1:-2]]-dst.dst[int_i[0:-3]]) LE 0) AND $
  ;;                    ( (dst.dst[int_i[2:-1]]-dst.dst[int_i[1:-2]]) GE 0)
  ;; isMin_i    = WHERE(( (dst.dst[1:-2]-dst.dst[0:-3]) LE 0) AND $
  ;;                    ( (dst.dst[2:-1]-dst.dst[1:-2]) GE 0)     ,nMin)

  ;; These lines say, "If Dst(i) LE to Dst(i-1) and LE Dst(i+1), call it a min"
  isMin       = Dst.dst * 0
  isMin[1:-2] = ( (dst.dst[1:-2]-dst.dst[0:-3]) LE 0) + ( (dst.dst[2:-1]-dst.dst[1:-2]) GE 0)

  int_i = CGSETINTERSECTION(qualifier_i,$
                            WHERE((isMin   EQ    2) AND $
                                  (dst.dst LE -100)     ), $
                                  COUNT=nInt_sI1)
  mod_i = CGSETINTERSECTION(qualifier_i,$
                            WHERE((isMin   EQ 2   ) AND $
                                  (dst.dst LE -50 ) AND $
                                  (dst.dst GT -100)     ), $
                                  COUNT=nMod_sI1)

  GET_STREAKS,int_i, $
              START_I=int_strt_ii, $
              STOP_I=int_stop_ii, $
              SINGLE_I=int_single_ii, $
              OUT_STREAKLENS=int_streakLens, $
              N_STREAKS=int_n_streaks, $
              /QUIET

  GET_STREAKS,mod_i, $
              START_I=mod_strt_ii, $
              STOP_I=mod_stop_ii, $
              SINGLE_I=mod_single_ii, $
              OUT_STREAKLENS=mod_streakLens, $
              N_STREAKS=mod_n_streaks, $
              /QUIET

  IF N_ELEMENTS(mod_strt_ii  ) LE 1 OR N_ELEMENTS(int_strt_ii  ) LE 1 OR $
     N_ELEMENTS(mod_single_ii) LE 1 OR N_ELEMENTS(int_single_ii) LE 1    $
  THEN STOP

  IF ((WHERE(int_streakLens GT 2)) NE -1) OR $
     ((WHERE(mod_streakLens GT 3)) NE -1)    $
  THEN STOP

  ;;Combine all single points with any streaks
  ;;(A streak is a sequence of contiguous observations of the same Dst value)
  ;;I am assuming that it doesn't matter which one I pick

  int_i = [int_i[[int_single_ii,int_strt_ii]]]
  mod_i = [mod_i[[mod_single_ii,mod_strt_ii]]]

  int_i = int_i[SORT(int_i)]
  mod_i = mod_i[SORT(mod_i)]

  nInt_sI2 = N_ELEMENTS(int_i)
  nMod_sI2 = N_ELEMENTS(mod_i)

  ;; ALL OF THE FOLLOWING IS DIAGNOSTIC

  ;; int_vetted_i = [int_i[[int_single_ii,int_strt_ii]]]
  ;; mod_vetted_i = [mod_i[[mod_single_ii,mod_strt_ii]]]

  IF (CGSETINTERSECTION(int_i,mod_i))[0] NE -1 THEN STOP ;these should not intersect, of course

  ;; IF (N_ELEMENTS(int_i)-LONG(TOTAL(int_streaklens))) NE N_ELEMENTS(intense_vetted_i) THEN STOP
  ;; IF (N_ELEMENTS(mod_i)-LONG(TOTAL(mod_streaklens))) NE N_ELEMENTS(moderate_vetted_i) THEN STOP

  ;; FOR k=0,int_n_streaks-1 DO PRINT,FORMAT='(I0,I0)', $
  ;;                                  dst.dst[int_i[int_strt_ii[k]]], $
  ;;                                  dst.dst[int_i[int_stop_ii[k]]]
  ;; FOR k=0,mod_n_streaks-1 DO PRINT,FORMAT='(I0,I0)', $
  ;;                                  dst.dst[mod_i[mod_strt_ii[k]]], $
  ;;                                  dst.dst[mod_i[mod_stop_ii[k]]]

  ;;=================================================
  ;;II. Identify beginning of main and recovery phase
  ;;=================================================
  ;; i. Main phase begins: maximum Dst within the 24 h preceding the peak
  ;;ii. Recovery phase end: maximum Dst within 96 h after the peak
  
  ;;chop off any events for which we don't have 24 points before or 96 points after
  int_i = int_i[WHERE((int_i GE 24                        ) AND $
                      (int_i LE (N_ELEMENTS(Dst.dst) - 96)),nInt_sII1)]
  mod_i = mod_i[WHERE((mod_i GE 24                        ) AND $
                      (mod_i LE (N_ELEMENTS(Dst.dst) - 96)),nMod_sII1)]

  IF nInt_sII1 LT nInt_sI2 THEN BEGIN
     PRINT, $
        FORMAT='("Lost ",I0," intense events to 24 h and 96 h available bef and aft req)', $
        nInt_sI2-nInt_sII1
  ENDIF
  IF nMod_sII1 LT nMod_sI2 THEN BEGIN
     PRINT, $
        FORMAT='("Lost ",I0," moderate events to 24 h and 96 h available bef and aft req)', $
        nMod_sI2-nMod_sII1
  ENDIF

  mp_i = {ints : MAKE_ARRAY(nInt_sII1,/LONG,VALUE=0), $
          modr : MAKE_ARRAY(nMod_sII1,/LONG,VALUE=0)} ;IDL doesn't like me calling a struct member "mod"
  rp_i = {ints : MAKE_ARRAY(nInt_sII1,/LONG,VALUE=0), $
          modr : MAKE_ARRAY(nMod_sII1,/LONG,VALUE=0)}

  ;; Step II.i. and II.ii.
  FOR k=0,nInt_sII1-1 DO BEGIN
     junk         = MAX(Dst.dst[(int_i[k] - 24):(int_i[k] -  1)],MPind)
     junk         = MAX(Dst.dst[(int_i[k] +  1):(int_i[k] + 96)],RPind)
     mp_i.ints[k]  = int_i[k] - 24 + MPind
     rp_i.ints[k]  = int_i[k] +  1 + RPind
  ENDFOR
  FOR k=0,nMod_sII1-1 DO BEGIN
     junk         = MAX(Dst.dst[(mod_i[k] - 24):(mod_i[k] -  1)],MPind)
     junk         = MAX(Dst.dst[(mod_i[k] +  1):(mod_i[k] + 96)],RPind)
     mp_i.modr[k]  = mod_i[k] - 24 + MPind
     rp_i.modr[k]  = mod_i[k] +  1 + RPind
  ENDFOR

  ;; PRINT_KATUS_EVENTS,Dst,int_i,mod_i,mp_i,rp_i,nInt_sII1,nMod_sII1

  ;;===========================================================
  ;;III. Vet the list, ensure initially quiescent magnetosphere
  ;;===========================================================
  ;; i. Discard events that occur within 48 h of each other
  ;;ii. Discard events in which Dst drops below -50 nT (-25 nT) during the 12 h
  ;;    prior to the beginning of main phase
  
  ;; Step III.i.
  ;; (How?)

  ;; Step III.ii.
  discard_int_ii   = !NULL
  discard_mod_ii   = !NULL
  nDiscardMod_sIII2 = 0
  nDiscardInt_sIII2 = 0

  FOR k=0,nInt_sII1-1 DO BEGIN
     IF (WHERE(Dst.dst[(mp_i.ints[k]-12):(mp_i.ints[k]-1)] LE -50))[0] NE -1 THEN BEGIN
        discard_int_ii = [discard_int_ii,k]
        nDiscardInt_sIII2++
     ENDIF
  ENDFOR

  FOR k=0,nMod_sII1-1 DO BEGIN
     IF (WHERE(Dst.dst[(mp_i.modr[k]-12):(mp_i.modr[k]-1)] LE -25))[0] NE -1 THEN BEGIN
        discard_mod_ii = [discard_mod_ii,k]
        nDiscardMod_sIII2++
     ENDIF
  ENDFOR

  int_i = CGSETDIFFERENCE(int_i,int_i[discard_int_ii],COUNT=nInt_sIII2,POSITIONS=intPos_ii)
  mod_i = CGSETDIFFERENCE(mod_i,mod_i[discard_mod_ii],COUNT=nMod_sIII2,POSITIONS=modPos_ii)

  mp_i = {ints : mp_i.ints[intPos_ii], $
          modr : mp_i.modr[modPos_ii]}
  rp_i = {ints : rp_i.ints[intPos_ii], $
          modr : rp_i.modr[modPos_ii]}

  ;; STOP

  ;; NOW try to do step III.i.?
  lastInd = int_i[0]
  ;; duplicado_int_i = !NULL
  ;; duplicado_mod_i = !NULL

  PRINT,''
  PRINT,"**********"
  PRINT,"DUPLICADOS"
  PRINT,"**********"
  PRINT,""
  evtHeader = STRING(FORMAT='(A0,T10,A0,T35,A0,T45,A0,T55,A0,T65,A0)', $
                     "Index", $
                     "Time", $
                     "nAhead", $
                     "nMatchMP", $
                     "tSpan", $
                     "nMatchRP")
  PRINT,evtHeader
  dupeStruct     = {ints : {ind         : MAKE_ARRAY(1000,/LONG,VALUE=0), $
                            DstInds     : MAKE_ARRAY(2,1000,/LONG,VALUE=0), $ 
                            nAhead      : MAKE_ARRAY(1000,/LONG,VALUE=0), $
                            nMatchMP    : MAKE_ARRAY(1000,/LONG,VALUE=0), $
                            nMatchRP    : MAKE_ARRAY(1000,/LONG,VALUE=0), $
                            tSpan       : MAKE_ARRAY(1000,/LONG,VALUE=0), $
                            trueWarrior : MAKE_ARRAY(1000,/LONG,VALUE=0)}, $
                    modr : {ind         : MAKE_ARRAY(1000,/LONG,VALUE=0), $
                            DstInds     : MAKE_ARRAY(2,1000,/LONG,VALUE=0), $
                            nAhead      : MAKE_ARRAY(1000,/LONG,VALUE=0), $
                            nMatchMP    : MAKE_ARRAY(1000,/LONG,VALUE=0), $
                            nMatchRP    : MAKE_ARRAY(1000,/LONG,VALUE=0), $
                            tSpan       : MAKE_ARRAY(1000,/LONG,VALUE=0), $
                            trueWarrior : MAKE_ARRAY(1000,/LONG,VALUE=0)}}

  killDupe_i     = !NULL
  dupeStructInd  = 0
  FOR k=0,nInt_sIII2-1 DO BEGIN

     ;; Quick look ahead
     baseInd     = int_i[k]
     lookInd     = int_i[(k+1)<(nInt_sIII2-1)]
     kLook       = 1
     nAhead      = 0
     nMatchDstMP = 0
     nMatchDSTRP = 0
     tSpan       = 0
     warrior     = MIN(Dst.dst[[baseInd,lookInd]],tmpWarI)
     warriorInd  = (tmpWarI EQ 0 ? baseInd : lookInd)
     WHILE (((lookInd - baseInd) LE 6) AND $
            (lookInd NE baseInd)           )  DO BEGIN

        tSpan += (lookInd - baseInd)
        ;;See if MP and RP are also the same
        nMatchDstMP += (Dst.dst[mp_i.ints[k]] EQ Dst.dst[mp_i.ints[k+1+nAhead]])
        nMatchDstRP += (Dst.dst[rp_i.ints[k]] EQ Dst.dst[rp_i.ints[k+1+nAhead]])

        nAhead++
        baseInd    = lookInd
        lookInd    = int_i[k+1+nAhead]

        tmpWarrior = MIN(Dst.dst[[warriorInd,lookInd]],tmpWarI)
        IF tmpWarI NE 0 THEN BEGIN
           warrior = Dst.dst[lookInd]
           warriorInd = lookInd
        ENDIF

     ENDWHILE
     
     IF nAhead GT 0 THEN BEGIN

        dupeStruct.ints.ind        [dupeStructInd] = k
        dupeStruct.ints.DstInds    [*,dupeStructInd] = [int_i[k],int_i[k]+nAhead]
        dupeStruct.ints.nAhead     [dupeStructInd] = nAhead
        dupeStruct.ints.nMatchMP   [dupeStructInd] = nMatchDstMP
        dupeStruct.ints.nMatchRP   [dupeStructInd] = nMatchDstRP
        dupeStruct.ints.tSpan      [dupeStructInd] = tSpan
        dupeStruct.ints.trueWarrior[dupeStructInd] = warriorInd
        dupeStructInd++

        killDupe_i = [killDupe_i,[(int_i[k]):(int_i[k]+nAhead)]]
        
        ;; duplicado_int_i = [duplicado_int_i,k]

        PRINT,FORMAT='(I5,T10,A0,T35,I8,T45,I5,T55,I5,T65,A0)', $
              k, $
              Dst.date[int_i[k]], $
              nAhead, $
              nMatchDstMP, $
              tSpan, $
              nMatchDstRP

        k = k + nAhead
     ENDIF

  ENDFOR

  dupeStruct     = {ints : {ind         : dupeStruct.ints.ind        [0:dupeStructInd-1], $
                            DstInds     : dupeStruct.ints.DstInds    [*,0:dupeStructInd-1], $ 
                            nAhead      : dupeStruct.ints.nAhead     [0:dupeStructInd-1], $
                            nMatchMP    : dupeStruct.ints.nMatchMP   [0:dupeStructInd-1], $
                            nMatchRP    : dupeStruct.ints.nMatchRP   [0:dupeStructInd-1], $
                            tSpan       : dupeStruct.ints.tSpan      [0:dupeStructInd-1], $
                            trueWarrior : dupeStruct.ints.trueWarrior[0:dupeStructInd-1]}, $
                    modr : {ind         : dupeStruct.modr.ind        [0:dupeStructInd-1], $
                            DstInds     : dupeStruct.modr.DstInds    [*,0:dupeStructInd-1], $ 
                            nAhead      : dupeStruct.modr.nAhead     [0:dupeStructInd-1], $
                            nMatchMP    : dupeStruct.modr.nMatchMP   [0:dupeStructInd-1], $
                            nMatchRP    : dupeStruct.modr.nMatchRP   [0:dupeStructInd-1], $
                            tSpan       : dupeStruct.modr.tSpan      [0:dupeStructInd-1], $
                            trueWarrior : dupeStruct.ints.trueWarrior[0:dupeStructInd-1]}}

  PRINT_KATUS_EVENTS,Dst,int_i,mod_i,mp_i,rp_i,nInt_sIII2,nMod_sIII2, $
                     ;; DONT_PRINT_INTENSE_EVTS=noInts, $
                     ;; /DONT_PRINT_MODERATE_EVTS=noMods
                     /DONT_PRINT_MODERATE_EVTS, $
                     ;; DUPLICADO_INT_I=duplicado_int_i;, $
                     DUPLICADO_INT_I=dupeStruct.ints.ind;, $
                     ;; DUPLICADO_MOD_I=duplicado_mod_i


  ;;Now we can get all events that don't have nasty duplicates
  int_noDupe_i = CGSETINTERSECTION(int_i,killDupe_i,COUNT=nInt_noDupe)
  ;; mod_noDupe_i = CGSETINTERSECTION(mod_i,killDupe_i,COUNT=nMod_noDupe)

  STOP

  dupeInd[  2] : use   3
  dupeInd[  6] : use   7
  dupeInd[ 12] : use  12 (BUT TOSS? Mins spread over 18 h)
  dupeInd[ 15] : use  16 (BUT TOSS? Mins spread over 11 h)
  dupeInd[ 18] : use  20
  dupeInd[ 21] : use  22
  dupeInd[ 24] : use  26
  dupeInd[ 28] : use  29
  dupeInd[ 30] : use  30 (BUT TOSS! Mins spread over 18 h)
  dupeInd[ 37] : use  37
  dupeInd[ 41] : use  40 (! Yes, because the real bidness is 10 h before index 41)
  dupeInd[ 43] : use  44 
  dupeInd[ 45] : use  45
  dupeInd[ 48] : use  49
  dupeInd[ 54] : use  55
  dupeInd[ 60] : use  60
  dupeInd[ 63] : use  63
  dupeInd[ 68] : use  69
  dupeInd[ 72] : use  74
  dupeInd[ 75] : use  76
  dupeInd[ 82] : use  82 (But beware! Min showing up over 20 h)
  dupeInd[ 92] : use  92 
  dupeInd[ 94] : Throw out (part of dupeInd[92] storm)
  dupeInd[ 96] : use 97
  dupeInd[100] : use 101
  dupeInd[105] : use 105
  dupeInd[109] : use 110
  dupeInd[112] : Toss everything through 117



  ;;============================================
  ;;IV. Require existence of sudden commencement
  ;;============================================
  ;;i. Approximate SSC existence by requiring an increase in Dst by at least 10 nT
  ;;within 8 h before the beginning of main phase
  ;;Spence elaboration: I assume this means that I identify the earliest minimum 8
  ;;h before beginning of MP, then look for the max in the 8 h before MP, then
  ;;require that there be ΔDst ≥ 10 nT
  ;;
  ;;Spence elaboration2: No—assume it means that within 8 h before MP, Dst needs
  ;;to somewhere be ≤ Dst_MP - 10
  
  ;; Step IV.i
  discard_int_ii   = !NULL
  discard_mod_ii   = !NULL
  nDiscardInt_sIV1 = 0
  nDiscardMod_sIV1 = 0
  SSC_int_i        = !NULL
  SSC_mod_i        = !NULL

  FOR k=0,nInt_sIII2-1 DO BEGIN
     tmpArr = Dst.dst[(mp_i.ints[k]-8):(mp_i.ints[k])] - Dst.dst[(mp_i.ints[k])]
     IF (WHERE(tmpArr LE -10))[0] EQ -1 THEN BEGIN
        discard_int_ii = [discard_int_ii,k]
        nDiscardInt_sIV1++
     ENDIF ELSE BEGIN
        SSC_int_i = [SSC_int_i,mp_i.ints[k]-8+MIN(WHERE(tmpArr LE -10))]
     ENDELSE
  ENDFOR

  FOR k=0,nMod_sIII2-1 DO BEGIN
     tmpArr = Dst.dst[(mp_i.modr[k]-8):(mp_i.modr[k])] - Dst.dst[(mp_i.modr[k])]
     IF (WHERE(tmpArr LE -10))[0] EQ -1 THEN BEGIN
        discard_mod_ii = [discard_mod_ii,k]
        nDiscardMod_sIV1++
     ENDIF ELSE BEGIN
        SSC_mod_i = [SSC_mod_i,mp_i.modr[k]-8+MIN(WHERE(tmpArr LE -10))]
     ENDELSE
  ENDFOR

  int_i = CGSETDIFFERENCE(int_i,int_i[discard_int_ii],COUNT=nInt_sIV1,POSITIONS=intPos_ii)
  mod_i = CGSETDIFFERENCE(mod_i,mod_i[discard_mod_ii],COUNT=nMod_sIV1,POSITIONS=modPos_ii)

  mp_i  = {ints : mp_i.ints[intPos_ii], $
          modr : mp_i.modr[modPos_ii]}
  rp_i  = {ints : rp_i.ints[intPos_ii], $
          modr : rp_i.modr[modPos_ii]}
  ssc_i = {ints : TEMPORARY(SSC_int_i), $
           modr : TEMPORARY(SSC_mod_i)}

  PRINT_KATUS_EVENTS,Dst,int_i,mod_i,mp_i,rp_i,nInt_sIV1,nMod_sIV1, $
                     ;; DONT_PRINT_INTENSE_EVTS=noInts, $
                     ;; /DONT_PRINT_MODERATE_EVTS=noMods
                     /DONT_PRINT_MODERATE_EVTS

  DST__Dst = TEMPORARY(dst)
  STOP

END
