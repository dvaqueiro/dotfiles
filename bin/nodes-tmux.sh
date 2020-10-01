#!/bin/bash

NUM_PANES=0;
for i in [ "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30" "31" "32" "33" ] ; do
  if (( $NUM_PANES < 12 )) ; then
    tmux splitw "ssh node$i -t 'htop'";
    tmux select-layout tiled;
    NUM_PANES=$(($NUM_PANES+1));
  else
    NUM_PANES=0;
     tmux new-window -c "ssh node$i" ;
  fi;
done
