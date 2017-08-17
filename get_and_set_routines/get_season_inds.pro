;;01/26/17
;;A test:
;; LOAD_MAXIMUS_AND_CDBTIME,!NULL,CDBTime,/NO_MEMORY_LOAD,/JUST_CDBTIME
;; test = (N_ELEMENTS(GET_SEASON_INDS(CDBTime,/SPRING)) + N_ELEMENTS(GET_SEASON_INDS(CDBTime,/SUMMER)) +
;;N_ELEMENTS(GET_SEASON_INDS(CDBTime,/FALL )) + N_ELEMENTS(GET_SEASON_INDS(CDBTime,/WINTER))) EQ N_ELEMENTS(CDBTime)
FUNCTION GET_SEASON_INDS,times, $
                         SPRING=spring, $
                         SUMMER=summer, $
                         FALL=fall, $
                         WINTER=winter, $
                         ALL_SEASONS=all_seasons, $
                         HEMI=hemi, $
                         USE_JULDAY=use_julDay, $
                         OUT_IND_STRUCT=indStruct, $
                         QUIET=quiet

  COMPILE_OPT IDL2,STRICTARRSUBS

  nTime = N_ELEMENTS(times)
  IF nTime EQ 0 THEN BEGIN
     PRINT,"No times provided! Returning ..."
     RETURN,-1
  ENDIF

  LOAD_SEASONS_STRUCT,seasons,sp,su,fa,wi,/QUIET

  hem = KEYWORD_SET(hemi) ? hemi : 'NORTH'
  CASE STRUPCASE(hem) OF
     'NORTH': BEGIN
        CASE 1 OF
           KEYWORD_SET(spring): BEGIN
              saison = sp
              saiStr = 'spring'
           END
           KEYWORD_SET(summer): BEGIN
              saison = su
              saiStr = 'summer'
           END
           KEYWORD_SET(fall): BEGIN
              saison = fa
              saiStr = 'fall'
           END
           KEYWORD_SET(winter): BEGIN
              saison = wi
              saiStr = 'winter'
           END
           KEYWORD_SET(all_seasons): BEGIN
              saison = LIST(sp,su,fa,wi)
              saiStr = ['Spring','Summer','Fall','Winter']
           END
        ENDCASE        
     END
     'SOUTH': BEGIN
        CASE 1 OF
           KEYWORD_SET(spring): BEGIN
              saison = fa
              saiStr = 'spring'
           END
           KEYWORD_SET(summer): BEGIN
              saison = wi
              saiStr = 'summer'
           END
           KEYWORD_SET(fall): BEGIN
              saison = sp
              saiStr = 'fall'
           END
           KEYWORD_SET(winter): BEGIN
              saison = su
              saiStr = 'winter'
           END
           KEYWORD_SET(all_seasons): BEGIN
              saison = LIST(fa,wi,sp,su)
              saiStr = ['Spring','Summer','Fall','Winter']
           END
        ENDCASE        
     END
  ENDCASE


  indList = LIST()
  nTotArr = !NULL
  ;; IF ARG_PRESENT(indStruct) THEN indStruct = !NULL
  FOREACH season,saison,iSais DO BEGIN

     IF ~KEYWORD_SET(quiet) THEN PRINT,"Getting " + saiStr[iSais] + "(in " + hem + " hemi) inds ..."

     CASE nTime OF
        0: BEGIN
           PRINT,"No times provided! Returning ..."
           RETURN,-1
        END
        ELSE: BEGIN
           CASE 1 OF
              KEYWORD_SET(use_julDay): BEGIN
                 startTime_i = VALUE_CLOSEST2(season.julDay[0,*],(times[SORT(times)])[0],/ONLY_LE)
                 stopTime_i  = VALUE_CLOSEST2(season.julDay[1,*],(times[SORT(times)])[-1],/ONLY_GE)
              END
              ELSE: BEGIN
                 startTime_i = VALUE_CLOSEST2(season.utc[0,*],(times[SORT(times)])[0],/ONLY_LE)
                 stopTime_i  = VALUE_CLOSEST2(season.utc[1,*],(times[SORT(times)])[-1],/ONLY_GE)
              END
           ENDCASE
        END
     ENDCASE

     IF ~KEYWORD_SET(use_julDay) THEN BEGIN
        IF ~KEYWORD_SET(quiet) THEN PRINT,"Making sure we only check stuff AFTER 1970 ... (You're using UTC, after all)"

        minStart_i = MIN(WHERE(season.utc[0,*] GT 0))
        minStop_i  = MIN(WHERE(season.utc[1,*] GT 0))
        IF startTime_i LT minStart_i THEN startTime_i = minStart_i
        IF stopTime_i  LT minStop_i  THEN stopTime_i  = minStop_i
     ENDIF
     

     seasonInds = !NULL
     nTot       = 0
     CASE 1 OF
        KEYWORD_SET(use_julDay): BEGIN
           FOR k=startTime_i,stopTime_i DO BEGIN
              tmpInds = WHERE((times GE season.julDay[0,k]) AND times LE season.julDay[1,k],nTmp)
              IF nTmp GT 0 THEN BEGIN
                 seasonInds = [seasonInds,tmpInds]
                 nTot      += nTmp
              ENDIF
           ENDFOR
        END
        ELSE: BEGIN
           FOR k=startTime_i,stopTime_i DO BEGIN
              tmpInds = WHERE((times GE season.utc[0,k]) AND times LE season.utc[1,k],nTmp)
              IF nTmp GT 0 THEN BEGIN
                 seasonInds = [seasonInds,tmpInds]
                 nTot      += nTmp
              ENDIF
           ENDFOR
        END
     ENDCASE

     IF ~KEYWORD_SET(quiet) THEN PRINT,"Got " + STRCOMPRESS(nTot) + " " + saiStr[iSais] + "time inds ..."

     ;; IF ARG_PRESENT(indStruct) THEN BEGIN
     ;;    ;; indStruct = [indStruct,{season : saiStr[iSais], $
     ;;    ;;                         N      : nTot}]
     ;; ENDIF

     indList.Add,seasonInds
     nTotArr = [nTotArr,nTot]
     
  ENDFOREACH

  IF ARG_PRESENT(indStruct) THEN BEGIN
     indStruct = {season : saiStr, $
                  N      : nTotArr }
  ENDIF

  CASE 1 OF
     KEYWORD_SET(all_seasons): BEGIN

        IF ARG_PRESENT(indStruct) THEN BEGIN
           indStruct = {season : [indStruct.season,'Equinox'], $
                        N      : [indStruct.N,indStruct.N[0]+indStruct.N[2]]}
        ENDIF


        RETURN,indList
     END
     ELSE: BEGIN
        RETURN,seasonInds
     END
  ENDCASE

  ;; RETURN,seasonInds

END
