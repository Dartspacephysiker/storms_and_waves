PRO JOURNAL__20151026__FIG1__FOUR_STORMS_WITH_GOOD_DATA__ALFSTORM2

  load_noaa_and_brett_dbs_and_qi,stormstruct,ssc1,ssc2,qi

  STACKPLOTS_STORMS_ALFVENDBQUANTITIES_OVERLAID,stormstruct.time, $
     MAXIND=6, $
     /JUST_ONE_LABEL, $
     /OVERPLOT_ALFVENDBQUANTITY, $
     /SHOW_DATA_AVAILABILITY


END