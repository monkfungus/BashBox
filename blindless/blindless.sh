#!/bin/bash
# for to set brightness

# if more than one argument passed
if [ $# -gt 1 ]; then

	echo "pls only singular argumente"
	exit 1

fi


brightnessFile="$HOME/.brightness"
oldBrightness=$(cat "$brightnessFile")


# if no arguments passed set brightness to default
if [ $# -eq 0 ]; then

	xrandr --output LVDS-1 --brightness 1

	# safe new brightness to file
	echo "1" > "$brightnessFile"

	exit 1

fi

# check if passed argument might be too high
if [ "$(bc <<< "$1 > 1")" -eq 1 ]; then

	# set brightness
	xrandr --output LVDS-1 --brightness $1

	printf "Requested brightness much high, press y to keep, any other key to revert. Reverting in"
	
	count=3
	
	while [ $count -gt 0 ]; do

		printf " $count"

		# read a single character from terminal and pass to response,
		# waiting one second betwen, while hiding the input and allowing
		# the input to be raw (key strokes allowed)
		if read -n1 -t1 -r -s response ; then

			if [ "$response" = "y" ]; then

				# safe new brightness to file
				echo $1 > "$brightnessFile"

				echo
				exit 1

			else

				# revert to original brightness
				xrandr --output LVDS-1 --brightness $oldBrightness
				echo
				exit 1

			fi
		fi

		# decrement count
		count=$(( count - 1 ))
		
	# exit while
	done 

	# revert to original brightness at end of count
	xrandr --output LVDS-1 --brightness $oldBrightness
	echo
	exit 1

# check if passed argument might be too low
elif [ "$(bc <<< "$1 < 0.1")" -eq 1 ]; then

	# set brightness
	xrandr --output LVDS-1 --brightness $1

	printf "Requested brightness much high, press y to keep, any other key to revert. Reverting in"
	
	count=3
	
	while [ $count -gt 0 ]; do

		printf " $count"

		# read a single character from terminal and pass to response,
		# waiting one second betwen, while hiding the input and allowing
		# the input to be raw (key strokes allowed)
		if read -n1 -t1 -r -s response ; then

			if [ "$response" = "y" ]; then

				# safe new brightness to file
				echo $1 > "$brightnessFile"
				
				echo
				exit 1

			else

				# revert to original brightness
				xrandr --output LVDS-1 --brightness $oldBrightness
				echo
				exit 1

			fi
		fi

		# decrement count
		count=$(( count - 1 ))
		
	# exit while
	done 

	# revert to original brightness at end of count
	xrandr --output LVDS-1 --brightness $oldBrightness
	echo
	exit 1

# passed argument must be safely between limits, so set as brightness
else

	xrandr --output LVDS-1 --brightness $1	

	# safe new brightness to file
	echo $1 > "$brightnessFile"

	exit 1
				
fi
