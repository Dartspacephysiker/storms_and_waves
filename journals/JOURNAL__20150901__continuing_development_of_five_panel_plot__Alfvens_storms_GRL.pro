PRO JOURNAL__20150901__continuing_development_of_five_panel_plot__Alfvens_storms_GRL

  load_maximus_and_cdbtime,maximus,cdbtime
  
  good_i=get_chaston_ind(maximus,'OMNI',-1,CDBTIME=cdbtime,/BOTH_HEMIS)
  good_8277_i = cgsetintersection(good_i,where(maximus.orbit EQ 8277))
  ;;good events at 02:48:{ 05.395, 08.489, 22.067, 22.474, 24.153, 26.661 }
  tStartStr='1998-09-25/02:48:00'
  tEndStr='1998-09-25/02:48:30'
  
  ;do the plots for orb 8277, but restrict to the times above
  JOURNAL__20150831__five_panel_from_scratch_w_help_from_as5__Alfvens_storms_GRL,TSTARTSTR=tStartStr,TENDSTR=tEndStr

END