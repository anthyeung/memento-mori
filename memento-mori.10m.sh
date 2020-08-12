#!/usr/bin/env bash

# Progress Bar (inspired by Progress OS X)
# by Anthony Yeung (http://github.com/anthyeung)
#
# <bitbar.title>Memento Mori</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Anthony Yeung</bitbar.author>
# <bitbar.author.github>Anthony Yeung</bitbar.author.github>
# <bitbar.desc>Memento Mori. Remember You Will Die.</bitbar.desc>
# <bitbar.image>https://user-images.githubusercontent.com/5108459/43047918-c946f6bc-8de7-11e8-940a-036f44087b92.jpg</bitbar.image>
# <bitbar.dependencies>bash</bitbar.dependencies>
# <bitbar.abouturl>https://gist.github.com/mucahit/0bd2ace80ded22328d0c638715a4911b</bitbar.abouturl>

# -------------------------------------- #
# LANGUAGE SETTING
# -------------------------------------- #
export LANG="${LANG:-en_US.UTF-8}"

# -------------------------------------- #
# CUTOMIZE HERE
# -------------------------------------- #
# Your Year of Birth (YYYY) #
year=1990
# Your Month of Birth (MM) #
month=09
# Your Life Expectancy (years) #
lifeexpectancyy=80

# -------------------------------------- #
# Dark Mode Check
# -------------------------------------- #
BitBarDarkMode=${BitBarDarkMode}
if [ "$BitBarDarkMode" ]; then
  # OSX has Dark Mode enabled.
  bitbar="size=14 color=white"
  bitbarsmall="size=12 color=white"
else
  # OSX does not have Dark Mode
  bitbar="size=14 color=black"
  bitbarsmall="size=12 color=black"
fi

# -------------------------------------- #
# BitBar Settings
# -------------------------------------- #
width=15
fill_char="▄"
empty_char="▁"
padding="size=1"
now=$(date +%s)
bitbarhide="dropdown=false"

# -------------------------------------- #
# Month/Year to Second Conversion
# -------------------------------------- #
secondspermonth=2592000
secondsperyear=31536000

# -------------------------------------- #
# Current Year and Month
# -------------------------------------- #
yearnow=$(date '+%Y')
monthnow=$(date '+%m')

# calculate age in years and month
# take current month and subtract birth month
agem=$((10#$monthnow-10#$month))
# if result is less than zero
if [ $agem -lt 0 ] ; then
# then +12 months to value to correct for negative month
   agem=$((10#$monthnow-10#$month+12))
# then -1 year to value to correct for adding extra 12 months
   agey=$(($yearnow-$year-1))
else
# leave month alone
   agem=$((10#$monthnow-10#$month))
# leave year alone
   agey=$(($yearnow-$year))
fi

# -------------------------------------- #
# Life Expectancy
# -------------------------------------- #
# lifeexpectancy in seconds
lifeexpectancyseconds=`expr $lifeexpectancyy '*' $secondsperyear`
# then convert all to lifetime seconds
ageseconds=`expr $agey '*' $secondsperyear + $agem '*' $secondspermonth`
death=`expr $year + $lifeexpectancyy`
L_progress=$(
    echo "$ageseconds * 100 / $lifeexpectancyseconds" | bc -l
)

# -------------------------------------- #
# Year
# -------------------------------------- #
Y_start=$(date -j 01010000 +%s)
Y_end=$(date -jr "$Y_start" -v +1y +%s)
Y_progress=$(
    echo "($now - $Y_start) * 100 / ($Y_end - $Y_start)" | bc -l
)

# -------------------------------------- #
# Month
# -------------------------------------- #
m_start=$(date -j "$(date +%m)010000" +%s)
m_end=$(date -jr "$m_start" -v +1m +%s)
m_progress=$(
    echo "($now - $m_start) * 100 / ($m_end - $m_start)" | bc -l
)

# -------------------------------------- #
# Day
# -------------------------------------- #
d_start=$(date -j "$(date +%m%d)0000" +%s)
d_end=$(date -jr "$d_start" -v +1d +%s)
d_progress=$(
    echo "($now - $d_start) * 100 / ($d_end - $d_start)" | bc -l
)
# -------------------------------------- #
# % Rounding
# -------------------------------------- #
round() { printf %.0f "$1"; }

# -------------------------------------- #
# Progress Bar
# -------------------------------------- #
progress() {
    filled=$(round "$(echo "$1 * $width / 100" | bc -l)")
    empty=$((width - filled))
    # repeat the characters using printf
    printf "$fill_char%0.s" $(seq "$filled")
    printf "$empty_char%0.s" $(seq "$empty")
}

# -------------------------------------- #
# Grammar and Semantics
# -------------------------------------- #
# function for including, or pluralizing month vs. months
monthdisplay() {
if [ $agem -eq 0 ] ; then
  echo ""
elif [ $agem -eq 1 ] ; then
  echo "years, $agem month"
else
  echo "years, $agem months"
fi
}

# -------------------------------------- #
# Generate BitBar Menu
# -------------------------------------- #
# cycling information on menubar
echo "Day: $(round "$d_progress")% | $bitbarhide"
echo ":hatching_chick: Life: $(round "$L_progress")% |$bitbarhide"
echo ---

# current day
echo ":calendar: `date '+%A %B %d, %Y'`"
echo ---

# at-glance-demographics
echo ":boy: Age: $agey $(monthdisplay) | $bitbarsmall"
echo ":crystal_ball: Life Expectancy: $lifeexpectancyy years | $bitbarsmall"
echo ":skull: Year of Death: $death | $bitbarsmall"
echo ---

# day + progress bar
echo "x | $padding"
echo "$day Day: $(round "$d_progress")% | $bitbar"
echo "$(progress "$d_progress")      | $bitbar"

# month + progress bar
echo "x | $padding"
echo "Month: $(round "$m_progress")%   | $bitbar"
echo "$(progress "$m_progress")        | $bitbar"

# year + progress bar"
echo "x | $padding"
echo "Year: $(round "$Y_progress")%   | $bitbar"
echo "$(progress "$Y_progress")       | $bitbar"

# life + progress bar"
echo "x | $padding"
echo ":hatching_chick: Life: $(round "$L_progress")%   | $bitbar"
echo "$(progress "$L_progress")       | $bitbar"					