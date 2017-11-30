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

PRO GET_KATUS__KILL_DUPES,Dst,mp_i,rp_i,dupeStruct, $
                          STORM_I=storm_i, $
                          STRUCTIND=structInd, $
                          COUNT=count, $
                          CUSTOMKILLS=customKills, $
                          OUT_DUPESTRUCTIND=dupeStructInd, $
                          OUT_KILLDUPE_I=killDupe_i, $
                          OUT_KEEPDUPE_I=keepDupe_i, $
                          OUT_NODUPE_I=noDupe_i, $
                          OUT_STORMIND_NODUPE=storm_ii_noDupe, $
                          OUT_STORMIND_KEEPDUPE=stormInd_keepDupe

  killDupe_i     = !NULL
  dupeStructInd  = 0

  FOR k=0,count-1 DO BEGIN

     ;; Quick look ahead
     baseInd     = storm_i[k]
     lookInd     = storm_i[(k+1)<(count-1)]
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
        nMatchDstMP += (Dst.dst[mp_i.(structInd)[k]] EQ Dst.dst[mp_i.(structInd)[k+1+nAhead]])
        nMatchDstRP += (Dst.dst[rp_i.(structInd)[k]] EQ Dst.dst[rp_i.(structInd)[k+1+nAhead]])

        tmpWarrior = MIN(Dst.dst[[warriorInd,lookInd]],tmpWarI)
        IF tmpWarI NE 0 THEN BEGIN
           warrior = Dst.dst[lookInd]
           warriorInd = lookInd
        ENDIF

        nAhead++
        baseInd    = lookInd
        lookInd    = storm_i[(k+1+nAhead)<(count-1)]

     ENDWHILE
     
     IF nAhead GT 0 THEN BEGIN

        dupeStruct.(structInd).ind        [dupeStructInd] = k
        dupeStruct.(structInd).DstInds    [*,dupeStructInd] = [k,k+nAhead]
        dupeStruct.(structInd).nAhead     [dupeStructInd] = nAhead
        dupeStruct.(structInd).nMatchMP   [dupeStructInd] = nMatchDstMP
        dupeStruct.(structInd).nMatchRP   [dupeStructInd] = nMatchDstRP
        dupeStruct.(structInd).tSpan      [dupeStructInd] = tSpan
        dupeStruct.(structInd).trueWarrior[dupeStructInd] = warriorInd
        dupeStructInd++

        PRINT,FORMAT='(I5,T10,A0,T35,I8,T45,I5,T55,I5,T65,A0)', $
              k, $
              Dst.date[storm_i[k]], $
              nAhead, $
              nMatchDstMP, $
              tSpan, $
              nMatchDstRP

        dummy = 0
        WHILE dummy LE nAhead DO BEGIN
           ;; killDupe_i = [killDupe_i,[(storm_i[k]):(storm_i[k]+nAhead)]]
           killDupe_i = [killDupe_i,(storm_i[k+dummy])]
           dummy++
        ENDWHILE

        k = k + nAhead

     ENDIF

  ENDFOR

  ;;Now we can get all events that don't have nasty duplicates
  noDupe_i = CGSETDIFFERENCE(storm_i,killDupe_i,COUNT=nStorm_noDupe,POSITIONS=storm_ii_noDupe)

  ;; Now the dupes
  ;; This array of tossables comes from
  keepDupe_i        = !NULL
  stormInd_keepDupe = !NULL
  FOR k=0,dupeStructInd-1 DO BEGIN
     
     IF N_ELEMENTS(customKills) GT 0 THEN BEGIN
        IF (WHERE(dupeStruct.(structInd).ind[k] EQ customKills))[0] NE -1 THEN CONTINUE
     ENDIF

     keepDupe_i        = [keepDupe_i,dupeStruct.(structInd).trueWarrior[k]]
     stormInd_keepDupe = [stormInd_keepDupe,WHERE(storm_i EQ dupeStruct.(structInd).trueWarrior[k])]

  ENDFOR

END

