# This script is used for building for conda-forge
#

# github releases are not under version control so pass correct version as argument to script
version=${1}

PREFIX=${PREFIX:-${CONDA_PREFIX}}
BUILD=cmake-build
echo PREFIX=${PREFIX}
echo CONDA_PREFIX=${CONDA_PREFIX}

if [ -x "$(command -v $CONDA_PREFIX/bin/cc)" ]
then
    CC=$CONDA_PREFIX/bin/cc
fi

if [ -x "$(command -v $CONDA_PREFIX/bin/cpp)" ]
then
    CXX=$CONDA_PREFIX/bin/c++
fi

echo '__version__ = "'${version}'"' > pysjef/_version.py

mkdir -p pysjef/$BUILD
cd pysjef/$BUILD
if [ -f "install_manifest.txt" ]
then
    xargs rm < "install_manifest.txt"
fi
if [ -f "CMakeCache.txt" ]
then
    rm CMakeCache.txt
fi
cmake ../.. -DCMAKE_INSTALL_PREFIX=$PREFIX -DBUILD_TESTS=OFF -DBUILD_PROGRAM=OFF || { echo 'cmake build failed' ; exit 1; }
cmake --build . -t install || { echo 'make install failed' ; exit 1; }
cd ../

PREFIX=$PREFIX python -m pip install -e . 
