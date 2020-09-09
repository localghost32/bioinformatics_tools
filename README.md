## Test result
IT_Junior_task01_with_restrictions_v04

#### Author: Boris Belyaev belbor1@gmail.com

#### Description
In [dockerfile](dockerfile) you find container based on ubuntu 18.04, which includes speсial  bioinformatic programs: 
samtools, biobambam2 and also requaired libraries and tools.

#### Dependencies
You must have [Docker](https://docs.docker.com/get-docker/) to build and run image.

#### Installation
To build image on your host you should call: 
    
    docker build https://github.com/localghost32/test.git#master 
   
Dockerfile will be downloaded from master branch of repository:    
    
    https://github.com/localghost32/test.git

You can choose tag for image during building. It will create convenience:    
    
    docker build https://github.com/localghost32/test.git#master -t <your_tag>

For more information see:    
    
    docker build --help
    
To run container use:    
    
    docker run -it <container_id or your_tag> 
