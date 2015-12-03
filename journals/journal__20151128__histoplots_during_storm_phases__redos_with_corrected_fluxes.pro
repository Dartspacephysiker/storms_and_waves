;;2015/11/30
;;Gotta redo 'em because I've made some further corrections so that 
;;>electrons flowing earthward are positive
;;>ions flowing outward are positive
;;>see correct_alfvendb_fluxes.pro for details

;2015/11/28
;Here is what I've come up with after a detailed look at the fluxes calculated in
;Alfven Stats 5. See 20151127--why_flux_is_so_weird_in_Alfven_DB.txt for lots of details.

;*SUMMARY FROM 20151127--why_flux_is_so_weird_in_Alfven_DB.txt*
;*Electrons
;>07-ESA_CURRENT                : Flip sign in N Hemi
;>08-ELEC_ENERGY_FLUX           : No correction, done in AS5
;>09-INTEG_ELEC_ENERGY_FLUX     : No correction, done in AS5
;>10-EFLUX_LOSSCONE_INTEG       : Flip sign in S Hemi
;>11-TOTAL_EFLUX_INTEG          : Flip sign in S Hemi
;>12-MAX_CHARE_LOSSCONE         : How to handle? Already all positive
;>13-MAX_CHARE_TOTAL            : How to handle? I believe there are sign issues
;
;*Ions
;>14-ION_ENERGY_FLUX            : Absolute value of energy flux, so already all positive
;>15-ION_FLUX                   : Flip sign in N Hemi
;>16-ION_FLUX_UP                : How to handle? Already all positive
;>17-INTEG_ION_FLUX             : Flip sign in S Hemi
;>18-INTEG_ION_FLUX_UP          : Flip sign in S Hemi
;>19-CHAR_ION_ENERGY            : How to handle? Division of two quantities where hemi isn't accounted for

;So we'll redo 07,10,11,15,17,18
PRO JOURNAL__20151128__HISTOPLOTS_DURING_STORM_PHASES__REDOS_WITH_CORRECTED_FLUXES

  ;;electrons
  journal__20151128__histoplots_of_07_esa_current_during_stormphases
  journal__20151124__histoplots_of_10_eflux_losscone_integ_during_stormphases
  journal__20151124__histoplots_of_11_total_eflux_integ_during_stormphases
  
  ;;ions
  journal__20151124__histoplots_of_15_ion_flux_during_stormphases
  journal__20151124__histoplots_of_17_integ_ion_flux_during_stormphases
  journal__20151124__histoplots_of_18_integ_ion_flux_up_during_stormphases


END