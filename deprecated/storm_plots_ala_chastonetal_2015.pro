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

  ;Get all the storm indices. This takes stock of good Alfven DB inds, so the results returned from this pro should be clean.
  GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES,NONSTORM_I=ns_i,MAINPHASE_I=mp_i,RECOVERYPHASE_I=rp_i, $
     STORM_DST_I=s_dst_i,NONSTORM_DST_I=ns_dst_i,MAINPHASE_DST_I=mp_dst_i,RECOVERYPHASE_DST_I=rp_dst_i, $
     N_STORM=n_s,N_NONSTORM=n_ns,N_MAINPHASE=n_mp,N_RECOVERYPHASE=n_rp

  ;;Now histogram these little fellers, I guess?
  
  
END