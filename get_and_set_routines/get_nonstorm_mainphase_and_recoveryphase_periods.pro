;+
; NAME:
;
;
;
; PURPOSE:  ;   This PRO is inspired by Chaston et al. [2015] on "Broadband Low Frequency Electromagnetic Waves in the Inner Magnetosphere".
;		They use the method you see in this pro to identify "average" storm main phases, recovery phases, and nonstorm times.
;		The idea is this: 
;		(1)Mark any period with Dst >= -20 as nonstorm
;		(2)If Dst < -20,
;		   (a) if the slope of Dst (smoothed with a 6-hour running average) is negative, call this "main phase."
;		   (b) if the slope of Dst (smoothed with a 6-hour running average) is postive, call this "recovery phase."
;		That's it!
;
;
; CATEGORY:
;
;
;
; CALLING SEQUENCE:       Call this after using LOAD_DST_AE_DBS,dst to get the Dst DB loaded
;
; INPUTS:                 Dst:                         A Dst struct containing dst and dt_dst_sm6hr as members.

; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:  2015/10/14     BORN
;                        2017/11/30     Serious edits. Added all the Katus et al. [2013] stuff
;                                       (The early/late phase stuff was my idea, o'course.)
;
;-
PRO GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst, $
   DSTCUTOFF=DstCutoff, $
   SMOOTH_DST=smooth_Dst, $
   EARLIEST_UTC=earliest_UTC, $
   LATEST_UTC=latest_UTC, $
   USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
   EARLIEST_JULDAY=earliest_julDay, $
   LATEST_JULDAY=latest_julDay, $
   USE_KATUS_STORM_PHASES=use_katus_storm_phases, $
   STORM_DST_I=s_dst_i, $
   NONSTORM_DST_I=ns_dst_i, $
   MAINPHASE_DST_I=mp_dst_i, $
   RECOVERYPHASE_DST_I=rp_dst_i, $
   INITIALPHASE_DST_I=init_dst_i, $
   EARLYMAINPHASE_DST_I=earlyMP_dst_i, $
   EARLYRECOVERYPHASE_DST_I=earlyRP_dst_i, $
   LATEMAINPHASE_DST_I=lateMP_dst_i, $
   LATERECOVERYPHASE_DST_I=lateRP_dst_i, $
   N_STORM=n_s, $
   N_NONSTORM=n_ns, $
   N_MAINPHASE=n_mp, $
   N_RECOVERYPHASE=n_rp, $
   N_INITIALPHASE=n_init, $
   N_EARLYMAINPHASE=n_earlyMP, $
   N_EARLYRECOVERYPHASE=n_earlyRP, $
   N_LATEMAINPHASE=n_lateMP, $
   N_LATERECOVERYPHASE=n_lateRP, $
   QUIET=quiet, $
   LUN=lun
  
  COMPILE_OPT IDL2,STRICTARRSUBS

  defDstCutoff = -20

  IF N_ELEMENTS(dstCutoff) EQ 0 THEN BEGIN
     dstCutoff=defDstCutoff
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("Using default Dst cutoff value: ",I0)',dstCutoff
  ENDIF

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  CASE 1 OF
     KEYWORD_SET(use_katus_storm_phases): BEGIN
        
        PRINT,"Using Katus storm phases ..."

        katus = LOAD_KATUS_STORM_PHASES(/COMBINED)

        init_dst_i = MAKE_ARRAY( 50000,/LONG,VALUE=0)
        n_init     = 0

        CASE use_katus_storm_phases OF
           1: BEGIN
              mp_dst_i   = MAKE_ARRAY( 50000,/LONG,VALUE=0)
              rp_dst_i   = MAKE_ARRAY( 50000,/LONG,VALUE=0)
              
              n_mp       = 0
              n_rp       = 0
           END
           2: BEGIN
              earlyMP_dst_i = MAKE_ARRAY( 50000,/LONG,VALUE=0)
              lateMP_dst_i  = MAKE_ARRAY( 50000,/LONG,VALUE=0)
              earlyRP_dst_i = MAKE_ARRAY( 50000,/LONG,VALUE=0)
              lateRP_dst_i  = MAKE_ARRAY( 50000,/LONG,VALUE=0)
              
              n_earlyMP     = 0
              n_earlyRP     = 0
              n_lateMP      = 0
              n_lateRP      = 0
           END
        ENDCASE


        CASE use_katus_storm_phases OF
           1: BEGIN
              ;; FOREACH date,katus.date.utc,ind DO BEGIN
              FOR ind=0,N_ELEMENTS(katus.date.utc)-1 DO BEGIN

                 tmpInit_i = WHERE((dst.time GE katus.init.utc[ind]) AND $
                                   (dst.time LE katus.mp.utc[ind]  ), $
                                   /NULL, $
                                   initCount)

                 tmpMP_i   = WHERE((dst.time GE katus.mp.utc[ind]  ) AND $
                                   (dst.time LE katus.peak.utc[ind]), $
                                   /NULL, $
                                   mpCount)
                 tmpRP_i   = WHERE((dst.time GE katus.peak.utc[ind]) AND $
                                   (dst.time LE katus.rp.utc[ind]  ), $
                                   /NULL, $
                                   rpCount)

                 IF initCount GT 0 THEN BEGIN
                    init_dst_i[n_init:(n_init+initCount-1)] = tmpInit_i
                    n_init  += initCount
                 ENDIF

                 IF mpCount GT 0 THEN BEGIN
                    mp_dst_i[n_mp:(n_mp+mpCount-1)] = tmpMP_i
                    n_mp  += mpCount
                 ENDIF

                 IF rpCount GT 0 THEN BEGIN
                    rp_dst_i[n_rp:(n_rp+rpCount-1)] = tmpRP_i
                    n_rp  += rpCount
                 ENDIF

                 ENDFOR
                 ;; ENDFOREACH

                 init_dst_i = init_dst_i[0:(n_init-1)]
                 mp_dst_i   = mp_dst_i[0:(n_mp-1)]
                 rp_dst_i   = rp_dst_i[0:(n_rp-1)]

                 n_s        = n_init + n_mp + n_rp

                 s_dst_i    = [init_dst_i,mp_dst_i,rp_dst_i]
                 s_dst_i    = s_dst_i[SORT(s_dst_i)]
                 
              END
              2: BEGIN

                 FOREACH date,katus.date,ind DO BEGIN

                    tmpInit_i = WHERE((dst.time GE katus.init.utc[ind]) AND $
                                      (dst.time LE katus.mp.utc[ind]  ), $
                                      /NULL, $
                                      initCount)
                    
                    tmpEarlyMP_i   = WHERE((dst.time GE katus.mp.utc[ind]  ) AND $
                                           (dst.time LE katus.mp.half.utc[ind]), $
                                           /NULL, $
                                           earlyMPCount)
                    tmpEarlyRP_i   = WHERE((dst.time GE katus.peak.utc[ind]) AND $
                                           (dst.time LE katus.rp.half.utc[ind]  ), $
                                           /NULL, $
                                           earlyRPCount)
                    tmpLateMP_i    = WHERE((dst.time GE katus.mp.half.utc[ind]  ) AND $
                                           (dst.time LE katus.peak.utc[ind]), $
                                           /NULL, $
                                           lateMPCount)
                    tmpLateRP_i    = WHERE((dst.time GE katus.rp.half.utc[ind]) AND $
                                           (dst.time LE katus.rp.utc[ind]  ), $
                                           /NULL, $
                                           lateRPCount)

                    IF initCount GT 0 THEN BEGIN
                       init_dst_i[n_init:(n_init+initCount-1)] = tmpInit_i
                       n_init  += initCount
                    ENDIF

                    IF earlyMPCount GT 0 THEN BEGIN
                       earlyMP_dst_i[n_earlyMP:(n_earlyMP+earlyMPCount-1)] = tmpEarlyMP_i
                       n_earlyMP  += earlyMPCount
                    ENDIF

                    IF lateMPCount GT 0 THEN BEGIN
                       lateMP_dst_i[n_lateMP:(n_lateMP+lateMPCount-1)] = tmpLateMP_i
                       n_lateMP  += lateMPCount
                    ENDIF

                    IF earlyRPCount GT 0 THEN BEGIN
                       earlyRP_dst_i[n_earlyRP:(n_earlyRP+earlyRPCount-1)] = tmpEarlyRP_i
                       n_earlyRP  += earlyRPCount
                    ENDIF

                    IF lateRPCount GT 0 THEN BEGIN
                       lateRP_dst_i[n_lateRP:(n_lateRP+lateRPCount-1)] = tmpLateRP_i
                       n_lateRP  += lateRPCount
                    ENDIF

                    ;; ENDFOR
                 ENDFOREACH

                 init_dst_i    = init_dst_i[0:(n_init-1)]
                 earlyMP_dst_i = earlyMP_dst_i[0:(n_earlyMP-1)]
                 lateMP_dst_i  = lateMP_dst_i[0:(n_lateMP-1)]
                 earlyRP_dst_i = earlyRP_dst_i[0:(n_earlyRP-1)]
                 lateRP_dst_i  = lateRP_dst_i[0:(n_lateRP-1)]

                 n_s           = n_init + n_earlyMP + n_lateMP + n_earlyRP + n_lateRP

                 s_dst_i       = [init_dst_i,earlyMP_dst_i,lateMP_dst_i,earlyRP_dst_i,lateRP_dst_i]
                 s_dst_i       = s_dst_i[SORT(s_dst_i)]

                 END
              ENDCASE

              ns_dst_i   = WHERE(dst.dst GT dstCutoff,n_ns)

           END
           KEYWORD_SET(smooth_Dst): BEGIN

              IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='(A0)',"Using smoothed Dst"
              CASE smooth_Dst OF
                 1: BEGIN
                    s_dst_i = WHERE(dst.dst_smoothed_6hr LE dstCutoff,n_s, $
                                    COMPLEMENT=ns_dst_i,NCOMPLEMENT=n_ns)
                    mp_dst_ii = WHERE(dst.dt_dst_sm6hr[s_dst_i] LE 0, $
                                      n_mp, $
                                      COMPLEMENT=rp_dst_ii, $
                                      NCOMPLEMENT=n_rp)
                 END
                 ELSE: BEGIN
                    ;;Let's smooth Dst first, and get the derivative
                    dst_smoothed = SMOOTH(dst.dst,smooth_Dst,/EDGE_TRUNCATE)
                    dt_dst_sm = DERIV(dst_smoothed)

                    ;;NOW let's get storm indices and phase indices
                    s_dst_i = WHERE(dst_smoothed LE dstCutoff,n_s, $
                                    COMPLEMENT=ns_dst_i,NCOMPLEMENT=n_ns)
                    mp_dst_ii = WHERE(dt_dst_sm[s_dst_i] LE 0, $
                                      n_mp, $
                                      COMPLEMENT=rp_dst_ii, $
                                      NCOMPLEMENT=n_rp)

                 END
              ENDCASE
           END
           ELSE: BEGIN
              s_dst_i = WHERE(dst.dst LE dstCutoff, $
                              n_s, $
                              COMPLEMENT=ns_dst_i, $
                              NCOMPLEMENT=n_ns)
              mp_dst_ii = WHERE(dst.dt_dst_sm6hr[s_dst_i] LE 0, $
                                n_mp, $
                                COMPLEMENT=rp_dst_ii, $
                                NCOMPLEMENT=n_rp)
           END
        ENDCASE

        IF ~KEYWORD_SET(use_katus_storm_phases) THEN BEGIN
           mp_dst_i=s_dst_i[mp_dst_ii]
           rp_dst_i=s_dst_i[rp_dst_ii]
        ENDIF
        
        CASE 1 OF
           KEYWORD_SET(use_julDay_not_UTC): BEGIN

              IF KEYWORD_SET(earliest_julDay) THEN BEGIN
                 early_i   = WHERE(dst.julDay GE earliest_julDay)
                 WHERECHECK,early_i
              ENDIF

              IF KEYWORD_SET(latest_julDay) THEN BEGIN
                 late_i    = WHERE(dst.julDay LE latest_julDay)
                 WHERECHECK,late_i

              ENDIF

           END
           ELSE: BEGIN
              IF KEYWORD_SET(earliest_UTC) THEN BEGIN
                 early_i   = WHERE(dst.time GE earliest_UTC)
                 WHERECHECK,early_i

              ENDIF

              IF KEYWORD_SET(latest_UTC) THEN BEGIN
                 late_i    = WHERE(dst.time LE latest_UTC)
                 WHERECHECK,late_i

              ENDIF
           END
        ENDCASE

        IF N_ELEMENTS(early_i) GT 0 THEN BEGIN
           IF KEYWORD_SET(use_katus_storm_phases) THEN BEGIN

              CASE use_katus_storm_phases OF
                 1: BEGIN

                    ns_dst_i   = CGSETINTERSECTION(early_i,ns_dst_i)
                    s_dst_i    = CGSETINTERSECTION(early_i,s_dst_i)
                    init_dst_i = CGSETINTERSECTION(early_i,init_dst_i)
                    mp_dst_i   = CGSETINTERSECTION(early_i,mp_dst_i)
                    rp_dst_i   = CGSETINTERSECTION(early_i,rp_dst_i)

                    IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to early julDay",T30,":",T35,I0)',n_s-N_ELEMENTS(s_dst_i)

                    n_ns      = N_ELEMENTS(ns_dst_i)
                    n_s       = N_ELEMENTS(s_dst_i)
                    n_init    = N_ELEMENTS(init_dst_i)
                    n_mp      = N_ELEMENTS(mp_dst_i)
                    n_rp      = N_ELEMENTS(rp_dst_i)

                 END
                 2: BEGIN

                    ns_dst_i      = CGSETINTERSECTION(early_i,ns_dst_i)
                    s_dst_i       = CGSETINTERSECTION(early_i,s_dst_i)
                    init_dst_i    = CGSETINTERSECTION(early_i,init_dst_i)
                    earlyMP_dst_i = CGSETINTERSECTION(early_i,earlyMP_dst_i)
                    lateMP_dst_i  = CGSETINTERSECTION(early_i,lateMP_dst_i)
                    earlyRP_dst_i = CGSETINTERSECTION(early_i,earlyRP_dst_i)
                    lateRP_dst_i  = CGSETINTERSECTION(early_i,lateRP_dst_i)

                    IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to early julDay",T30,":",T35,I0)',n_s-N_ELEMENTS(s_dst_i)

                    n_ns      = N_ELEMENTS(ns_dst_i)
                    n_s       = N_ELEMENTS(s_dst_i)
                    n_init    = N_ELEMENTS(init_dst_i)
                    n_earlyMP = N_ELEMENTS(earlyMP_dst_i)
                    n_lateMP  = N_ELEMENTS(lateMP_dst_i)
                    n_earlyRP = N_ELEMENTS(earlyRP_dst_i)
                    n_lateRP  = N_ELEMENTS(lateRP_dst_i)

                 END
              ENDCASE

           ENDIF ELSE BEGIN

              s_dst_i   = CGSETINTERSECTION(early_i,s_dst_i)
              ns_dst_i  = CGSETINTERSECTION(early_i,ns_dst_i)
              mp_dst_i  = CGSETINTERSECTION(early_i,mp_dst_i)
              rp_dst_i  = CGSETINTERSECTION(early_i,rp_dst_i)

              IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to early julDay",T30,":",T35,I0)',n_s-N_ELEMENTS(s_dst_i)

              n_s       = N_ELEMENTS(s_dst_i)
              n_ns      = N_ELEMENTS(ns_dst_i)
              n_mp      = N_ELEMENTS(mp_dst_i)
              n_rp      = N_ELEMENTS(rp_dst_i)

           ENDELSE
        ENDIF

        IF N_ELEMENTS(late_i) GT 0 THEN BEGIN

           IF KEYWORD_SET(use_katus_storm_phases) THEN BEGIN

              CASE use_katus_storm_phases OF
                 1: BEGIN

                    ns_dst_i   = CGSETINTERSECTION(late_i,ns_dst_i)
                    s_dst_i    = CGSETINTERSECTION(late_i,s_dst_i)
                    init_dst_i = CGSETINTERSECTION(late_i,init_dst_i)
mp_dst_i   = CGSETINTERSECTION(late_i,mp_dst_i)
              rp_dst_i   = CGSETINTERSECTION(late_i,rp_dst_i)

              IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to latest julDay",T30,":",T35,I0)',n_s-N_ELEMENTS(s_dst_i)

              n_ns      = N_ELEMENTS(ns_dst_i)
              n_s       = N_ELEMENTS(s_dst_i)
              n_init    = N_ELEMENTS(init_dst_i)
              n_mp      = N_ELEMENTS(mp_dst_i)
              n_rp      = N_ELEMENTS(rp_dst_i)

           END
           2: BEGIN

              ns_dst_i      = CGSETINTERSECTION(late_i,ns_dst_i)
              s_dst_i       = CGSETINTERSECTION(late_i,s_dst_i)
              init_dst_i    = CGSETINTERSECTION(late_i,init_dst_i)
              earlyMP_dst_i = CGSETINTERSECTION(late_i,earlyMP_dst_i)
              lateMP_dst_i  = CGSETINTERSECTION(late_i,lateMP_dst_i)
              earlyRP_dst_i = CGSETINTERSECTION(late_i,earlyRP_dst_i)
              lateRP_dst_i  = CGSETINTERSECTION(late_i,lateRP_dst_i)

              IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to latest julDay",T30,":",T35,I0)',n_s-N_ELEMENTS(s_dst_i)

              n_ns      = N_ELEMENTS(ns_dst_i)
              n_s       = N_ELEMENTS(s_dst_i)
              n_init    = N_ELEMENTS(init_dst_i)
              n_earlyMP = N_ELEMENTS(earlyMP_dst_i)
              n_lateMP  = N_ELEMENTS(lateMP_dst_i)
              n_earlyRP = N_ELEMENTS(earlyRP_dst_i)
              n_lateRP  = N_ELEMENTS(lateRP_dst_i)

           END
        ENDCASE

     ENDIF ELSE BEGIN

        s_dst_i   = CGSETINTERSECTION(late_i,s_dst_i)
        ns_dst_i  = CGSETINTERSECTION(late_i,ns_dst_i)
        mp_dst_i  = CGSETINTERSECTION(late_i,mp_dst_i)
        rp_dst_i  = CGSETINTERSECTION(late_i,rp_dst_i)

        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to latest julDay",T30,":",T35,I0)',n_s-N_ELEMENTS(s_dst_i)

        n_s       = N_ELEMENTS(s_dst_i)
        n_ns      = N_ELEMENTS(ns_dst_i)
        n_mp      = N_ELEMENTS(mp_dst_i)
        n_rp      = N_ELEMENTS(rp_dst_i)

     ENDELSE
  ENDIF

  ;;Make sure these all actually found stuff
  IF KEYWORD_SET(use_katus_storm_phases) THEN BEGIN
     CASE use_katus_storm_phases OF
        1: BEGIN
           WHERECHECK,ns_dst_i,s_dst_i,init_dst_i,mp_dst_i,rp_dst_i
        END
        2: BEGIN
           WHERECHECK,ns_dst_i,s_dst_i,init_dst_i,earlyMP_dst_i,lateMP_dst_i,earlyRP_dst_i,lateRP_dst_i
        END
     ENDCASE
  ENDIF ELSE BEGIN
     WHERECHECK,s_dst_i,ns_dst_i,mp_dst_ii,rp_dst_ii
  ENDELSE

  IF ~KEYWORD_SET(quiet) THEN BEGIN
     PRINTF,lun,FORMAT='("**GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS**")'
     IF KEYWORD_SET(earliest_UTC) THEN PRINTF,lun,FORMAT='("Earliest allowed UTC",T30,":",T35,A0)',time_to_str(earliest_UTC)
     IF KEYWORD_SET(latest_UTC)   THEN PRINTF,lun,FORMAT='("Latest allowed UTC",T30,":",T35,A0)',time_to_str(latest_UTC)
     PRINTF,lun,""
     PRINTF,lun,FORMAT='("N nonstorm indices            :",T35,I0)',n_ns
     PRINTF,lun,""
     IF KEYWORD_SET(use_katus_storm_phases) THEN BEGIN
        CASE use_katus_storm_phases OF
           1: BEGIN
              PRINTF,lun,FORMAT='("N storm indices               :",T35,I0)',n_s
              PRINTF,lun,FORMAT='("-->N initial phase indices    :",T35,I0)',n_init
              PRINTF,lun,FORMAT='("-->N main phase indices       :",T35,I0)',n_mp
              PRINTF,lun,FORMAT='("-->N recovery phase indices   :",T35,I0)',n_rp
              PRINTF,lun,""
           END
           2: BEGIN
              PRINTF,lun,FORMAT='("N storm indices                   :",T40,I0)',n_s
              PRINTF,lun,FORMAT='("-->N initial phase indices        :",T40,I0)',n_init
              PRINTF,lun,FORMAT='("-->N early main phase indices     :",T40,I0)',n_earlyMP
              PRINTF,lun,FORMAT='("-->N late main phase indices      :",T40,I0)',n_lateMP
              PRINTF,lun,FORMAT='("-->N early recovery phase indices :",T40,I0)',n_earlyRP
              PRINTF,lun,FORMAT='("-->N late recovery phase indices  :",T40,I0)',n_lateRP
              PRINTF,lun,""
           END
        ENDCASE
     ENDIF ELSE BEGIN
        PRINTF,lun,FORMAT='("N storm indices               :",T35,I0)',n_s
        PRINTF,lun,FORMAT='("-->N main phase indices       :",T35,I0)',n_mp
        PRINTF,lun,FORMAT='("-->N recovery phase indices   :",T35,I0)',n_rp
        PRINTF,lun,""
     ENDELSE
  ENDIF

END
