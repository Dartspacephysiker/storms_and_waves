;what are the raw probs, people?
;
;Here is the output as of Tues afternoon, 2016/01/19
;****************************************************
;Day or night  Num (min)      Denom (min)    Probability
;*****NON-STORM*****
;N Elements TOT  : 36303
;N Elements DAY  : 29391
;N Elements NIGHT: 6912
;Day           100.42         2799.9         0.03587
;Night         29.238         3794.5         0.00771
;Day/night ratio: 4.65469
;
;*****STORM*****
;N Elements TOT  : 30287
;N Elements DAY  : 23062
;N Elements NIGHT: 7225
;Day           82.894         1221.4         0.06787
;Night         30.735         1111.2         0.02766
;Day/night ratio: 2.45376
;
;*****MAIN_PHASE*****
;N Elements TOT  : 17569
;N Elements DAY  : 12701
;N Elements NIGHT: 4868
;Day           44.062         472.96         0.09316
;Night         20.512         484.78         0.04231
;Day/night ratio: 2.20184
;
;*****RECOVERY_PHASE*****
;N Elements TOT  : 12718
;N Elements DAY  : 10361
;N Elements NIGHT: 2357
;Day           38.832         748.45         0.05188
;Night         10.224         626.46         0.01632
;Day/night ratio: 3.17917
;
;*****TOTAL*****
;N Elements TOT  : 66590
;N Elements DAY  : 52453
;N Elements NIGHT: 14137
;Day           183.32         4021.3         0.04559
;Night         59.974         4905.8         0.01223
;Day/night ratio: 3.72887
;
PRO JOURNAL__20160119__CALCULATE_RAW_DAYSIDE_NIGHTSIDE_PROBABILITIES__SOUTH

  indDir                    = '/home/spencerh/Research/Cusp/storms_Alfvens/journals/20160119--indices_for_maximus_and_fastlocdb_during_stormphases--south/'
                            
  ns_f                      = indDir + 'plot_i_ns--south--20160119.sav'
  mp_f                      = indDir + 'plot_i_mp--south--20160119.sav'
  rp_f                      = indDir + 'plot_i_rp--south--20160119.sav'
                            
  ns_fl_f                   = indDir + 'fastlocinterped_i_ns--south--20160119.sav'
  mp_fl_f                   = indDir + 'fastlocinterped_i_mp--south--20160119.sav'
  rp_fl_f                   = indDir + 'fastlocinterped_i_rp--south--20160119.sav'

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
     PRINT,'N Elements TOT  : ' + STRCOMPRESS(N_ELEMENTS(tmp_i),/REMOVE_ALL)
     PRINT,'N Elements DAY  : ' + STRCOMPRESS(N_ELEMENTS(day_plot_ii),/REMOVE_ALL)
     PRINT,'N Elements NIGHT: ' + STRCOMPRESS(N_ELEMENTS(night_plot_ii),/REMOVE_ALL)
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