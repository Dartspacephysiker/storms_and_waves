;2016/03/14 In Figure 4 of our storms paper, there is some hot ion action on the nightside aroun 40 hrs epoch time. Sup with it? This
;journal has some infos.
;The savefile has these variables: tot_alf_t,tot_alf_y,tot_plot_i,max_ii,despun
;max_ii was obtained by doing these=get_n_maxima_in_array(tot_alf_y,n=20,out_i=max_ii)
;
;The conclusion is that there was crazy outflow happening at t = 40 hrs during orbits 8773 and 8774

PRO JOURNAL__20160314__EXTREME_ION_OUTFLOW__NIGHTSIDE__EXPLORE

  inFile             = 'journal__20160314__extreme_ion_outflow__nightside__inds_and_values_from_SEA_w_linear_totalvar.sav'

  RESTORE,inFile

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=0

  PRINT,maximus.orbit[tot_plot_i[max_ii]]
    ;; 8774    8813    8816    8813    8813    8773    8813    8814    8814    8813
    ;; 8774    8774    8774    8773    8813    8740    8813    8813    2985   13110

  ;;Sort for awesomest
  awesome_iii = SORT(maximus.orbit[tot_plot_i[max_ii]])
  max_ii      = max_ii[awesome_iii]


  mt                 = TAG_NAMES(maximus)
  PRINT,FORMAT='("ind",T9,"TIME",T35,"ORBIT",T45,"OUTFLOW",T57,"EPOCH TIME")'
  FOR i=0,N_ELEMENTS(max_ii)-1 DO BEGIN
     iTmp            = tot_plot_i[max_ii[i]]
     PRINT,FORMAT='(I0,T9,A0,T35,I0,T45,G10.3,T57,F10.3)',iTmp,maximus.time[iTmp],maximus.orbit[iTmp],maximus.integ_ion_flux_up[iTmp],tot_alf_t[max_ii[i]]
  ENDFOR

END