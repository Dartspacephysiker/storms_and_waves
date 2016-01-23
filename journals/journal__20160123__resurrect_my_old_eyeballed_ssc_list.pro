;The idea is to make all of the SSCs I identified "by hand" available for input into the updated storm routines
PRO JOURNAL__20160123__RESURRECT_MY_OLD_EYEBALLED_SSC_LIST

  ;;Get those oldies but goodies
  commencementDir           = '/SPENCEdata/Research/Cusp/storms_Alfvens/saves_output_etc/'
  commencementFile          = commencementDir + 'commencement_offsets_for_largestorms--20150629--HEAVILY_PARED.sav'
  saveFile                  = commencementDir + 'commencement_offsets_for_largestorms--20160123--WITH_UTCs.sav'


  restore,commencementFile


  ;; min_rating=3
  ;; subset_i=WHERE(lrg_commencement.rating GE min_rating)

  ;; ;;The indices here give the index relative to large storms AFTER the beginning of the Dartmouth Alfvénic FAC database
  
  ;; lrg_commencement={ind:lrg_commencement.ind[subset_i], $
  ;;                   dst_min:lrg_commencement.dst_min[subset_i], $
  ;;                   offset:lrg_commencement.offset[subset_i], $
  ;;                   offset_dst:lrg_commencement.offset_dst[subset_i], $
  ;;                   rating:lrg_commencement.rating[subset_i], $
  ;;                   comment:lrg_commencement.comment[subset_i]}

  ;;in UTC
  ;; load_maximus_and_cdbtime,maximus
  ;; startDate=str_to_time(maximus.time[0])
  ;; stopDate=str_to_time(maximus.time[-1])
  startDate                 = 844619162.41700006 ;1996-10-06/16:26:02.417
  stopDate                  = 970790925.18799996 ;2000-10-06/00:08:45.188



  ;;Load the other stuff
  ;; LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,INDS_FILE=inds_file
  LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,SSC1,SSC2,qi,INDS_FILE=inds_file
  q1_st                     = qi[0].list_i[0]
  q1_1                      = qi[1].list_i[0]
  q1_utc                    = conv_julday_to_utc(ssc1.julday[q1_1])
  stormStruct_inds          = WHERE(stormStruct.time GE startDate AND stormStruct.time LE stopDate AND stormstruct.is_largestorm,/NULL)

  ;;Get the times of my SSCs in UTC
  times                     = stormstruct.time[stormStruct_inds[lrg_commencement.ind]] + lrg_commencement.offset

  lrg_commencement          ={lrgStorm_AND_after_dartdb_begins_ind:lrg_commencement.ind, $
                              inds_into_stormStruct:stormStruct_inds[lrg_commencement.ind], $
                              time:times, $
                              dst_min:lrg_commencement.dst_min, $
                              offset:lrg_commencement.offset, $
                              offset_dst:lrg_commencement.offset_dst, $
                              rating:lrg_commencement.rating, $
                              comment:lrg_commencement.comment}


  save,lrg_commencement,FILENAME=saveFile

END