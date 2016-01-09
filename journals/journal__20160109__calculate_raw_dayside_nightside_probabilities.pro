;what are the raw probs, people?
;
;Here is the output as of Saturday night, 2016/01/09
;****************************************************
;DAY OR NIGHT  NUM (min)      DENOM (min)    PROBABILITY
;*****NON-STORM*****
;Day           264.64         7651.2         0.03459
;Night         77.437         8112.9         0.00954
;Day/night ratio: 3.62372
;
;*****STORM*****
;Day           167.83         2294.8         0.07313
;Night         64.37          2748.1         0.02342
;Day/night ratio: 3.12230
;
;*****MAIN_PHASE*****
;Day           85.496         896.35         0.09538
;Night         39.683         1093.8         0.03628
;Day/night ratio: 2.62904
;
;*****RECOVERY_PHASE*****
;Day           82.335         1398.5         0.05887
;Night         24.687         1654.3         0.01492
;Day/night ratio: 3.94533
;
;*****TOTAL*****
;Day           432.47         9946           0.04348
;Night         141.81         10861          0.01306
;Day/night ratio: 3.33028
;

PRO JOURNAL__20160109__CALCULATE_RAW_DAYSIDE_NIGHTSIDE_PROBABILITIES

  indDir                    = '/home/spencerh/Research/Cusp/storms_Alfvens/journals/20160109--indices_for_maximus_and_fastlocdb_during_stormphases/'
                            
  ns_f                      = indDir + 'plot_i_ns--north--20160109.sav'
  mp_f                      = indDir + 'plot_i_mp--north--20160109.sav'
  rp_f                      = indDir + 'plot_i_rp--north--20160109.sav'
                            
  ns_fl_f                   = indDir + 'fastlocinterped_i_ns--north--20160109.sav'
  mp_fl_f                   = indDir + 'fastlocinterped_i_mp--north--20160109.sav'
  rp_fl_f                   = indDir + 'fastlocinterped_i_rp--north--20160109.sav'

  restore,ns_f
  restore,mp_f
  restore,rp_f

  restore,ns_fl_f
  restore,mp_fl_f
  restore,rp_fl_f

  ;;get the dbs
  load_maximus_and_cdbtime,maximus
  load_fastloc_and_fastloc_times,fastloc,fastloc_times,fastloc_delta_t

  ;;get storm inds
  plot_i_s                  = [plot_i_mp,plot_i_rp]
  plot_i_s                  = plot_i_s[SORT(plot_i_s)] ;cause I'm anal

  fastlocinterped_i_s       = [fastlocinterped_i_mp,fastlocinterped_i_rp]
  fastlocinterped_i_s       = fastlocinterped_i_s[SORT(fastlocinterped_i_s)]

  ;;names, orders
  names                     = ['non-storm','storm','main_phase','recovery_phase','total']

  ;;make lists
  plot_i_list               = LIST(plot_i_ns)
  plot_i_list.add,plot_i_s
  plot_i_list.add,plot_i_mp
  plot_i_list.add,plot_i_rp
  plot_i_list.add,[plot_i_ns,plot_i_mp,plot_i_rp]



  fastLocInterped_i_list    = LIST(fastLocInterped_i_ns)
  fastLocInterped_i_list.add,fastLocInterped_i_s
  fastLocInterped_i_list.add,fastLocInterped_i_mp
  fastLocInterped_i_list.add,fastLocInterped_i_rp
  fastLocInterped_i_list.add,[fastLocInterped_i_ns,fastLocInterped_i_mp,fastLocInterped_i_rp]

  nPhases                   = N_ELEMENTS(plot_i_list)

  numerator_list            = LIST(!NULL)
  denom_list                = LIST(!NULL)
  prob_list                 = LIST(!NULL)
  ratio_list                = LIST(!NULL)

  PRINT,FORMAT='(A0,T15,"Num (min)",T30,"Denom (min)",T45,"Probability")',"Day or night"
  FOR i=0,nPhases-1 DO BEGIN
     PRINT,'*****' + STRUPCASE(names[i]) + '*****'         ;who are you?

     ;;NUMERATOR
     tmp_i                  = plot_i_list[i]
     day_plot_ii            = WHERE(maximus.mlt[tmp_i] GT 6.0 AND maximus.mlt[tmp_i] LE 18.0)
     night_plot_ii          = WHERE(maximus.mlt[tmp_i] GT 18.0 OR maximus.mlt[tmp_i] LE 6.0)

     numerator_day          = TOTAL(maximus.width_time[tmp_i[day_plot_ii]])
     numerator_night        = TOTAL(maximus.width_time[tmp_i[night_plot_ii]])
     numerator_list.add,      [numerator_day,numerator_night]

     ;;DENOMINATOR
     tmp_fl_i               = fastLocInterped_i_list[i]
     day_fstlc_ii           = WHERE(fastLoc.mlt[tmp_fl_i] GT 6.0 AND fastLoc.mlt[tmp_fl_i] LE 18.0)
     night_fstlc_ii         = WHERE(fastLoc.mlt[tmp_fl_i] GT 18.0 OR fastLoc.mlt[tmp_fl_i] LE 6.0)

     denom_day              = TOTAL(fastLoc_delta_t[tmp_fl_i[day_fstlc_ii]])
     denom_night            = TOTAL(fastLoc_delta_t[tmp_fl_i[night_fstlc_ii]])
     denom_list.add,          [denom_day,denom_night]

     ;;PROBABILITIES
     prob_day               = numerator_day/denom_day
     prob_night             = numerator_night/denom_night
     prob_list.add,           [prob_day,prob_night]

     ;;DAY/NIGHT RATIO
     ratio                  = prob_day/prob_night
     ratio_list.add,          ratio

     ;;PRINT THEM TO DEATH
     PRINT,FORMAT='(A0,T15,G0.5,T30,G0.5,T45,D0.5)','Day',numerator_day/60.,denom_day/60.,prob_day
     PRINT,FORMAT='(A0,T15,G0.5,T30,G0.5,T45,D0.5)','Night',numerator_night/60.,denom_night/60.,prob_night
     PRINT,'Day/night ratio: ' + STRCOMPRESS(ratio,/REMOVE_ALL)
     PRINT,''

  ENDFOR

  numerator_list.remove,0
  denom_list.remove,0
  prob_list.remove,0
  ratio_list.remove,0

END