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
PRO GET_LOW_AND_HIGH_AE_PERIODS, $
   ae, $
   AECUTOFF=AeCutoff, $
   EARLIEST_UTC=earliest_UTC, $
   LATEST_UTC=latest_UTC, $
   USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
   EARLIEST_JULDAY=earliest_julDay, $
   LATEST_JULDAY=latest_julDay, $
   USE_AU=use_au, $
   USE_AL=use_al, $
   USE_AO=use_ao, $
   ;; STORM_AE_I=s_ae_i, $
   ;; NONSTORM_AE_I=ns_ae_i, $
   ;; MAINPHASE_AE_I=mp_ae_i, $
   ;; RECOVERYPHASE_AE_I=rp_ae_i, $
   ;; N_STORM=n_s, $
   ;; N_NONSTORM=n_ns, $
   ;; N_MAINPHASE=n_mp, $
   ;; N_RECOVERYPHASE=n_rp, $
   HIGH_AE_I=high_ae_i, $
   LOW_AE_I=low_ae_i, $
   N_HIGH=n_high, $
   N_LOW=n_low, $
   OUT_NAME=navn, $
   QUIET=quiet, $
   LUN=lun
  
  defAeCutoff = 115
  defAECutoff = MEDIAN(ae.ae)
  defAUCutoff = MEDIAN(ae.au)
  defALCutoff = MEDIAN(ae.al)
  defAOCutoff = MEDIAN(ae.ao)


  CASE 1 OF
     KEYWORD_SET(use_au): BEGIN
        dex   = ae.au
        smDex = ae.dt_au_sm6hr
        navn  = 'AU'
        defCutoff = defAUCutoff
     END
     KEYWORD_SET(use_al): BEGIN
        dex   = ae.al
        smDex = ae.dt_al_sm6hr
        navn  = 'AL'
        defCutoff = defALCutoff
     END
     KEYWORD_SET(use_ao): BEGIN
        dex   = ae.ao
        smDex = ae.dt_ao_sm6hr
        navn  = 'AO'
        defCutoff = defAOCutoff
     END
     ELSE: BEGIN
        dex   = ae.ae
        smDex = ae.dt_ae_sm6hr
        navn  = 'AE'
        defCutoff = defAECutoff
     END
  ENDCASE

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  IF N_ELEMENTS(aeCutoff) EQ 0 THEN BEGIN
     aeCutoff  = defCutoff
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("Using default ",A0," cutoff value: ",I0)',navn,aeCutoff
  ENDIF

  low_ae_i     = WHERE(dex LE aeCutoff,n_low,COMPLEMENT=high_ae_i,NCOMPLEMENT=n_high)

  CASE 1 OF
     KEYWORD_SET(use_julDay_not_UTC): BEGIN
        IF KEYWORD_SET(earliest_julDay) THEN BEGIN
           early_i   = WHERE(ae.julDay GE earliest_julDay)
           WHERECHECK,early_i

           low_ae_i   = CGSETINTERSECTION(early_i,low_ae_i)
           high_ae_i  = CGSETINTERSECTION(early_i,high_ae_i)

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to early julDay",T30,":",T35,I0)',n_low-N_ELEMENTS(low_ae_i)

           n_low       = N_ELEMENTS(low_ae_i)
           n_high      = N_ELEMENTS(high_ae_i)
        ENDIF

        IF KEYWORD_SET(latest_julDay) THEN BEGIN
           late_i    = WHERE(ae.julDay LE latest_julDay)
           WHERECHECK,late_i

           low_ae_i   = CGSETINTERSECTION(late_i,low_ae_i)
           high_ae_i  = CGSETINTERSECTION(late_i,high_ae_i)

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to latest julDay",T30,":",T35,I0)',n_low-N_ELEMENTS(low_ae_i)

           n_low       = N_ELEMENTS(low_ae_i)
           n_high      = N_ELEMENTS(high_ae_i)
        ENDIF
     END
     ELSE: BEGIN
        IF KEYWORD_SET(earliest_UTC) THEN BEGIN
           early_i   = WHERE(ae.time GE earliest_UTC)
           WHERECHECK,early_i

           low_ae_i   = CGSETINTERSECTION(early_i,low_ae_i)
           high_ae_i  = CGSETINTERSECTION(early_i,high_ae_i)

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to early UTC",T30,":",T35,I0)',n_low-N_ELEMENTS(low_ae_i)

           n_low       = N_ELEMENTS(low_ae_i)
           n_high      = N_ELEMENTS(high_ae_i)
        ENDIF

        IF KEYWORD_SET(latest_UTC) THEN BEGIN
           late_i    = WHERE(ae.time LE latest_UTC)
           WHERECHECK,late_i

           low_ae_i   = CGSETINTERSECTION(late_i,low_ae_i)
           high_ae_i  = CGSETINTERSECTION(late_i,high_ae_i)

           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,FORMAT='("N lost to latest UTC",T30,":",T35,I0)',n_low-N_ELEMENTS(low_ae_i)

           n_low       = N_ELEMENTS(low_ae_i)
           n_high      = N_ELEMENTS(high_ae_i)
        ENDIF
     END
  ENDCASE


  mp_ae_ii = WHERE(smDex[low_ae_i] LE 0,n_mp,COMPLEMENT=rp_ae_ii,NCOMPLEMENT=n_rp)

  ;;Make sure these all actually found stuff
  WHERECHECK,low_ae_i,high_ae_i,mp_ae_ii,rp_ae_ii

  mp_ae_i=low_ae_i[mp_ae_ii]
  rp_ae_i=low_ae_i[rp_ae_ii]
  
  IF ~KEYWORD_SET(quiet) THEN BEGIN
     PRINTF,lun,FORMAT='("**GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS**")'
     IF KEYWORD_SET(earliest_UTC) THEN PRINTF,lun,FORMAT='("Earliest allowed UTC",T30,":",T35,A0)',time_to_str(earliest_UTC)
     IF KEYWORD_SET(latest_UTC)   THEN PRINTF,lun,FORMAT='("Latest allowed UTC",T30,":",T35,A0)',time_to_str(latest_UTC)
     PRINTF,lun,""
     PRINTF,lun,FORMAT='("N high ",A0," indices             :",T35,I0)',navn,n_high
     PRINTF,lun,""
     PRINTF,lun,FORMAT='("N low ",A0," indices              :",T35,I0)',navn,n_low
     ;; PRINTF,lun,FORMAT='("-->N main phase indices       :",T35,I0)',n_mp
     ;; PRINTF,lun,FORMAT='("-->N recovery phase indices   :",T35,I0)',n_rp
     PRINTF,lun,""
  ENDIF

END