;Need some numbers!
PRO JOURNAL__20160211__PRINT_STATISTICS_OF_DAYSIDE_PROBOCCURRENCE_DURING_STORMPHASES__FASTLOCINTERVALS4

  tempDir          = '/SPENCEdata/Research/Cusp/ACE_FAST/temp/'

  phaseStr         = ['nonstorm','mainphase','recoveryphase']
  phaseFiles       = tempDir + 'polarplots_Feb_8_16--' + phaseStr + '--Dstcutoff_-20--NORTH--logAvg--inside_extremeVals.dat'
  nFiles           = N_ELEMENTS(phaseFiles)

  ;;params
  minM_sum         = [9]
  maxM_sum         = [15]

  minI_sum         = [60]
  maxI_sum         = [74]
  regDescr         = ['cusp-region']
  ;; output files
  outDir           = '/SPENCEdata/Research/Cusp/storms_Alfvens/saves_output_etc/journal__20160211--print_probOccurrence_stats/'
  outPref          = 'journal__20160211__print_statistics_of_probOccurrence--' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  FOR j=0,N_ELEMENTS(minM_sum)-1 DO BEGIN
     regionStr  = STRING(FORMAT='(I0,"-",I0,"_MLT--",I0,"-",I0,"_ILAT--",A0)', $
                         minM_sum[j],maxM_sum[j], $
                         minI_sum[j],maxI_sum[j], $
                         regDescr[j])
     FOR i=0,nFiles-1 DO BEGIN
        
        MAKE_DIR_IF_NOT_EXIST,outDir + regDescr[j] + '/',/MAKE_PARENTS
        outFiles   = outDir + regDescr[j] + '/' + outPref  + '--' + phaseStr + '--' + regionStr + '.txt'
        
        SUM_ALFVENDB_2DHISTOS,FILE_TO_READ=phaseFiles[i], $
                              MINM_SUM=minM_sum[j], $
                              MINI_SUM=minI_sum[j], $
                              MAXM_SUM=maxM_sum[j], $
                              MAXI_SUM=maxI_sum[j], $
                              /PRINT_LOGSTATS, $
                              /PRINT_SUM_CONSTITUENTS

     ENDFOR
  ENDFOR
END