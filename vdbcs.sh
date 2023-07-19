#!/usr/bin/env bash

start_time=$(date +%s%N)

TIMEFORMAT="Время выполнения скрипта %lR"
time {

# Script to configure scenes for viewing RTMP streams in OBS

source lang.sh
lang='eng'
count_views=25
sources_list_file='sources.list'
sources_list_csv_file='sources.list.csv'
slf='txt'

function get_sources_from_txt() {
  i=0
  while read line; do
    read -a arr <<< "$line"
	instance[$i]="${arr[0]}"
    lang_array[$i]="${arr[1]}"
    sources_array[$i]="${arr[2]}"
    i=$(($i+1))
  done < ${sources_list_file}
}

function get_sources_from_csv() {
  i=0
  sed -i 's/-,/,/g' $sources_list_csv_file
  sed -i 's/  A/A/g' $sources_list_csv_file
  IFS=","
  while read line; do
    read -a arr <<< "$line"
	instance[$i]="${arr[0]}"
    lang_array[$i]="${arr[1]}"
    sources_array[$i]="${arr[2]}"
    i=$(($i+1))
  done < ${sources_list_csv_file}
  IFS=""
}

function create_vdb() {
  if [ -d 'vdb' ]
  then
    rm -rf vdb/
  fi
  mkdir vdb
  v_c=$(echo "scale=0;"${#sources_array[*]}"/"$count_views"" | bc)
  if [ $(($v_c*$count_views)) -eq ${#sources_array[*]} ]
  then
    vdb_count=$v_c
  else
    vdb_count=$(($v_c+1))
  fi
  for (( k=1; k <= $vdb_count; k++ ))
  do
    template_filename='template/RTMP_monitoring_'$count_views'.json'

    if [ $vdb_count -gt 1 ]
    then
      dest_filename='vdb/RTMP_monitoring_('$count_views'_scenes,part_'$k','$lang').json'
    else
      dest_filename='vdb/RTMP_monitoring_('$count_views'_scenes,'$lang').json'
    fi
    if [ -d 'vdb' ]
    then
      cp $template_filename $dest_filename
    fi
    if [ $vdb_count -gt 1 ]
    then
      sed -i 's/RTMP monitoring/RTMP monitoring ('$count_views' scenes, part '$k', '$lang')/g' $dest_filename
      sed -i 's/A-Stream 1-25/RTMP monitoring ('$count_views' scenes, part '$k', '$lang')/g' $dest_filename
    else
      sed -i 's/RTMP monitoring/RTMP monitoring ('$count_views' scenes, '$lang')/g' $dest_filename
      sed -i 's/A-Stream 1-25/RTMP monitoring ('$count_views' scenes, '$lang')/g' $dest_filename
    fi
    for (( i=1; i <= $count_views; i++ ))
    do
      index=$((($k-1)*$count_views+$i-1))
      if [ $index -lt ${#sources_array[*]} ]
      then
        param='lang_'$lang'[${lang_array[$index],,}]'
#        echo "${lang_array[$index]} (${instance[$index]},${!param}) - ${sources_array[$index]}"
        if [ $i -lt 10 ]
        then
          sed -i 's/0'$i'lang/'${lang_array[$index]}' ('${instance[$index]}', '${!param}')/g' $dest_filename
          sed -i 's/0'$i' lang/'${lang_array[$index]}'/g' $dest_filename
          sed -i 's/0'$i' RTMP/'${lang_array[$index]}'/g' $dest_filename
          sed -i 's!0'$i'rtmp!'${sources_array[$index]}'!g' $dest_filename
        else
          sed -i 's/'$i'lang/'${lang_array[$index]}' ('${instance[$index]}', '${!param}')/g' $dest_filename
          sed -i 's/'$i' lang/'${lang_array[$index]}'/g' $dest_filename
          sed -i 's/'$i' RTMP/'${lang_array[$index]}'/g' $dest_filename
          sed -i 's!'$i'rtmp!'${sources_array[$index]}'!g' $dest_filename
        fi
      fi

#      lang_full=$(echo ${!param} | sed 's/\s[^$]/\\&/g')
#      echo $lang_full
	  
    done
  done
}

# Display help
function help() {
  echo "Usage: ./vdbcs.sh [OPTION]
   Script to configure scenes for viewing RTMP streams in OBS. This script is
intended for creating video dashboards for: 1, 4 (2x2), 9 (3x3), 16 (4x4) and
25 (5x5) video sources.
   By default, the script creates a video dashboard for 25 (5x5) video sources.

Mandatory arguments to long options are mandatory for short options too.
              r, -r  display notes in Russian
        c, -c, -csv  use CSV file as data source
                  1  creating a video dashboard for one video sources
                  4  creating a video dashboard for four (2x2) video sources
                  9  creating a video dashboard for nine (3x3) video sources
                 16  creating a video dashboard for sixteen (4x4) video sources
      h, -h, --help  display this help and exit"
}

if [ $# -gt 0 ]
then
  while [ $# -gt 0 ]
  do
    case $1 in
      r | -r) lang='rus';;
      c | -c | -csv) slf='csv';;
      1 ) count_views=1;;
      4 ) count_views=4;;
      9 ) count_views=9;;
      16 ) count_views=16;;
      h | -h | --help) help; exit 1;;
      *) help; exit 1;;
    esac
    shift
  done
fi
case $slf in
  txt ) get_sources_from_txt;;
  csv ) get_sources_from_csv;;
esac
create_vdb

end_time=$(date +%s%N)
runtime=$((($end_time-$start_time)/1000000))
echo "Execution time - "$runtime" milliseconds"

}

exit 1