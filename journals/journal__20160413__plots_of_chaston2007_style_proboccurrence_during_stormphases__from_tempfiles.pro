;;2016/04/13 Now we can calculate probOccurrence à la Chaston et al. [2007]
PRO JOURNAL__20160413__PLOTS_OF_CHASTON2007_STYLE_PROBOCCURRENCE_DURING_STORMPHASES__FROM_TEMPFILES

  combine_stormphase_plots = 1
  save_combined_window     = 1
  combined_to_buffer       = 1


  tempDir   = '/SPENCEdata/Research/Cusp/ACE_FAST/temp/'
  
  tempFiles = ['polarplots_Apr_13_16--nonstorm--Dstcutoff_-20--NORTH--logAvg--maskMin10.dat', $
               'polarplots_Apr_13_16--mainphase--Dstcutoff_-20--NORTH--logAvg--maskMin10.dat', $
               'polarplots_Apr_13_16--recoveryphase--Dstcutoff_-20--NORTH--logAvg--maskMin10.dat']

  quants_to_plot         = 0
  quants_with_new_limits = 0
  new_limits             = [0,0.52]

  no_colorbar = [1,0,1]

  TILE_STORMPHASE_PLOTS_FROM_TEMPFILES,tempFiles, $
                                       TEMPDIR=tempDir, $
                                       COMBINE_STORMPHASE_PLOTS=combine_stormphase_plots, $
                                       SAVE_COMBINED_WINDOW=save_combined_window, $
                                       COMBINED_TO_BUFFER=combined_to_buffer, $
                                       QUANTS_TO_PLOT=quants_to_plot, $
                                       NEW_LIMITS=new_limits, $
                                       NO_COLORBAR=no_colorbar




END