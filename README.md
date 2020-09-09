## Test result
IT_Junior_task01_with_restrictions_v04

#### Author: Boris Belyaev belbor1@gmail.com

#### Description
In dockerfile you find contauiner based on ubuntu 18.04, which includes speсial  bioinformatic programs: 
samtools, biobambam2 and also requaired libraries and tools.

#### Installation
To build image on your host you should call: 
    
    docker build https://github.com/localghost32/test.git#master 
   
Dockerfile will be downloaded from master branch of repository:    
    
    https://github.com/localghost32/test.git
