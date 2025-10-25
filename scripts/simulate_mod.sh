#!/bin/bash
#Scripts to automatize P1 Simplescalar simulation
#Needed simplescalar sim-outorder at ../../simplesim-3.0_acx2/
#and benchmarks folders at ../benchmarks/

#Input variables
max_inst=$1
ctrl_param1="\\.bpred_dir_rate\\b"
ctrl_param2="sim_IPC"
sim_path=$2
echo "Max instr: $max_inst"
echo "Sim path: $sim_path"
echo "Param control: $ctrl_param1"
echo "Param control: $ctrl_param2"

#Data variables
result1=()
result2=()

if (($# < 3)); then
	echo "./simulate [max_iter] [sim_path] [config_file1] [config_file2] ..." >&2
	exit
fi


echo -e "applu;art;gzip;mesa;twolf\tapplu;art;gzip;mesa;twolf"

i=0
for config_file in $@; do
			
	((i++))
	if ((i <= 2)); then
		continue
	fi

	#APPLU
	res=$("$sim_path" -config $config_file -fastfwd 100000000 -max:inst "$max_inst" ../benchmarks/applu/exe/applu.exe < ../benchmarks/applu/data/ref/applu.in 2>&1)
	result1+=($(echo -e "$res" | grep "$ctrl_param1" | awk '{print $2}'))
	result2+=($(echo -e "$res" | grep "$ctrl_param2" | awk '{print $2}'))

	#ART
	res=$("$sim_path" -config $config_file -fastfwd 100000000 -max:inst "$max_inst" ../benchmarks/art/exe/art.exe -scanfile ../benchmarks/art/data/ref/c756hel.in -trainfile1 ../benchmarks/art/data/ref/a10.img -trainfile2 ../benchmarks/art/data/ref/hc.img  -stride 2 -startx 110 -starty 200 -endx 160 -endy 240 -objects 10 2>&1)
	result1+=($(echo -e "$res" | grep "$ctrl_param1" | awk '{print $2}'))
	result2+=($(echo -e "$res" | grep "$ctrl_param2" | awk '{print $2}'))

	#GZIP
	res=$("$sim_path" -config $config_file -fastfwd 100000000 -max:inst "$max_inst" ../benchmarks/gzip/exe/gzip.exe ../benchmarks/gzip/data/ref/input.source 60 2>&1)
	result1+=($(echo -e "$res" | grep "$ctrl_param1" | awk '{print $2}'))
	result2+=($(echo -e "$res" | grep "$ctrl_param2" | awk '{print $2}'))

	#MESA
	res=$("$sim_path" -config $config_file -fastfwd 100000000 -max:inst "$max_inst" ../benchmarks/mesa/exe/mesa.exe -frames 1000 -meshfile ../benchmarks/mesa/data/ref/mesa.in -ppmfile ../benchmarks/mesa/data/ref/mesa.ppm 2>&1)
	result1+=($(echo -e "$res" | grep "$ctrl_param1" | awk '{print $2}'))
	result2+=($(echo -e "$res" | grep "$ctrl_param2" | awk '{print $2}'))
	

	#TWOLF
	res=$("$sim_path" -config $config_file -fastfwd 100000000 -max:inst "$max_inst" ../benchmarks/twolf/exe/twolf.exe ../benchmarks/twolf/data/ref/ref 2>&1)
	result1+=($(echo -e "$res" | grep "$ctrl_param1" | awk '{print $2}'))
	result2+=($(echo -e "$res" | grep "$ctrl_param2" | awk '{print $2}'))


	echo -e "${result1[@]}\t${result2[@]}" | tr ' ' ';' 
	result1=()
	result2=()
done