PRO GET_KATUS_ET_AL_2013_STORM_PHASE_IDENTIFICATION,intense,moderate, $
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
     junk          = MAX(Dst.dst[(int_i[k] - 24):(int_i[k] -  1)],MPind)
     junk          = MAX(Dst.dst[(int_i[k] +  1):(int_i[k] + 96)],RPind)
     mp_i.ints[k]  = int_i[k] - 24 + MPind
     rp_i.ints[k]  = int_i[k] +  1 + RPind
  ENDFOR
  FOR k=0,nMod_sII1-1 DO BEGIN
     junk          = MAX(Dst.dst[(mod_i[k] - 24):(mod_i[k] -  1)],MPind)
     junk          = MAX(Dst.dst[(mod_i[k] +  1):(mod_i[k] + 96)],RPind)
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

  ;; ints           = 1
  ;; First Ints, then Mods
  int_customKills = [15,30,41,94,112] ; 41 is a special case, since the storm actually starts with ind = 40
  GET_KATUS__KILL_DUPES,Dst,mp_i,rp_i,dupeStruct, $
                        STORM_I=int_i, $
                        STRUCTIND=0, $
                        COUNT=nInt_sIII2, $
                        CUSTOMKILLS=int_customKills, $
                        OUT_DUPESTRUCTIND=dupeStructIntInd, $
                        OUT_KILLDUPE_I=int_killDupe_i, $
                        OUT_KEEPDUPE_I=int_keepDupe_i, $
                        OUT_NODUPE_I=int_noDupe_i, $
                        OUT_STORMIND_NODUPE=int_noDupe_ii, $
                        OUT_STORMIND_KEEPDUPE=int_ind_keepDupe

  GET_KATUS__KILL_DUPES,Dst,mp_i,rp_i,dupeStruct, $
                        STORM_I=mod_i, $
                        STRUCTIND=1, $
                        COUNT=nMod_sIII2, $
                        CUSTOMKILLS=customKills, $
                        OUT_DUPESTRUCTIND=dupeStructModInd, $
                        OUT_KILLDUPE_I=mod_killDupe_i, $
                        OUT_KEEPDUPE_I=mod_keepDupe_i, $
                        OUT_NODUPE_I=mod_noDupe_i, $
                        OUT_STORMIND_NODUPE=mod_noDupe_ii, $
                        OUT_STORMIND_KEEPDUPE=mod_ind_keepDupe

  dupeStruct     = {ints : {ind         : dupeStruct.ints.ind        [0:dupeStructIntInd-1], $
                            DstInds     : dupeStruct.ints.DstInds    [*,0:dupeStructIntInd-1], $ 
                            nAhead      : dupeStruct.ints.nAhead     [0:dupeStructIntInd-1], $
                            nMatchMP    : dupeStruct.ints.nMatchMP   [0:dupeStructIntInd-1], $
                            nMatchRP    : dupeStruct.ints.nMatchRP   [0:dupeStructIntInd-1], $
                            tSpan       : dupeStruct.ints.tSpan      [0:dupeStructIntInd-1], $
                            trueWarrior : dupeStruct.ints.trueWarrior[0:dupeStructIntInd-1]}, $
                    modr : {ind         : dupeStruct.modr.ind        [0:dupeStructModInd-1], $
                            DstInds     : dupeStruct.modr.DstInds    [*,0:dupeStructModInd-1], $ 
                            nAhead      : dupeStruct.modr.nAhead     [0:dupeStructModInd-1], $
                            nMatchMP    : dupeStruct.modr.nMatchMP   [0:dupeStructModInd-1], $
                            nMatchRP    : dupeStruct.modr.nMatchRP   [0:dupeStructModInd-1], $
                            tSpan       : dupeStruct.modr.tSpan      [0:dupeStructModInd-1], $
                            trueWarrior : dupeStruct.ints.trueWarrior[0:dupeStructModInd-1]}}

  ;; PRINT_KATUS_EVENTS,Dst,int_i,mod_i,mp_i,rp_i,nInt_sIII2,nMod_sIII2, $
  ;;                    ;; DONT_PRINT_INTENSE_EVTS=noInts, $
  ;;                    ;; /DONT_PRINT_MODERATE_EVTS=noMods
  ;;                    /DONT_PRINT_MODERATE_EVTS, $
  ;;                    ;; DUPLICADO_INT_I=duplicado_int_i;, $
  ;;                    DUPLICADO_INT_I=dupeStruct.ints.ind;, $
  ;;                    ;; DUPLICADO_MOD_I=duplicado_mod_i

  ;; int_i_test = [int_noDupe_i,int_keepDupe_i]
  ;; int_i_test = int_i_test[SORT(int_i_test)]
  ;; mod_i_test = [mod_noDupe_i,mod_keepDupe_i]
  ;; mod_i_test = mod_i_test[SORT(mod_i_test)]

  int_ii = [int_noDupe_ii,int_ind_keepDupe]
  mod_ii = [mod_noDupe_ii,mod_ind_keepDupe]

  int_ii = int_ii[SORT(int_ii)]
  mod_ii = mod_ii[SORT(mod_ii)]
  ;; PRINT,ARRAY_EQUAL(int_i[int_ii],int_i_test)
  ;; PRINT,ARRAY_EQUAL(mod_i[mod_ii],mod_i_test)

  int_i = int_i[int_ii]
  mod_i = mod_i[mod_ii]

  mp_i  = {ints : mp_i.ints[int_ii], $
           modr : mp_i.modr[mod_ii]}
  rp_i  = {ints : rp_i.ints[int_ii], $
           modr : rp_i.modr[mod_ii]}

  ;; Step III.i
  int_tooClose = int_i*0L
  int_tooClose[1:-1] = (int_i[1:-1]-int_i[0:-2]) LE 48
  int_tooClose_ii = WHERE(int_tooClose)
  int_tooClose_ii = [int_tooClose_ii-1,int_tooClose_ii]
  int_tooClose_ii = int_tooClose_ii[SORT(int_tooClose_ii)]

  mod_tooClose = mod_i*0L
  mod_tooClose[1:-1] = (mod_i[1:-1]-mod_i[0:-2]) LE 48
  mod_tooClose_ii = WHERE(mod_tooClose)
  mod_tooClose_ii = [mod_tooClose_ii-1,mod_tooClose_ii]
  mod_tooClose_ii = mod_tooClose_ii[SORT(mod_tooClose_ii)]

  int_ii = CGSETDIFFERENCE(LINDGEN(N_ELEMENTS(int_i)),int_tooClose_ii,COUNT=nInt_sIII1)
  int_i  = int_i[int_ii]

  mod_ii = CGSETDIFFERENCE(LINDGEN(N_ELEMENTS(mod_i)),mod_tooClose_ii,COUNT=nMod_sIII1)
  mod_i  = mod_i[mod_ii]

  mp_i  = {ints : mp_i.ints[int_ii], $
           modr : mp_i.modr[mod_ii]}
  rp_i  = {ints : rp_i.ints[int_ii], $
           modr : rp_i.modr[mod_ii]}

  ;there are 6, so this should eliminate 12

  ;; nInt_sIII1 = N_ELEMENTS(int_i)
  ;; nMod_sIII1 = N_ELEMENTS(mod_i)

  PRINT_KATUS_EVENTS,Dst,int_i,mod_i,mp_i,rp_i,nInt_sIII1,nMod_sIII1
                     ;; DONT_PRINT_INTENSE_EVTS=noInts, $
                     ;; /DONT_PRINT_MODERATE_EVTS=noMods
                     ;; /DONT_PRINT_MODERATE_EVTS, $
                     ;; DUPLICADO_INT_I=duplicado_int_i;, $
                     ;; DUPLICADO_INT_I=dupeStruct.ints.ind;, $
                     ;; DUPLICADO_MOD_I=duplicado_mod_i

  ;; FOR k=0,N_ELEMENTS(dupestruct.ints.trueWarrior)-1 DO $
  ;;     PRINT,dupeStruct.ints.ind[k],WHERE(int_i EQ dupestruct.ints.trueWarrior[k])
  ;;         2           3M
  ;;         6           7M
  ;;         9           9M
  ;;        12          12M
  ;;        15          16M,TOSS 
  ;;        18          20M
  ;;        21          22M
  ;;        24          26M
  ;;        28          29M
  ;;        30          30M,TOSS 
  ;;        37          37M
  ;;        41          40!!!
  ;;        43          44M
  ;;        45          45M
  ;;        48          49M
  ;;        54          55M
  ;;        60          60M
  ;;        63          63M
  ;;        68          69M
  ;;        72          74M
  ;;        75          76M
  ;;        82          82M
  ;;        92          92M
  ;;        94          94TOSS 
  ;;        96          97M
  ;;       100         101M
  ;;       105         105M
  ;;       109         110M
  ;;       112         113TOSSEVERYTHING THROUGH 117


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

  FOR k=0,nInt_sIII1-1 DO BEGIN
     tmpArr = Dst.dst[(mp_i.ints[k]-8):(mp_i.ints[k])] - Dst.dst[(mp_i.ints[k])]
     IF (WHERE(tmpArr LE -10))[0] EQ -1 THEN BEGIN
        discard_int_ii = [discard_int_ii,k]
        nDiscardInt_sIV1++
     ENDIF ELSE BEGIN
        SSC_int_i = [SSC_int_i,mp_i.ints[k]-8+MIN(WHERE(tmpArr LE -10))]
     ENDELSE
  ENDFOR

  FOR k=0,nMod_sIII1-1 DO BEGIN
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

  intense = {date  : {ssc : Dst.date[ssc_i.ints], $
                      mp  : Dst.date[mp_i.ints], $
                      min : Dst.date[int_i], $
                      rp  : Dst.date[mp_i.ints]}, $
             time  : {ssc : S2T(Dst.date[ssc_i.ints]), $
                      mp  : S2T(Dst.date[mp_i.ints]), $
                      min : S2T(Dst.date[int_i]), $
                      rp  : S2T(Dst.date[rp_i.ints])}, $
             dst   : {ssc : Dst.dst[ssc_i.ints], $
                      mp  : Dst.dst[mp_i.ints], $
                      min : Dst.dst[int_i], $
                      rp  : Dst.dst[rp_i.ints]}, $
             stats : {ssc : {median  : MEDIAN(Dst.JulDay[ssc_i.ints] - Dst.JulDay[mp_i.ints])*24., $
                             mean    : MEAN(Dst.JulDay[ssc_i.ints] - Dst.JulDay[mp_i.ints])*24., $
                             stdev   : STDDEV(Dst.JulDay[ssc_i.ints] - Dst.JulDay[mp_i.ints])*24.}, $
                      mp  : {median  : MEDIAN(Dst.JulDay[mp_i.ints] - Dst.JulDay[int_i])*24., $
                             mean    : MEAN(Dst.JulDay[mp_i.ints] - Dst.JulDay[int_i])*24., $
                             stdev   : STDDEV(Dst.JulDay[mp_i.ints] - Dst.JulDay[int_i])*24.}, $
                      rp  : {median  : MEDIAN(Dst.JulDay[int_i] - Dst.JulDay[rp_i.ints])*24., $
                             mean    : MEAN(Dst.JulDay[int_i] - Dst.JulDay[rp_i.ints])*24., $
                             stdev   : STDDEV(Dst.JulDay[int_i] - Dst.JulDay[rp_i.ints])*24.}}}

  moderate = {date : {ssc : Dst.date[ssc_i.modr], $
                     mp  : Dst.date[mp_i.modr], $
                     min : Dst.date[mod_i], $
                     rp  : Dst.date[mp_i.modr]}, $
              time  : {ssc : S2T(Dst.date[ssc_i.modr]), $
                       mp  : S2T(Dst.date[mp_i.modr]), $
                       min : S2T(Dst.date[mod_i]), $
                       rp  : S2T(Dst.date[rp_i.modr])}, $
              dst   : {ssc : Dst.dst[ssc_i.modr], $
                       mp  : Dst.dst[mp_i.modr], $
                       min : Dst.dst[mod_i], $
                       rp  : Dst.dst[rp_i.modr]}, $
             stats : {ssc : {median  : MEDIAN(Dst.JulDay[ssc_i.modr] - Dst.JulDay[mp_i.modr])*24., $
                             mean    : MEAN(Dst.JulDay[ssc_i.modr] - Dst.JulDay[mp_i.modr])*24., $
                             stdev   : STDDEV(Dst.JulDay[ssc_i.modr] - Dst.JulDay[mp_i.modr])*24.}, $
                      mp  : {median  : MEDIAN(Dst.JulDay[mp_i.modr] - Dst.JulDay[mod_i])*24., $
                             mean    : MEAN(Dst.JulDay[mp_i.modr] - Dst.JulDay[mod_i])*24., $
                             stdev   : STDDEV(Dst.JulDay[mp_i.modr] - Dst.JulDay[mod_i])*24.}, $
                      rp  : {median  : MEDIAN(Dst.JulDay[mod_i] - Dst.JulDay[rp_i.modr])*24., $
                             mean    : MEAN(Dst.JulDay[mod_i] - Dst.JulDay[rp_i.modr])*24., $
                             stdev   : STDDEV(Dst.JulDay[mod_i] - Dst.JulDay[rp_i.modr])*24.}}}

  PRINT_KATUS_EVENTS,Dst,int_i,mod_i,mp_i,rp_i,nInt_sIV1,nMod_sIV1, $
                     ;; DONT_PRINT_INTENSE_EVTS=noInts, $
                     ;; /DONT_PRINT_MODERATE_EVTS=noMods
                     /DONT_PRINT_MODERATE_EVTS

  DST__Dst = TEMPORARY(dst)

  

END
