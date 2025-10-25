#!/bin/bash
#Scripts to automatize P1 Simplescalar simulation
#Needed simplescalar sim-outorder at ../../simplesim-3.0_acx2/
#and benchmarks folders at ../benchmarks/

#Input variables
max_inst=$1
ctrl_param=$2
#ctrl_param="\\${ctrl_param}\\b"
echo "$ctrl_param"
sim_type=$3
echo "$sim_type"

#Data variables
ipcs=()

if (($# < 4)); then
	echo "./simulate [max_iter] [control_param] [sim_type] [config_file1] [config_file2] ..." >&2
	exit
fi

echo $1

echo -n "applu;art;gzip;mesa;twolf"

i=0
for config_file in $@; do
			
	((i++))
	if ((i <= 2)); then
		continue
	fi

	#APPLU
	ipcs+=($(../../simplesim-3.0_acx2/"$sim_type" -config $config_file -fastfwd 100000000 -max:inst "$max_inst" ../benchmarks/applu/exe/applu.exe < ../benchmarks/applu/data/ref/applu.in 2>&1 | grep "$ctrl_param" | awk '{print $2}'))

	#ART
	ipcs+=($(../../simplesim-3.0_acx2/"$sim_type" -config $config_file -fastfwd 100000000 -max:inst "$max_inst" ../benchmarks/art/exe/art.exe -scanfile ../benchmarks/art/data/ref/c756hel.in -trainfile1 ../benchmarks/art/data/ref/a10.img -trainfile2 ../benchmarks/art/data/ref/hc.img  -stride 2 -startx 110 -starty 200 -endx 160 -endy 240 -objects 10 2>&1 | grep "$ctrl_param" | awk '{print $2}'))

	#GZIP
	ipcs+=($(../../simplesim-3.0_acx2/"$sim_type" -config $config_file -fastfwd 100000000 -max:inst "$max_inst" ../benchmarks/gzip/exe/gzip.exe ../benchmarks/gzip/data/ref/input.source 60 2>&1 | grep "$ctrl_param" | awk '{print $2}'))

	#MESA
	ipcs+=($(../../simplesim-3.0_acx2/"$sim_type" -config $config_file -fastfwd 100000000 -max:inst "$max_inst" ../benchmarks/mesa/exe/mesa.exe -frames 1000 -meshfile ../benchmarks/mesa/data/ref/mesa.in -ppmfile ../benchmarks/mesa/data/ref/mesa.ppm 2>&1 | grep "$ctrl_param" | awk '{print $2}'))
	

	#TWOLF
	ipcs+=($(../../simplesim-3.0_acx2/"$sim_type" -config $config_file -fastfwd 100000000 -max:inst "$max_inst" ../benchmarks/twolf/exe/twolf.exe ../benchmarks/twolf/data/ref/ref 2>&1 | grep "$ctrl_param" | awk '{print $2}'))


	echo "${ipcs[@]}" | tr ' ' ';' 
	ipcs=()
done


