;2016/03/14 SOLVED
; It turns out this had to do with width_time. By eliminating events with width_t GT 2.5 I junked the big nonsense outflow events
;2016/03/14 There are a few instances in the measurements of integrated upward ion flux during non-storm and storm main phase where the
;values seem totally preposterous--in this case, 1.54656e19. It is the single largest value within the accepted ('good_i') values, and
;it occurs during orbit 13001
;I saved a file called 'indices_for_huge_integ_ion_flux_up_vals--nonstorm--20160314.pro' with max_i, the indices of the top 20 largest
;non-storm values of integ. upward ion flux for the DESPUN database. Check it out.
;
;I've adjusted the width_time stuff in alfven_db_cleaner to align with what Chris describes in the paper.
PRO JOURNAL__20160314__SUP_WITH_HUGE_INTEG_ION_FLUXES__WRECKING_GROSS_RATES

  RESTORE,'indices_for_huge_integ_ion_flux_up_vals--nonstorm--20160314.pro'

  mt=tag_names(maximus)
  FOR i=0,N_ELEMENTS(mt)-3 DO PRINT,FORMAT='(I3,T5,A0,T35,4(G15.5,TR5))',i,mt[i],(maximus.(i))[max_i[0:3]]

END