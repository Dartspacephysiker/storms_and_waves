PRO JOURNAL__20160116__PLOTS_OF_ONE_OVER_WIDTH_TIME_FOR_STORMPHASES


  indDir  = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/journals/20160109--indices_for_maximus_and_fastlocdb_during_stormphases/'
  outDir  = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/plots/20160116--histos_of_one_over_width_time_for_stormphases'
  outPref = '20160116--one_over_width_time_histo--'

  ;;Load all the inds plus DB
  load_maximus_and_cdbtime,maximus
  restore,indDir + 'plot_i_ns--north--20160109.sav'
  restore,indDir + 'plot_i_mp--north--20160109.sav'
  restore,indDir + 'plot_i_rp--north--20160109.sav'

  ;;see?
  cghistoplot,1/maximus.width_time[plot_i_ns]/2,maxinput=20,binsize=0.2
  cghistoplot,1/maximus.width_time[plot_i_mp]/2,maxinput=20,binsize=0.2
  cghistoplot,1/maximus.width_time[plot_i_rp]/2,maxinput=20,binsize=0.2
  cghistoplot,1/maximus.width_time[where(ABS(maximus.mag_current) GT  10)] /2,maxinput=20,binsize=0.2

  ;;output 
  cghistoplot,1/maximus.width_time[plot_i_ns]/2,maxinput=20,binsize=0.2,output=outPref + 'non-storm.pdf'
  cghistoplot,1/maximus.width_time[plot_i_mp]/2,maxinput=20,binsize=0.2,output=outPref + 'main_phase.pdf'
  cghistoplot,1/maximus.width_time[plot_i_rp]/2,maxinput=20,binsize=0.2,output=outPref + 'recovery_phase.pdf'
  cghistoplot,1/maximus.width_time[where(ABS(maximus.mag_current) GE  10)] /2,maxinput=20,binsize=0.2,output=outPref + 'ABScurrent_GE_10.pdf'

END