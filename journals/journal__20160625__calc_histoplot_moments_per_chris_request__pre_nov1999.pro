PRO JOURNAL__20160625__CALC_HISTOPLOT_MOMENTS_PER_CHRIS_REQUEST__PRE_NOV1999

  dataDir      = '20160625--stormphase_histo_data--10_EFLCI_18_IIFU_49_PFE/'
  date         = '20160625'

  outText      = dataDir+date + '--10_EFLUX_LOSSCONE_INTEG__18_INTEG_ION_FLUX_UP__49_PFLUXEST--moments.txt'
  OPENW,lun,outText,/GET_LUN

  dayFiles     = [date+'--stormphase_histos--overlaid_phases--10_10_EFLUX_LOSSCONE_INTEG.sav', $
                  date+'--stormphase_histos--overlaid_phases--18_18_INTEG_ION_FLUX_UP.sav', $
                  date+'--stormphase_histos--overlaid_phases--49_49_PFLUXEST.sav']

  nightFiles   = [date+'--stormphase_histos--overlaid_phases--10_10_EFLUX_LOSSCONE_INTEG--6.0-18.0--18.0-6.0_MLT.sav', $
                  date+'--stormphase_histos--overlaid_phases--18_18_INTEG_ION_FLUX_UP--6.0-18.0--18.0-6.0_MLT.sav', $
                  date+'--stormphase_histos--overlaid_phases--49_49_PFLUXEST--6.0-18.0--18.0-6.0_MLT.sav']

  dayFiles     = dataDir + dayFiles
  nightFiles   = dataDir + nightFiles

  quantities   = ['Integ. l.c. e- flux (mW/m)','Integ. upward ion flux (#/cm-s)','Integ. Poynting flux (mW/m)']
  phases       = ['Quiet','Main','Recovery']

  mltSide      = ['Dayside','Nightside']

  ;; PRINT,FORMAT='("Storm Phase",T47,"Location",T59,"Log Mean",T72,"(Log scale)",T87,"Mean",T102,"(Log scale)")'
  FOR iFile=0,N_ELEMENTS(dayFiles)-1 DO BEGIN
     PRINTF,lun,"******************************"
     PRINTF,lun,quantities[iFile]
     PRINTF,lun,"******************************"
     PRINTF,lun,FORMAT='("Storm Phase",T13,"Location",T25,"Log Mean",T38,"(Log scale)",T53,"Mean",T68,"(Log scale)")'
     PRINTF,lun,''
     FOR iPhase=0,N_ELEMENTS(phases)-1 DO BEGIN
        ;;DAYTIME
        RESTORE,dayFiles[iFile]
        bsDay                 = saved_ssa_list[0,iPhase].yhiststr.binsize
        normedDay             = (saved_ssa_list[0,iPhase].yhiststr.hist[0]/TOTAL(saved_ssa_list[0,iPhase].yhiststr.hist[0]))[0:-2]

        d_binsDay             = (SHIFT(saved_ssa_list[0,iPhase].yhiststr.locs[0],-1)-saved_ssa_list[0,iPhase].yhiststr.locs[0])[0:-2]
        d_bins_unlogDay       = (10.^(SHIFT(saved_ssa_list[0,iPhase].yhiststr.locs[0],-1))-10.^(saved_ssa_list[0,iPhase].yhiststr.locs[0]))[0:-2]

        binCentersDay         = (ROUND((saved_ssa_list[0,iPhase].yhiststr.locs[0]+bsDay*.5)*100.)*.01)[0:-2]
        binCenters_unlogDay   = 10.^((ROUND((saved_ssa_list[0,iPhase].yhiststr.locs[0]+bsDay*.5)*100.)*.01))[0:-2]

        statDay               = TOTAL(binCentersDay*normedDay*d_binsDay)/TOTAL(normedDay*d_binsDay)
        stat_unlogDay         = TOTAL(binCenters_unlogDay*normedDay*d_bins_unlogDay)/TOTAL(normedDay*d_bins_unlogDay)


        ;;NIGHTTIME
        RESTORE,nightFiles[iFile]
        bsNight                 = saved_ssa_list[0,iPhase].yhiststr.binsize
        normedNight             = (saved_ssa_list[0,iPhase].yhiststr.hist[0]/TOTAL(saved_ssa_list[0,iPhase].yhiststr.hist[0]))[0:-2]

        d_binsNight             = (SHIFT(saved_ssa_list[0,iPhase].yhiststr.locs[0],-1)-saved_ssa_list[0,iPhase].yhiststr.locs[0])[0:-2]
        d_bins_unlogNight       = (10.^(SHIFT(saved_ssa_list[0,iPhase].yhiststr.locs[0],-1))-10.^(saved_ssa_list[0,iPhase].yhiststr.locs[0]))[0:-2]

        binCentersNight         = (ROUND((saved_ssa_list[0,iPhase].yhiststr.locs[0]+bsNight*.5)*100.)*.01)[0:-2]
        binCenters_unlogNight   = 10.^((ROUND((saved_ssa_list[0,iPhase].yhiststr.locs[0]+bsNight*.5)*100.)*.01))[0:-2]

        statNight               = TOTAL(binCentersNight*normedNight*d_binsNight)/TOTAL(normedNight*d_binsNight)
        stat_unlogNight         = TOTAL(binCenters_unlogNight*normedNight*d_bins_unlogNight)/TOTAL(normedNight*d_bins_unlogNight)


        ;;Which thing?
        ;; PRINTF,lun,saved_ssa_list[0,iPhase].dataname[0]
        PRINTF,lun,FORMAT='(A0,T13,A0,T25,G10.4,T38,"(",F7.4,")",T53,G10.4,T68,"(",F7.4,")")', $
              phases[iPhase], $
              mltSide[0], $
              10.^(statDay),statDay, $
              stat_unlogDay,ALOG10(stat_unlogDay)
        PRINTF,lun,FORMAT='(A0,T13,A0,T25,G10.4,T38,"(",F7.4,")",T53,G10.4,T68,"(",F7.4,")")', $
              phases[iPhase], $
              mltSide[1], $
              10.^(statNight),statNight, $
              stat_unlogNight,ALOG10(stat_unlogNight)
     ENDFOR
     PRINTF,lun,""
  ENDFOR

  CLOSE,lun

  FREE_LUN,lun

  ;; FOR iFile=0,N_ELEMENTS(nightFiles)-1 DO BEGIN
  ;;    FOR iPhase=0,N_ELEMENTS(saved_ssa_list[0])-1 DO BEGIN
  ;;       RESTORE,nightFiles[iFile]
  ;;       bsNight                 = saved_ssa_list[0,iPhase].yhiststr.binsize
  ;;       normedNight             = (saved_ssa_list[0,iPhase].yhiststr.hist[0]/TOTAL(saved_ssa_list[0,iPhase].yhiststr.hist[0]))[0:-2]

  ;;       d_binsNight             = (SHIFT(saved_ssa_list[0,iPhase].yhiststr.locs[0],-1)-saved_ssa_list[0,iPhase].yhiststr.locs[0])[0:-2]
  ;;       d_bins_unlogNight       = (10.^(SHIFT(saved_ssa_list[0,iPhase].yhiststr.locs[0],-1))-10.^(saved_ssa_list[0,iPhase].yhiststr.locs[0]))[0:-2]

  ;;       binCentersNight         = (ROUND((saved_ssa_list[0,iPhase].yhiststr.locs[0]+bsNight*.5)*100.)*.01)[0:-2]
  ;;       binCenters_unlogNight   = 10.^((ROUND((saved_ssa_list[0,iPhase].yhiststr.locs[0]+bsNight*.5)*100.)*.01))[0:-2]

  ;;       statNight               = TOTAL(binCentersNight*normedNight*d_binsNight)/TOTAL(normedNight*d_binsNight)
  ;;       stat_unlogNight         = TOTAL(binCenters_unlogNight*normedNight*d_bins_unlogNight)/TOTAL(normedNight*d_bins_unlogNight)
  ;;       ;;Which thing?
  ;;       ;; PRINT,saved_ssa_list[0,iPhase].dataname[0]
  ;;       PRINT,FORMAT='(A0,T34,A0,T47,G10.4,T60,"(",F7.4,")",T75,G10.4,T90,"(",F7.4,")")', $
  ;;             quantities[iFile], $
  ;;             phases[iPhase], $
  ;;             10.^(statNight),statNight, $
  ;;             stat_unlogNight,ALOG10(stat_unlogNight)
  ;;    ENDFOR
  ;; ENDFOR
END