;;06/09/16
PRO JOURNAL__20160609__HOW_MANY_BROADBAND_E_SPECTRA_LOST_TO_CHARE_REQ_FOR_STORMS

  COMPILE_OPT IDL2,STRICTARRSUBS

  ;; despun       = 0

  charEthresh  = 80

  LOAD_ALF_NEWELL_ESPEC_DB,eSpec,FAILCODES=failCodes
  LOAD_MAXIMUS_AND_CDBTIME,maximus

  stormIndDir  = '~/Research/Satellites/FAST/storms_Alfvens/saves_output_etc/'

  files        = ['Jun_3_16--nonstorm--Dstcutoff_-20--NORTH--logAvg--maskMin10--alfDB_indices.sav', $     
                  'Jun_3_16--mainphase--Dstcutoff_-20--NORTH--logAvg--maskMin10--alfDB_indices.sav', $
                  'Jun_3_16--recoveryphase--Dstcutoff_-20--NORTH--logAvg--maskMin10--alfDB_indices.sav']

  outDir       = '~/Research/Satellites/FAST/storms_Alfvens/txtOutput/'
  SET_PLOT_DIR,plotDir,/FOR_STORMS

  str          = ['nonstorm','mainphase','recoveryphase']
  outSumFiles  = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--storm_newell_event_info--charethresh'+$
                 STRCOMPRESS(charEThresh,/REMOVE_ALL)+'--' + str + '--NORTH.txt'
  outCharEPlot = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--char_e_plots--'+ str + '--NORTH.png'

  FOR i=0,2 DO BEGIN
     PRINT,'Restoring ' + files[i] + ' ...'
     RESTORE,stormIndDir+files[i]

     PRINT,'Opening ' + outSumFiles[i] + ' ...'
     OPENW,outLun,outDir+outSumFiles[i],/GET_LUN

     CAT_EVENTS_FROM_PARSED_SPECTRAL_STRUCT,tmpEspecs,eSpec,plot_i
     CAT_FAILCODES,tmpFailCodes,failCodes,plot_i

     PRINT_ESPEC_STATS,tmpEspecs, $
                       FAILCODES=tmpFailCodes, $
                       CHARETHRES=charEthresh, $
                       /INTERPRETED_STATISTICS, $
                       LUN=outLun

     CGHISTOPLOT,maximus.max_chare_losscone[plot_i],MAXINPUT=300, $
                 OUTPUT=plotDir+outCharEPlot[i], $
                 TITLE="Characteristic energy (" + str[i] + "), Northern Hemi"

     tmpESpecs      = !NULL
     tmpFailCodes   = !NULL

     PRINT,'Closing ' + outSumFiles[i] + ' ...'
     CLOSE,outLun
     FREE_LUN,outLun

  ENDFOR

END

