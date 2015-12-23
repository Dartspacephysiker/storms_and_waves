;2015/12/23 Detailed investigations below the PRO.
;NOTE: All storms are indexed from zero, and because storm #15 gets removed by
;        the REMOVE_DUPES keyword, I have to add one to every storm index above 15 in the
;        the list be
PRO JOURNAL__20151223__SOME_STORMS_SHOULD_BE_REMOVED_FROM_SEA

  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,DBDir=DBDir,DB_BRETT=DB_Brett,DB_NOAA=DB_NOAA,INDS_FILE=inds_file

  ;;these qi structs get restored with the inds file
  q1_st=qi[0].list_i[0]
  q1_1=qi[1].list_i[0]
  
  ;;Of the storms in the foregoing loaded list, these storms seem to be the biggest jerks:
  ;;#22--friggin triple phase!
  ;;#39--way bad double phase
  ;;#40--way bad double phase

  ;;Less offensive:
  ;;#14--way bad at tail end
  ;;#8
  ;;#20

  ;;Junk 'em
  new_i = [INDGEN(22),INDGEN(38-23+1)+23]
  q1_st=q1_st[new_i]

  q1_utc=conv_julday_to_utc(ssc1.julday[q1_1[new_i]])


END


;DETAILED OUTPUT FROM MY INVESTIGACIONES
;; IDL> .run "/home/spencerh/Research/Cusp/storms_Alfvens/journals/journal__20151223__seas__18_integ_ion_flux_up_on_dayside_and_nightside__running_median.pro"
;; % Compiled module: JOURNAL__20151223__SEAS__18_INTEG_ION_FLUX_UP_ON_DAYSIDE_AND
;;   _NIGHTSIDE__RUNNING_MEDIAN.
;; IDL> JOURNAL__20151223__SEAS__18_INTEG_ION_FLUX_UP_ON_DAYSIDE_AND_NIGHTSIDE__RUNNING_MEDIAN
;; Restoring large_and_small_storms--1985-2011--Anderson.sav...
;; Restoring SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav...
;; Restoring large_and_small_storms--Oct1996-Oct2000--indices_for_four_quadrants--Anderson.sav...
;; TOTAL ELEMENTS: 41
;; ELEMENTS BEFORE 1970: 0
;; Restoring large_and_small_storms--1985-2011--Anderson.sav...
;; Restoring SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav...
;; Restoring large_and_small_storms--Oct1996-Oct2000--indices_for_four_quadrants--Anderson.sav...
;; This is a FAST Alfvén wave database...
;; Corrected the following: 
;; ELECTRONS: Earthward flow is positive
;; 07-ESA_CURRENT             (Flip sign in N Hemi)
;; 08-ELEC_ENERGY_FLUX        (Earthward is positive per AS5)
;; 09-INTEG_ELEC_ENERGY_FLUX  (Earthward is positive per AS5)
;; 10-EFLUX_LOSSCONE_INTEG    (Flip sign in S Hemi)
;; 11-TOTAL_EFLUX_INTEG       (Flip sign in S Hemi)
;; 12-MAX_CHARE_LOSSCONE      (All positive because AS5 uses MAX)
;; 13-MAX_CHARE_TOTAL         (Some negs because we divide e- energy flux by e- flux)
;; IONS: Outflow is positive
;; 14-ION_ENERGY_FLUX         (Abs. val. of energy flux per AS5, so already all pos)
;; 15-ION_FLUX                (Flip sign in S Hemi)
;; 16-ION_FLUX_UP             (Abs. val. per AS5, so all positive)
;; 17-INTEG_ION_FLUX          (Flip sign in N Hemi)
;; 18-INTEG_ION_FLUX_UP       (Flip sign in N Hemi)
;; 19-CHAR_ION_ENERGY         (In AS5, division of two quantities where hemi is not accounted for--how to interpret sign?)
;; 49-PFLUXEST                Map to ionosphere, multiplying by B_100km/B_alt
;; ...Finished correcting fluxes in Alfvén DB!
;; Using start and stop time from Dartmouth/Chaston database.
;; Start time: 1996-10-06/16:26:02.417
;; Stop time: 2000-10-06/00:08:45.188
;; Using provided epoch indices (41 epochs)...
;; Database: large_and_small_storms--1985-2011--Anderson.sav
;; Storm type: large
;; 41 storms (out of 41 in the DB) selected
;; Finding and trashing epochs that would otherwise appear twice in the superposed epoch analysis...
;; Using hours_aft_for_no_dupes = 60 for duplicate removal...
;; Losing 1 epochs that would otherwise be duplicated in the SEA...
;; Epoch 15:     1998-05-03/17:43:00
;; Loading /SPENCEdata/Research/Cusp/database/sw_omnidata/sw_data.dat...
;; GENERATE_GEOMAG_QUANTITIES: Using Dst...
;; GENERATE_GEOMAG_QUANTITIES: Using Dst...
;; No hemisphere specified! Set to default: NORTH...
;; There is already a maximus struct loaded! Not loading Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--w_Lshell--correct_pFlux--maximus.sav
;; This is a FAST Alfvén wave database...
;; Alfvén DB fluxes have already been corrected! Not correcting...
;; 
;; ****From get_chaston_ind.pro****
;; DBFile                        :   Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--w_Lshell--correct_pFlux--maximus.sav
;; 
;; This is a FAST Alfvén wave database...
;; N events in MLT range        :    1165350
;; N outside MLT range          :    0
;; 
;; N outside ILAT range         :    423214
;; 
;; N lost to current thresh      :   853218
;; 
;; This is a FAST Alfvén wave database...
;; NaNs/infs in     ELEC_ENERGY_FLUX      : 1
;; NaNs/infs in EFLUX_LOSSCONE_INTEG      : 1523
;; NaNs/infs in   MAX_CHARE_LOSSCONE      : 1
;; NaNs/infs in             ION_FLUX      : 46
;; NaNs/infs in       INTEG_ION_FLUX      : 632
;; NaNs/infs in      CHAR_ION_ENERGY      : 1435
;; NaNs/infs in              DELTA_E      : 28094
;; NaNs, infinities                       : 31732
;; N lost to basic sample freq restr      : 518109
;; N lost to basic cutoffs                : 549841
;; N surviving basic screening            : 615509
;; ****END basic_db_cleaner.pro****
;; 
;; 
;; ****From alfven_db_cleaner.pro****
;; N lost to user-defined cutoffs:   2023
;; ****END alfven_db_cleaner.pro****
;; 
;; N burst elements              :   61988
;; N survey elements             :   1103362
;; 
;; 
;; **********DATA SUMMARY**********
;; 
;; ************
;; Screening parameters         :       [Min]     [Max]
;; 
;; MLT                          :           0        24
;; ILAT                         :          50        86
;; (L-shell)                    :           2        16
;; Mag current                  :        -10.       10.
;; 
;; 
;; Hemisphere                   :       NORTH
;; Number of orbits used        :        5160
;; Total N events               :      196694
;; Percentage of DB used        :       16.88%
;; 
;; There are 196694 total indices making the cut.
;; 
;; ****END get_chaston_ind.pro****
;; 
;; i  centerTime           tempClosest (hours)    Num events in range
;; 0  1997-01-10/01:04:00  1.67                   690
;; 1  1997-04-16/13:20:00  2.04                   324
;; 2  1997-05-01/12:43:00  2.11                   852
;; 3  1997-05-15/01:59:00  3.39                   2007
;; 4  1997-05-26/09:57:00  0.15                   2195
;; 5  1997-06-08/16:36:00  7.21                   2025
;; 6  1997-09-02/22:39:00  0.76                   2633
;; 7  1997-10-01/00:59:00  0.56                   1547
;; 8  1997-10-10/16:12:00  0.05                   1487
;; 9  1997-11-06/22:48:00  7.02                   462
;; 10 1997-11-22/09:49:00  1.26                   696
;; 11 1997-12-30/02:09:00  1.23                   222
;; 12 1998-01-06/14:16:00  0.50                   1666
;; 13 1998-04-23/18:25:00  0.89                   6963
;; 14 1998-05-01/21:56:00  0.47                   8027
;; 15 1998-06-13/19:25:00  331.46                 0
;; 16 1998-06-25/16:36:00  616.64                 0
;; 17 1998-08-06/07:36:00  4.63                   1054
;; 18 1998-08-20/06:51:00  0.70                   1131
;; 19 1998-09-24/23:45:00  0.10                   1703
;; 20 1998-10-18/19:52:00  0.90                   1385
;; 21 1998-11-08/04:51:00  0.58                   5722
;; 22 1998-11-13/01:43:00  1.38                   2961
;; 23 1998-12-28/18:26:00  390.74                 0
;; 24 1999-01-13/10:54:00  414.39                 0
;; 25 1999-02-18/02:46:00  2.52                   2118
;; 26 1999-02-28/13:52:00  1.15                   1113
;; 27 1999-03-29/01:52:00  1.41                   2
;; 28 1999-04-16/11:25:00  21.66                  179
;; 29 1999-09-15/20:19:00  1.15                   734
;; 30 1999-09-22/12:22:00  8.61                   603
;; 31 1999-12-12/15:51:00  0.32                   1848
;; 32 2000-01-11/14:26:00  164.18                 0
;; 33 2000-02-11/23:52:00  917.61                 0
;; 34 2000-05-23/17:02:00  215.60                 0
;; 35 2000-06-08/09:10:00  591.73                 0
;; 36 2000-07-15/14:37:00  1485.18                0
;; 37 2000-07-19/15:27:00  1582.01                0
;; 38 2000-08-11/18:46:00  2137.33                0
;; 39 2000-10-05/03:26:00  3442.00                0
;; Number of epochs with Alfven events: 28
;; No bin centers provided for running average; using integer spacing ...
;; % Breakpoint at: SUPERPOSE_STORMS_ALFVENDBQUANTITIES  378
;;    /SPENCEdata/Research/Cusp/storms_Alfvens/superpose_storms_alfvendbquantiti
;;   es.pro
;; IDL> i
;;        9
;; IDL> geomag_dat_list[8]
;;       -12.000000      -19.000000      -26.000000      -26.000000      -21.000000
;;       -21.000000      -18.000000      -28.000000      -36.000000      -33.000000
;;       -36.000000      -35.000000      -33.000000      -32.000000      -26.000000
;;       -26.000000      -29.000000      -32.000000      -33.000000      -33.000000
;;       -33.000000      -34.000000      -35.000000      -43.000000      -50.000000
;;       -48.000000      -39.000000      -31.000000      -37.000000      -34.000000
;;       -30.000000      -32.000000      -36.000000      -34.000000      -33.000000
;;       -33.000000      -33.000000      -37.000000      -39.000000      -42.000000
;;       -43.000000      -40.000000      -36.000000      -33.000000      -35.000000
;;       -39.000000      -34.000000      -42.000000      -50.000000      -54.000000
;;       -56.000000      -52.000000      -52.000000      -49.000000      -45.000000
;;       -44.000000      -37.000000      -29.000000      -25.000000      -16.000000
;;       -14.000000      -38.000000      -65.000000      -59.000000      -64.000000
;;       -74.000000      -92.000000      -107.00000      -118.00000      -123.00000
;;       -130.00000      -114.00000      -105.00000      -98.000000      -93.000000
;;       -79.000000      -73.000000      -69.000000      -67.000000      -63.000000
;;       -60.000000      -59.000000      -55.000000      -55.000000      -55.000000
;;       -52.000000      -48.000000      -44.000000      -38.000000      -35.000000
;;       -33.000000      -32.000000      -32.000000      -35.000000      -40.000000
;;       -44.000000      -46.000000      -43.000000      -39.000000      -39.000000
;;       -47.000000      -49.000000      -44.000000      -42.000000      -40.000000
;;       -39.000000      -40.000000      -39.000000      -39.000000      -34.000000
;;       -33.000000      -32.000000      -34.000000      -33.000000      -33.000000
;;       -31.000000      -34.000000      -39.000000      -40.000000      -41.000000
;; IDL> i
;;       20
;; IDL> geomag_dat_list[19]
;;       -2.0000000      -2.0000000      -4.0000000      -4.0000000      -5.0000000
;;       -3.0000000      -4.0000000      -13.000000      -15.000000      -18.000000
;;       -19.000000      -21.000000      -24.000000      -25.000000      -22.000000
;;       -13.000000      -11.000000      -9.0000000      -15.000000      -11.000000
;;       -11.000000      -14.000000      -17.000000      -19.000000      -12.000000
;;       -11.000000      -13.000000      -18.000000      -25.000000      -27.000000
;;       -30.000000      -33.000000      -28.000000      -24.000000      -27.000000
;;       -28.000000      -38.000000      -37.000000      -31.000000      -28.000000
;;       -32.000000      -44.000000      -52.000000      -55.000000      -46.000000
;;       -41.000000      -35.000000      -30.000000      -25.000000      -23.000000
;;       -25.000000      -28.000000      -26.000000      -27.000000      -35.000000
;;       -37.000000      -36.000000      -38.000000      -43.000000      -37.000000
;;       -4.0000000      -20.000000      -85.000000      -152.00000      -170.00000
;;       -166.00000      -169.00000      -202.00000      -196.00000      -207.00000
;;       -193.00000      -172.00000      -147.00000      -134.00000      -124.00000
;;       -121.00000      -98.000000      -85.000000      -72.000000      -66.000000
;;       -66.000000      -66.000000      -66.000000      -58.000000      -55.000000
;;       -47.000000      -46.000000      -48.000000      -48.000000      -46.000000
;;       -48.000000      -52.000000      -50.000000      -47.000000      -46.000000
;;       -49.000000      -49.000000      -55.000000      -62.000000      -68.000000
;;       -72.000000      -75.000000      -71.000000      -66.000000      -55.000000
;;       -51.000000      -49.000000      -48.000000      -54.000000      -57.000000
;;       -56.000000      -54.000000      -52.000000      -46.000000      -41.000000
;;       -43.000000      -44.000000      -43.000000      -45.000000      -51.000000
;; IDL> i
;;       22
;; IDL> geomag_dat_list[21]
;;       -27.000000      -26.000000      -28.000000      -31.000000      -28.000000
;;       -27.000000      -26.000000      -26.000000      -23.000000      -23.000000
;;       -23.000000      -26.000000      -34.000000      -44.000000      -52.000000
;;       -61.000000      -58.000000      -54.000000      -49.000000      -49.000000
;;       -44.000000      -52.000000      -58.000000      -58.000000      -58.000000
;;       -60.000000      -54.000000      -45.000000      -47.000000      -44.000000
;;       -42.000000      -37.000000      -41.000000      -40.000000      -37.000000
;;       -38.000000      -38.000000      -39.000000      -32.000000      -20.000000
;;       -14.000000      -13.000000      -10.000000      -29.000000      -56.000000
;;       -68.000000      -70.000000      -81.000000      -72.000000      -71.000000
;;       -66.000000      -55.000000      -53.000000      -48.000000      -55.000000
;;       -74.000000      -87.000000      -96.000000      -96.000000      -109.00000
;;       -140.00000      -149.00000      -120.00000      -109.00000      -104.00000
;;       -98.000000      -81.000000      -69.000000      -54.000000      -42.000000
;;       -38.000000      -27.000000      -22.000000      -21.000000      -16.000000
;;       -16.000000      -21.000000      -27.000000      -31.000000      -29.000000
;;       -41.000000      -44.000000      -46.000000      -44.000000      -80.000000
;;       -103.00000      -108.00000      -123.00000      -127.00000      -115.00000
;;       -124.00000      -137.00000      -120.00000      -118.00000      -132.00000
;;       -137.00000      -142.00000      -142.00000      -127.00000      -110.00000
;;       -103.00000      -108.00000      -104.00000      -93.000000      -85.000000
;;       -78.000000      -76.000000      -76.000000      -75.000000      -70.000000
;;       -62.000000      -61.000000      -59.000000      -57.000000      -53.000000
;;       -54.000000      -53.000000      -53.000000      -49.000000      -47.000000
;; IDL> i=0
;; IDL> i
;;        1
;; IDL> i
;;        8
;; IDL> i=7
;; IDL> i
;;       15
;; IDL> i
;;       16
;; IDL> i
;;       16
;; IDL> i
;;       16
;; IDL> i=15
;; IDL> i
;;       22
;; IDL> i
;;       37
;; IDL> i
;;       39
;; IDL> i
;;       40
;; IDL> i
;;       40
;; IDL> 