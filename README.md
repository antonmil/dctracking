# Discrete-Continuous Multi-target Tracking
This is a framework for multiple target tracking by discrete-continuous
energy minimization. The main idea was first described in this CVPR 2012 paper:

Discrete-Continuous Optimization for Multi-Target Tracking
A. Andriyenko, K. Schindler and S. Roth, In: CVPR 2012

and later extended to include exclusion and statistically derived energy potentials:

Detection- and Trajectory-Level Exclusion in Multiple Object Tracking
A. Milan, K. Schindler and S. Roth, In: CVPR 2013



# Installation
This section describes how to get dctracking running under Linux

Get the code
    hg clone https://bitbucket.org/amilan/dctracking    

    
    
## Prerequisites
You will need a few external software packages to run this code

- MOT utils
- GCO
- OpenGM2


### MOT utils
This package includes many useful functions for reading detections, displaying results, etc.
    cd external
    hg clone https://bitbucket.org/amilan/motutils
    cd ..


    
### GCO
Download and install GCO 3.0 from http://vision.csd.uwo.ca/code/
    cd external
    mkdir GCO
    cd GCO
    wget http://vision.csd.uwo.ca/code/gco-v3.0.zip
    unzip gco-v3.0.zip
    cd ../..
    
    


### OpenGM2
For inference with submodular energies, you will need to install the OpenGM2 framework.
In particular, you should download and build the code with QPBO and/or TRW-S support.
    cd external
    git clone https://github.com/opengm/opengm.git
    cd opengm    
    cd src/external/patches/QPBO
    sh patchQPBO-v1.3.sh
    cd ../TRWS/
    sh patchTRWS-v1.3.sh     
    cd ../../../..    
    mkdir BUILD
    cd BUILD    
    cmake .. -DWITH_QPBO=ON -DWITH_TRWS=ON -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX:PATH=..
    make -j4    
    make install
    cd ../..
      
    
Please refer to the [OpenGM website](http://hci.iwr.uni-heidelberg.de/opengm2/) 
for further instructions.


## Compiling
Now fire up MATLAB. Note that it is assumed that you have a c++ mex compiler configured.

### MEX
To speed up things, you should compile the extensive energy components computations
    compileMex

It is possible to switch off mex calls by setting opt.mex=0 in "getDCOptions.n".
But this is not recommended.


### GCO
If the binaries for your OS are not included you should compile GCO 
    cd external/GCO/matlab
    GCO_UnitTest
    cd ../..

### OpenGM Bindings
    cd opengm
    compileOGM
    cd ..

    
# Running
Now all should be set to run the tracker




Please do not forget to cite our work if you end up using this code:

    @inproceedings{Milan:2013:DTE,
	    Author = {Anton Milan and Konrad Schindler and Stefan Roth},
	    Booktitle = {CVPR},
	    Title = {Detection- and Trajectory-Level Exclusion in Multiple Object Tracking},
	    Year = {2013}
    }