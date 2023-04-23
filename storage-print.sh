#!/bin/zsh

df -h | grep '^/dev' | grep -v 'loop' | grep -v efi |while read DEVICE SIZE USED FREE PERCENT MOUNT
do
  PERC=${PERCENT%?}
  if [ $PERC -lt 10 ]
  then
    PERCENT="  $PERC"
  elif [ $PERC -lt 60 ]
  then
    PERCENT=" $PERC"
  elif [ $PERC -lt 100 ]
  then
    PERCENT=" \${color2}$PERC\${color}"
  else
    PERCENT="$PERC"
  fi
#  echo "$MOUNT\${goto 200}$USED\${goto 270}$PERCENT\${alignr}$SIZE"
  echo "$MOUNT\${goto 200}$PERC% \${goto 230}\${execbar 7,85 echo $PERC}\${alignr} $USED/$SIZE"
done

