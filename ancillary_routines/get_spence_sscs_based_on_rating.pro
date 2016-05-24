;;2016/01/23 So what about those old Spence ratings?
PRO GET_SPENCE_SSCS_BASED_ON_RATING,storm_inds,storm_utcs,STORMRATING=stormRating

  commencementDir           = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/saves_output_etc/'
  commencementFile          = commencementDir + 'commencement_offsets_for_largestorms--20160123--WITH_UTCs.sav'
  restore,commencementFile

  defaultRating             = 3
  IF ~KEYWORD_SET(stormRating) THEN BEGIN
     PRINT,'No storm rating, Spence! Setting it to ' + STRCOMPRESS(defaultRating,/REMOVE_ALL) + '...'
     stormRating            = defaultRating
  ENDIF

  subset_i                  = WHERE(lrg_commencement.rating GE stormRating,nStorms)
  PRINT,'Selecting ' + STRCOMPRESS(nStorms,/REMOVE_ALL) + ' storms...'

  ;;The indices here give the index relative to large storms AFTER the beginning of the Dartmouth Alfvénic FAC database
  ;; lrg_commencement          ={lrgStorm_AND_after_dartdb_begins_ind:lrg_commencement.lrgStorm_AND_after_dartdb_begins_ind[subset_i], $
  ;;                             inds_into_stormStruct:lrg_commencement.inds_into_stormStruct[subset_i], $
  ;;                             time:lrg_commencement.time[subset_i], $
  ;;                             dst_min:lrg_commencement.dst_min[subset_i], $
  ;;                             offset:lrg_commencement.offset[subset_i], $
  ;;                             offset_dst:lrg_commencement.offset_dst[subset_i], $
  ;;                             rating:lrg_commencement.rating[subset_i], $
  ;;                             comment:lrg_commencement.comment[subset_i]}

  storm_inds                = lrg_commencement.inds_into_stormStruct[subset_i]
  storm_utcs                = lrg_commencement.time[subset_i]

  ;;Load the other stuff
  ;; LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,INDS_FILE=inds_file
  ;; LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,INDS_FILE=inds_file
  ;; q1_st=qi[0].list_i[0]
  ;; q1_1=qi[1].list_i[0]
  
  ;; q1_utc=conv_julday_to_utc(ssc1.julday[q1_1])

  ;; stormStruct_inds=WHERE(stormStruct.time GE startDate AND stormStruct.time LE stopDate AND stormstruct.is_largestorm,/NULL)


END