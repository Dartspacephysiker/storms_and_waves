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
   STORM_DST_I=s_dst_i, $
   NONSTORM_DST_I=ns_dst_i, $
   MAINPHASE_DST_I=mp_dst_i, $
   RECOVERYPHASE_DST_I=rp_dst_i, $
   N_STORM=n_s, $
   N_NONSTORM=n_ns, $
   N_MAINPHASE=n_mp, $
   N_RECOVERYPHASE=n_rp, $
   QUIET=quiet, $
   LUN=lun
  
  defDstCutoff = -20

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  IF N_ELEMENTS(dstCutoff) EQ 0 THEN BEGIN
     dstCutoff=defDstCutoff
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("Using default Dst cutoff value: ",I0)',dstCutoff
  ENDIF

  CASE 1 OF
     KEYWORD_SET(smooth_Dst): BEGIN
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='(A0)',"Using smoothed Dst"
        s_dst_i = WHERE(dst.dst_smoothed_6hr LE dstCutoff,n_s,COMPLEMENT=ns_dst_i,NCOMPLEMENT=n_ns)
     END
     ELSE: BEGIN
        s_dst_i = WHERE(dst.dst LE dstCutoff,n_s,COMPLEMENT=ns_dst_i,NCOMPLEMENT=n_ns)
     END
  ENDCASE

  CASE 1 OF
     KEYWORD_SET(use_julDay_not_UTC): BEGIN
        IF KEYWORD_SET(earliest_julDay) THEN BEGIN
           early_i   = WHERE(dst.julDay GE earliest_julDay)
           WHERECHECK,early_i

           s_dst_i   = CGSETINTERSECTION(early_i,s_dst_i)
           ns_dst_i  = CGSETINTERSECTION(early_i,ns_dst_i)

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to early julDay",T30,":",T35,I0)',n_s-N_ELEMENTS(s_dst_i)

           n_s       = N_ELEMENTS(s_dst_i)
           n_ns      = N_ELEMENTS(ns_dst_i)
        ENDIF

        IF KEYWORD_SET(latest_julDay) THEN BEGIN
           late_i    = WHERE(dst.julDay LE latest_julDay)
           WHERECHECK,late_i

           s_dst_i   = CGSETINTERSECTION(late_i,s_dst_i)
           ns_dst_i  = CGSETINTERSECTION(late_i,ns_dst_i)

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to latest julDay",T30,":",T35,I0)',n_s-N_ELEMENTS(s_dst_i)

           n_s       = N_ELEMENTS(s_dst_i)
           n_ns      = N_ELEMENTS(ns_dst_i)
        ENDIF
     END
     ELSE: BEGIN
        IF KEYWORD_SET(earliest_UTC) THEN BEGIN
           early_i   = WHERE(dst.time GE earliest_UTC)
           WHERECHECK,early_i

           s_dst_i   = CGSETINTERSECTION(early_i,s_dst_i)
           ns_dst_i  = CGSETINTERSECTION(early_i,ns_dst_i)

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to early UTC",T30,":",T35,I0)',n_s-N_ELEMENTS(s_dst_i)

           n_s       = N_ELEMENTS(s_dst_i)
           n_ns      = N_ELEMENTS(ns_dst_i)
        ENDIF

        IF KEYWORD_SET(latest_UTC) THEN BEGIN
           late_i    = WHERE(dst.time LE latest_UTC)
           WHERECHECK,late_i

           s_dst_i   = CGSETINTERSECTION(late_i,s_dst_i)
           ns_dst_i  = CGSETINTERSECTION(late_i,ns_dst_i)

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to latest UTC",T30,":",T35,I0)',n_s-N_ELEMENTS(s_dst_i)

           n_s       = N_ELEMENTS(s_dst_i)
           n_ns      = N_ELEMENTS(ns_dst_i)
        ENDIF
     END
  ENDCASE


  mp_dst_ii = WHERE(dst.dt_dst_sm6hr[s_dst_i] LE 0,n_mp,COMPLEMENT=rp_dst_ii,NCOMPLEMENT=n_rp)

  ;;Make sure these all actually found stuff
  WHERECHECK,s_dst_i,ns_dst_i,mp_dst_ii,rp_dst_ii

  mp_dst_i=s_dst_i[mp_dst_ii]
  rp_dst_i=s_dst_i[rp_dst_ii]
  
  IF ~KEYWORD_SET(quiet) THEN BEGIN
     PRINTF,lun,FORMAT='("**GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS**")'
     IF KEYWORD_SET(earliest_UTC) THEN PRINTF,lun,FORMAT='("Earliest allowed UTC",T30,":",T35,A0)',time_to_str(earliest_UTC)
     IF KEYWORD_SET(latest_UTC)   THEN PRINTF,lun,FORMAT='("Latest allowed UTC",T30,":",T35,A0)',time_to_str(latest_UTC)
     PRINTF,lun,""
     PRINTF,lun,FORMAT='("N nonstorm indices            :",T35,I0)',n_ns
     PRINTF,lun,""
     PRINTF,lun,FORMAT='("N storm indices               :",T35,I0)',n_s
     PRINTF,lun,FORMAT='("-->N main phase indices       :",T35,I0)',n_mp
     PRINTF,lun,FORMAT='("-->N recovery phase indices   :",T35,I0)',n_rp
     PRINTF,lun,""
  ENDIF

END