#!/bin/bash

T=/home/chunchenhsu/work/Linux-Server-Side-Swift-Benchmarking
executables=( KituraPress PerfectPress VaporPress ZewoPress )
instances=( 1 1 1 10 )

# build arguments for blog
make_argument() {
    type=$1
    local str=""
    let n=${#executables[@]}-1
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

export DRIVER=wrk
export ITERATIONS=5
export DURATION=60
export CPUS=0,1,2,3,4,5,6,7
export CLIENT=razorbill

connections=( 175 175 350 175 )
export URL=http://swiftx86:8090/blog
arguments=$(make_argument blog)
echo ./compare.sh $arguments
./compare.sh $arguments

connections=( 175 175 500 2000 )
export URL=http://razorbill:8090/json
arguments=$(make_argument json)
echo ./compare.sh $arguments
./compare.sh $arguments
