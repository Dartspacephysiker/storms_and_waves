;2016/02/06 Now we're gonna do this batch thing, so here's the journal that makes the list of orbits
PRO JOURNAL__20160206__PART_IV__CHECK_OUT_TIMES_FOR_EVENTS_ON_DAYSIDE_DURING_MAINPHASE_TO_CHECK_FOR_MSHEATH_ELECTRONS__NORTH_OR_SOUTH

  min_for_inclusion             = 50   ;Min number of events to participate in the action

  hemi                          = 'north'
  ;; hemi                          = 'south'

  inds_filename                 = 'journal__20160206__inds_for_all_events_on_dayside_during_mainphase_to_check_for_msheath_electrons__'+hemi+'.sav'
  out_time_filename             = 'journal__20160206__times_for_orbs_with_more_than_' + STRCOMPRESS(min_FOR_inclusion,/REMOVE_ALL) + $
                                  '_events_on_dayside_during_mainphase__check_for_msheath_electrons__'+hemi+'.sav'
  RESTORE,inds_filename

  LOAD_MAXIMUS_AND_CDBTIME,maximus

  nUniqOrbs                     = N_ELEMENTS(uniq_orbs_list)

  orbArr                        = !NULL
  nOrbArr                       = !NULL
  ;; orb_list_i                    = LIST()
  orb_startstopArr              = !NULL
  PRINT,FORMAT='("Orbit",T8,"N events",T20,"Start",T45,"Stop",T70,"Duration (min)")'
  FOR i=0,nUniqOrbs-1 DO BEGIN
     thisOrb                    = uniq_orbs_list[i]
     ii_thisOrb                 = WHERE(maximus.orbit[inds_list] EQ thisOrb)
     i_thisOrb                  = inds_list[ii_thisOrb]
     ;; orb_list_i.add,i_thisOrb
     nThisOrb                   = N_ELEMENTS(i_thisOrb)

     IF nThisOrb GE min_for_inclusion THEN BEGIN
        orbArr                  = [orbArr,thisOrb]
        nOrbArr                 = [nOrbArr,nThisOrb]

        ;;get the times
        tempTimes               = str_to_time(maximus.time[i_thisOrb])
        minTime                 = MIN(tempTimes,MAX=maxTime)
        orb_startstopArr        = [[orb_startstopArr],[minTime,maxTime]]
        ;; PRINT,FORMAT='(I0,T8,I0,T16,A0,T45,A0)',thisOrb,nThisOrb,maximus.time[i_thisOrb[0]],maximus.time[i_thisOrb[-1]]
        ;; PRINT,FORMAT='(I0,T8,I0,T20,G0.2,T45,G0.2)',thisOrb,nThisOrb,minTime,maxTime
        PRINT,FORMAT='(I0,T8,I0,T20,A0,T45,A0,T70,F0.2)',thisOrb,nThisOrb,TIME_TO_STR(minTime,/MS),TIME_TO_STR(maxTime,/MS),(maxTime-minTime)/60.

     ENDIF
  ENDFOR

  PRINT,'Total awesome orbits: ',N_ELEMENTS(nOrbArr)

  PRINT,'Saving orb_startstopArr, nOrbArr, orbArr, to ' + out_time_filename
  save,orb_startstopArr,nOrbArr,orbArr,FILENAME=out_time_filename

END
