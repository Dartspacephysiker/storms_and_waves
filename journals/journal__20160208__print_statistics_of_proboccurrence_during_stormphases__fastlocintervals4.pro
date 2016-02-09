;Need some numbers!
PRO JOURNAL__20160208__PRINT_STATISTICS_OF_PROBOCCURRENCE_DURING_STORMPHASES__FASTLOCINTERVALS4

  tempDir          = '/SPENCEdata/Research/Cusp/ACE_FAST/temp/'

  phaseStr         = ['nonstorm','mainphase','recoveryphase']
  phaseFiles       = tempDir + 'polarplots_Feb_8_16--' + phaseStr + '--Dstcutoff_-20--NORTH--logAvg--inside_extremeVals.dat'
  nFiles           = N_ELEMENTS(phaseFiles)

  ;;params
  minM_sum         = [21,12,15,-3]
  maxM_sum         = [24,15,18,6]

  minI_sum         = [68,68,60,60]
  maxI_sum         = [74,78,70,74]
  regDescr         = ['pre-midnight','post-noon','low-lat_dusk','pre-mid_to_dawn']
  ;; output files
  outDir           = '/SPENCEdata/Research/Cusp/storms_Alfvens/saves_output_etc/journal__20160208--print_probOccurrence_stats/'
  outPref          = 'journal__20160208__print_statistics_of_probOccurrence--' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  FOR j=0,N_ELEMENTS(minM_sum)-1 DO BEGIN
     regionStr  = STRING(FORMAT='(I0,"-",I0,"_MLT--",I0,"-",I0,"_ILAT--",A0)', $
                         minM_sum[j],maxM_sum[j], $
                         minI_sum[j],maxI_sum[j], $
                         regDescr[j])
     FOR i=0,nFiles-1 DO BEGIN
        outFiles   = outDir + regDescr[j] + '/' + outPref  + '--' + phaseStr + '--' + regionStr + '.txt'
        
        SUM_ALFVENDB_2DHISTOS,FILE_TO_READ=phaseFiles[i], $
                              MINM_SUM=minM_sum[j], $
                              MINI_SUM=minI_sum[j], $
                              MAXM_SUM=maxM_sum[j], $
                              MAXI_SUM=maxI_sum[j], $
                              /PRINT_LOGSTATS, $
                              /PRINT_SUM_CONSTITUENTS, $
                              /SAVEOUTPUT, $
                              OUTPUTFILENAME=outFiles[i]

     ENDFOR
  ENDFOR
END