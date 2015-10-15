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
PRO GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst,STORM_DST_I=s_dst_i,NONSTORM_DST_I=ns_dst_i,MAINPHASE_DST_I=mp_dst_i,RECOVERYPHASE_DST_I=rp_dst_i, $
   N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  s_dst_i = WHERE(dst.dst LT -20,n_s,COMPLEMENT=ns_dst_i,NCOMPLEMENT=n_ns)
  mp_dst_ii = WHERE(dst.dt_dst_sm6hr[s_dst_i] LE 0,n_mp,COMPLEMENT=rp_dst_ii,NCOMPLEMENT=n_rp)

  ;;Make sure these all actually found stuff
  WHERECHECK,s_dst_i,ns_dst_i,mp_dst_ii,rp_dst_ii

  mp_dst_i=s_dst_i[mp_dst_ii]
  rp_dst_i=s_dst_i[rp_dst_ii]
  
  PRINTF,lun,FORMAT='("**GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS**")'
  PRINTF,lun,FORMAT='("N nonstorm indices            :",T35,I0)',n_ns
  PRINTF,lun,""
  PRINTF,lun,FORMAT='("N storm indices               :",T35,I0)',n_s
  PRINTF,lun,FORMAT='("-->N main phase indices       :",T35,I0)',n_mp
  PRINTF,lun,FORMAT='("-->N recovery phase indices   :",T35,I0)',n_rp
  PRINTF,lun,""
  

END