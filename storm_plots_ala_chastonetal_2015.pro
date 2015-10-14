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
; CALLING SEQUENCE:       Well, just go ahead and call it!
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
PRO STORM_PLOTS_ALA_CHASTONETAL_2015

  LOAD_DST_AE_DBS,dst,ae

  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_PERIODS,dst,STORM_I=s_i,NONSTORM_I=ns_i,MAINPHASE_I=mp_i,RECOVERYPHASE_I=rp_i, $
     N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp

  GET_STREAKS,mp_i,START_I=start_i,STOP_I=stop_i,SINGLE_I=single_i
  
  GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES ;;JUST TEST ER OUT!
  

END