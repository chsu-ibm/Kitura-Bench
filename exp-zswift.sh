#!/bin/bash

T=/home/chsu/work/Linux-Server-Side-Swift-Benchmarking
executables=( KituraPress PerfectPress VaporPress ZewoPress )
instances=( 1 1 1 6 )

let n=${#executables[@]}-1

# build arguments for blog
make_argument() {
    type=$1
    local str=""
    for i in $(seq 0 $n); do
        name=${executables[$i]}
        port=${ports[$i]}
        instance=${instances[$i]}
        connection=${connections[$i]}
        executable=$T/$name/.build/release/$name
        str="$str $executable,$instance,$connection"
    done
    echo $str
}

export DRIVER=ab
export CLIENTS=200
export ITERATIONS=5
export DURATION=60
export CPUS=0,1,2,3
export CLIENT=9.2.98.73

connections=( 50 50 50 500 )
export URL=http://9.2.98.148:8090/blog
arguments=$(make_argument blog)
echo ./compare.sh $arguments
./compare.sh $arguments

connections=( 50 200 50 500 )
export URL=http://9.2.98.148:8090/json
arguments=$(make_argument json)
echo ./compare.sh $arguments
./compare.sh $arguments
