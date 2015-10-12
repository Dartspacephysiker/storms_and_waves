;21:28 Saturday, 2015/08/22
;"Entries of confusion..."

PRO JOURNAL__20150822__generate_a_bunch_of_OMNI_plots_for_four_1998_storms__Alfvens_storms_GRL

  ;for_finding_badvals
  load_omni_db,sw_data

  plot_omni_quantity_during_four_1998_storms__alfvens_storms_grl,omni_quantity='FLOW_SPEED',/OUTPUT_PLOTS

  plot_omni_quantity_during_four_1998_storms__alfvens_storms_grl,omni_quantity='PRESSURE',/OUTPUT_PLOTS
  plot_omni_quantity_during_four_1998_storms__alfvens_storms_grl,omni_quantity='BETA',/OUTPUT_PLOTS,/LOGPLOTS
  plot_omni_quantity_during_four_1998_storms__alfvens_storms_grl,omni_quantity='AE_INDEX',/OUTPUT_PLOTS
  plot_omni_quantity_during_four_1998_storms__alfvens_storms_grl,omni_quantity='PROTON_DENSITY',/OUTPUT_PLOTS,/LOGPLOTS,/USE_DATA_MINMAX
  plot_omni_quantity_during_four_1998_storms__alfvens_storms_grl,omni_quantity='MACH_NUM',/OUTPUT_PLOTS,/USE_DATA_MINMAX
  plot_omni_quantity_during_four_1998_storms__alfvens_storms_grl,omni_quantity='PC_N_INDEX',/OUTPUT_PLOTS
  plot_omni_quantity_during_four_1998_storms__alfvens_storms_grl,omni_quantity='T',/OUTPUT_PLOTS,/USE_DATA_MINMAX

END