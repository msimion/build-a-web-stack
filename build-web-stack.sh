#!/bin/bash

APR_VERSION="1.7.0"
EXPAT_VERSION="2.2.10"
APRUTIL_VERSION="1.6.1"
CMAKE_VERSION="3.19.4"
# GCC_VERSION="8.2.0"
LIBPNG_VERSION="1.6.37"
LIBZIP_VERSION="1.7.3"
ZLIB_VERSION="1.2.11"
LIBICONV_VERSION="1.16"
PCRE_VERSION="8.44"
OPENSSL_VERSION="1.1.1j"
ONIGURUMA_VERSION="6.9.6"
HTTPD_VERSION="2.4.46"
PHP_VERSION="7.4.16"
MYSQL_VERSION="5.7.33"
LIBCURL_VERSION="7.69.1"
XDEBUG_VERSION="3.0.3"

SRC_FILE_EXT="tar.gz"
BASE_DIR=`pwd`

STAGE_DIR="${BASE_DIR}/stage"
STACK_DIR="${BASE_DIR}/stack"
LIB_DIR="${STACK_DIR}/lib"

CMAKE_SRC_DIR="https://github.com/Kitware/CMake/releases/download/v"${CMAKE_VERSION}
CMAKE_SRC_PKG_NAME="cmake-${CMAKE_VERSION}"
CMAKE_HOME="${LIB_DIR}/${CMAKE_SRC_PKG_NAME}"

ONIGURUMA_SRC_DIR="https://github.com/kkos/oniguruma/releases/download/v${ONIGURUMA_VERSION}"
ONIGURUMA_SRC_PKG_NAME="onig-${ONIGURUMA_VERSION}"
ONIGURUMA_HOME="${LIB_DIR}/${ONIGURUMA_SRC_PKG_NAME}"

OPENSSL_SRC_DIR="https://www.openssl.org/source"
OPENSSL_SRC_PKG_NAME="openssl-${OPENSSL_VERSION}"
OPENSSL_HOME="${LIB_DIR}/${OPENSSL_SRC_PKG_NAME}"

LIBPNG_SRC_DIR="http://prdownloads.sourceforge.net/libpng"
LIBPNG_SRC_PKG_NAME="libpng-${LIBPNG_VERSION}"
LIBPNG_HOME="${LIB_DIR}/${LIBPNG_SRC_PKG_NAME}"
LIBPNG_SUFFIX="?download"

LIBZIP_SRC_DIR="https://libzip.org/download"
LIBZIP_SRC_PKG_NAME="libzip-${LIBZIP_VERSION}"
LIBZIP_HOME="${LIB_DIR}/${LIBZIP_SRC_PKG_NAME}"

ZLIB_SRC_DIR="http://prdownloads.sourceforge.net/libpng"
ZLIB_SRC_PKG_NAME="zlib-${ZLIB_VERSION}"
ZLIB_HOME="${LIB_DIR}/${ZLIB_SRC_PKG_NAME}"
ZLIB_SUFFIX="?download"

LIBICONV_SRC_DIR="https://ftp.gnu.org/pub/gnu/libiconv"
LIBICONV_SRC_PKG_NAME="libiconv-${LIBICONV_VERSION}"
LIBICONV_HOME="${LIB_DIR}/${LIBICONV_SRC_PKG_NAME}"

EXPAT_SRC_DIR="https://github.com/libexpat/libexpat/releases/download/R_2_2_9"
EXPAT_SRC_PKG_NAME="expat-${EXPAT_VERSION}"
EXPAT_HOME="${LIB_DIR}/${EXPAT_SRC_PKG_NAME}"

APR_SRC_DIR="https://www-eu.apache.org/dist/apr"
APR_SRC_PKG_NAME="apr-${APR_VERSION}"
APR_HOME="${LIB_DIR}/${APR_SRC_PKG_NAME}"

APRUTIL_SRC_DIR="https://www-eu.apache.org/dist/apr"
APRUTIL_SRC_PKG_NAME="apr-util-${APRUTIL_VERSION}"
APRUTIL_HOME="${LIB_DIR}/${APRUTIL_SRC_PKG_NAME}"

PCRE_SRC_DIR="https://ftp.pcre.org/pub/pcre"
PCRE_SRC_PKG_NAME="pcre-${PCRE_VERSION}"
PCRE_HOME="${LIB_DIR}/${PCRE_SRC_PKG_NAME}"

HTTPD_LISTEN_PORT="7890"
HTTPD_SRC_DIR="https://www-eu.apache.org/dist/httpd"
HTTPD_SRC_PKG_NAME="httpd-${HTTPD_VERSION}"
HTTPD_HOME="${STACK_DIR}/${HTTPD_SRC_PKG_NAME}"

MYSQL_SRC_DIR="https://dev.mysql.com/get/Downloads/MySQL-5.7"
MYSQL_SRC_PKG_NAME="mysql-boost-${MYSQL_VERSION}"
MYSQL_STAGE_DIR="${MYSQL_SRC_PKG_NAME:0:6}${MYSQL_SRC_PKG_NAME:12}"
MYSQL_HOME="${STACK_DIR}/${MYSQL_SRC_PKG_NAME:0:6}${MYSQL_SRC_PKG_NAME:12}"

LIBCURL_SRC_DIR="https://curl.haxx.se/download"
LIBCURL_SRC_PKG_NAME="curl-${LIBCURL_VERSION}"
LIBCURL_HOME="${LIB_DIR}/${LIBCURL_SRC_PKG_NAME}"

PHP_SRC_DIR="http://de2.php.net/get"
PHP_SRC_PKG_NAME="php-${PHP_VERSION}"
PHP_HOME="${STACK_DIR}/${PHP_SRC_PKG_NAME}"
PHP_SUFFIX="from/this/mirror"

XDEBUG_SRC_DIR="https://xdebug.org/files"
XDEBUG_SRC_PKG_NAME="xdebug-${XDEBUG_VERSION}"
XDEBUG_HOME="${LIB_DIR}/${XDEBUG_SRC_PKG_NAME}"

PATH="${PATH}:${CMAKE_HOME}/bin"

export PKG_CONFIG_PATH=$ONIGURUMA_HOME/lib/pkgconfig:$ZLIB_HOME/lib/pkgconfig:$OPENSSL_HOME/lib/pkgconfig:$LIBCURL_HOME/lib/pkgconfig:$LIBPNG_HOME/lib/pkgconfig:$PKG_CONFIG_PATH

DO_CMAKE=0 ; DO_OPENSSL=0 ; DO_LIBPNG=0 ; DO_ZLIB=0 ; DO_LIBICONV=0
DO_HTTPD=0 ; DO_MYSQL=0 ; DO_PHP=0 ; DO_LIBZIP=0 ; DO_ONIGURUMA=0
DO_LIBCURL=0 ; DO_XDEBUG=0

INVALID_PARAMS=

usage() {
  echo "Usage: $0 [cmake] [openssl] [libpng] [libzip] [zlib] [libiconv] [httpd] [mysql] [oniguruma] [libcurl] [php] [xdebug]"
}

if [[ -z "$@" ]]; then
  echo "Invoked with no parameters."
  usage
  exit 1
fi

for param in "$@" ; do
  case "$param" in
    "cmake" )
      DO_CMAKE=1
      ;;

    "openssl" )
      DO_OPENSSL=1
      ;;

    "libpng" )
      DO_LIBPNG=1
      ;;

    "libzip" )
      DO_LIBZIP=1
      ;;

    "zlib" )
      DO_ZLIB=1
      ;;

    "libiconv" )
      DO_LIBICONV=1
      ;;

    "httpd" )
      DO_HTTPD=1
      ;;

    "mysql" )
      DO_MYSQL=1
      ;;
      
    "oniguruma" )
      DO_ONIGURUMA=1
      ;;

    "php" )
      DO_PHP=1
      ;;
      
    "libcurl" )
      DO_LIBCURL=1
      ;;
      
    "xdebug" )
      DO_XDEBUG=1
      ;;

    * )
      INVALID_PARAMS="${INVALID_PARAMS} $param"
  esac
done

if [[ ! -z "${INVALID_PARAMS}" ]]; then
  echo "Invalid parameter(s):${INVALID_PARAMS}"
  usage
  exit 1
fi

mkdir -p ${STAGE_DIR}
cd ${STAGE_DIR}

# #
# # GCC
# #
# do_gcc() {
#   GCC_SRC_PKG_NAME="gcc-${GCC_VERSION}"
#   GCC_SRC_DIR="http://mirror.koddos.net/gcc/releases/${GCC_SRC_PKG_NAME}"
#   GCC_HOME="${LIB_DIR}/${GCC_SRC_PKG_NAME}"
#
#   if [ ! -e ${STAGE_DIR}/${GCC_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
#     curl -L -o ${GCC_SRC_PKG_NAME}.${SRC_FILE_EXT} \
#       ${GCC_SRC_DIR}/${GCC_SRC_PKG_NAME}.${SRC_FILE_EXT}
#   fi
#
#   rm -rf ${GCC_SRC_PKG_NAME} ${GCC_HOME}
#   tar xvf ${GCC_SRC_PKG_NAME}.${SRC_FILE_EXT}
#
#   cd ${GCC_SRC_PKG_NAME}
#   ./configure --prefix=${GCC_HOME}
#   make && make install
#
#   # cd .. && rm -rf ${GCC_SRC_PKG_NAME}*
#   cd ..
# }

#
# CMAKE
#
do_cmake() {
  export OPENSSL_ROOT_DIR=$OPENSSL_HOME
  
  if [ ! -e ${STAGE_DIR}/${CMAKE_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${CMAKE_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${CMAKE_SRC_DIR}/${CMAKE_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${CMAKE_SRC_PKG_NAME} ${CMAKE_HOME}
  tar xvf ${CMAKE_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${CMAKE_SRC_PKG_NAME}
  ./configure --prefix=${CMAKE_HOME}
  make && make install

  cd ..
}

#
# ONIGURUMA
#
do_oniguruma() {
  if [ ! -e ${STAGE_DIR}/${ONIGURUMA_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${ONIGURUMA_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${ONIGURUMA_SRC_DIR}/${ONIGURUMA_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${ONIGURUMA_SRC_PKG_NAME} ${ONIGURUMA_HOME}
  tar xvf ${ONIGURUMA_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${ONIGURUMA_SRC_PKG_NAME}
  ./configure --prefix=${ONIGURUMA_HOME}
  make && make install

  cd ..
}

#
# OPENSSL
#
do_openssl() {
  if [ ! -e ${STAGE_DIR}/${OPENSSL_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${OPENSSL_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${OPENSSL_SRC_DIR}/${OPENSSL_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${OPENSSL_SRC_PKG_NAME} ${OPENSSL_HOME}
  tar xvf ${OPENSSL_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${OPENSSL_SRC_PKG_NAME}
  ./config --prefix=${OPENSSL_HOME} \
    --openssldir=${OPENSSL_HOME}
  make && make install_sw

  if [ $? !=0 ]
  then
    echo "the last command did not finish successfully. exiting."
    exit
  fi

  cd ..
}

#
# LIBPNG
#
do_libpng() {
  export LDFLAGS="-L${ZLIB_HOME}/lib"
  export CPPFLAGS="-I${ZLIB_HOME}/include"

  if [ ! -e ${STAGE_DIR}/${LIBPNG_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${LIBPNG_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${LIBPNG_SRC_DIR}/${LIBPNG_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${LIBPNG_SRC_PKG_NAME} ${LIBPNG_HOME}
  tar xvf ${LIBPNG_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${LIBPNG_SRC_PKG_NAME}
  ./configure --prefix=${LIBPNG_HOME}
  make && make install

  cd ..
}

#
# LIBZIP
#
do_libzip() {
  if [ ! -e ${STAGE_DIR}/${LIBZIP_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${LIBZIP_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${LIBZIP_SRC_DIR}/${LIBZIP_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${LIBZIP_SRC_PKG_NAME} ${LIBZIP_HOME}
  tar xvf ${LIBZIP_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${LIBZIP_SRC_PKG_NAME}
  mkdir bld && cd bld
  cmake .. -DCMAKE_INSTALL_PREFIX=${LIBZIP_HOME} \
    -DZLIB_LIBRARY=${ZLIB_HOME}/lib/libz.so \
    -DZLIB_INCLUDE_DIR=${ZLIB_HOME}/include
    # -DCMAKE_CXX_FLAGS="-lz"

  make && make install

  cd ..
}

#
# ZLIB
#
do_zlib() {
  if [ ! -e ${STAGE_DIR}/${ZLIB_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${ZLIB_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${ZLIB_SRC_DIR}/${ZLIB_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${ZLIB_SRC_PKG_NAME} ${ZLIB_HOME}
  tar xvf ${ZLIB_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${ZLIB_SRC_PKG_NAME}
  ./configure --prefix=${ZLIB_HOME}
  make && make install

  cd ..
}

#
# ICONV
#
do_libiconv() {
  if [ ! -e ${STAGE_DIR}/${LIBICONV_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${LIBICONV_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${LIBICONV_SRC_DIR}/${LIBICONV_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${LIBICONV_SRC_PKG_NAME} ${LIBICONV_HOME}
  tar xvf ${LIBICONV_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${LIBICONV_SRC_PKG_NAME}
  ./configure --prefix=${LIBICONV_HOME}
  make && make install

  cd ..
}

#
# EXPAT
#
do_expat() {
  if [ ! -e ${STAGE_DIR}/${EXPAT_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${EXPAT_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${EXPAT_SRC_DIR}/${EXPAT_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${EXPAT_SRC_PKG_NAME} ${EXPAT_HOME}
  tar xvf ${EXPAT_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${EXPAT_SRC_PKG_NAME}
  ./configure --prefix=${EXPAT_HOME}
  make && make install

  cd ..
}

#
# APR
#
do_apr() {
  if [ ! -e ${STAGE_DIR}/${APR_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${APR_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${APR_SRC_DIR}/${APR_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${APR_SRC_PKG_NAME} ${APR_HOME}
  tar xvf ${APR_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${APR_SRC_PKG_NAME}
  ./configure --prefix=${APR_HOME}
  make && make install

  cd ..
}

#
# APRUTIL
#
do_aprutil() {
  if [ ! -e ${STAGE_DIR}/${APRUTIL_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${APRUTIL_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${APRUTIL_SRC_DIR}/${APRUTIL_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${APRUTIL_SRC_PKG_NAME} ${APRUTIL_HOME}
  tar xvf ${APRUTIL_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${APRUTIL_SRC_PKG_NAME}
  ./configure --prefix=${APRUTIL_HOME} --with-apr=${APR_HOME} --with-expat=${EXPAT_HOME}
  make && make install

  cd ..
}

#
# PCRE
#
do_pcre() {
  if [ ! -e ${STAGE_DIR}/${PCRE_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${PCRE_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${PCRE_SRC_DIR}/${PCRE_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${PCRE_SRC_PKG_NAME} ${PCRE_HOME}
  tar xvf ${PCRE_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${PCRE_SRC_PKG_NAME}
  ./configure --prefix=${PCRE_HOME}
  make && make install

  cd ..
}

#
# HTTPD
#
do_httpd() {
  do_expat
  do_apr
  do_aprutil
  do_pcre

  if [ ! -e ${STAGE_DIR}/${HTTPD_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${HTTPD_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${HTTPD_SRC_DIR}/${HTTPD_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${HTTPD_SRC_PKG_NAME} ${HTTPD_HOME}
  tar xvf ${HTTPD_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${HTTPD_SRC_PKG_NAME}
  ./configure --prefix=${HTTPD_HOME} \
    --with-apr=${APR_HOME} \
    --with-apr-util=${APRUTIL_HOME} \
    --with-pcre=${PCRE_HOME} \
    --with-port=${HTTPD_LISTEN_PORT} \
    --enable-so \
    --enable-ssl
    # --enable-http2
  make && make install
  
  cd ${HTTPD_HOME}/conf
  mv httpd.conf httpd.conf.original
  ln -s ${STACK_DIR}/config/httpd/httpd.conf httpd.conf
  
  cd ${STAGE_DIR}
  # cd ..
}

#
# MYSQL
#
do_mysql() {
  if [ ! -e ${STAGE_DIR}/${MYSQL_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${MYSQL_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${MYSQL_SRC_DIR}/${MYSQL_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${MYSQL_STAGE_DIR} ${MYSQL_HOME}
  tar xvf ${MYSQL_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${MYSQL_STAGE_DIR}
  mkdir bld && cd bld
  cmake .. -DCMAKE_INSTALL_PREFIX=${MYSQL_HOME} \
      -DWITH_BOOST=${STAGE_DIR}/${MYSQL_STAGE_DIR}/boost \
      -DWITH_SSL=${OPENSSL_HOME}
  make && make install

  cd ../..
}

#
# PHP
#
# NOTE: must do XDEBUG manually after building PHP to regenerate php.ini
# NOTE: XDEBUG now runs automatically after php build is complete
#
do_php() {
  do_oniguruma
  
  if [ ! -e ${STAGE_DIR}/${PHP_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${PHP_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${PHP_SRC_DIR}/${PHP_SRC_PKG_NAME}.${SRC_FILE_EXT}/${PHP_SUFFIX}
  fi

  rm -rf ${PHP_SRC_PKG_NAME} ${PHP_HOME}
  tar xvf ${PHP_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${PHP_SRC_PKG_NAME}
  ./configure --prefix=${PHP_HOME} \
    --with-apxs2=${HTTPD_HOME}/bin/apxs \
    --with-mysqli \
    --with-pdo-mysql \
    --with-zlib=${ZLIB_HOME} \
    --with-openssl=${OPENSSL_HOME} \
    --with-iconv=${LIBICONV_HOME} \
    --enable-soap \
    --enable-mbstring \
    --enable-pcntl \
    --enable-intl \
    --with-curl \
    --enable-gd
  make && make install

  if [ $? != 0 ]
  then
    echo "*** ERR * the php build did not finish successfully. exiting ***"
    exit
  fi

  cd ..
  
  do_xdebug
}

#
# LIBCURL
#
do_libcurl() {
  if [ ! -e ${STAGE_DIR}/${LIBCURL_SRC_PKG_NAME}.${SRC_FILE_EXT} ]; then
    curl -L -o ${LIBCURL_SRC_PKG_NAME}.${SRC_FILE_EXT} \
      ${LIBCURL_SRC_DIR}/${LIBCURL_SRC_PKG_NAME}.${SRC_FILE_EXT}
  fi

  rm -rf ${LIBCURL_SRC_PKG_NAME} ${LIBCURL_HOME}
  tar xvf ${LIBCURL_SRC_PKG_NAME}.${SRC_FILE_EXT}

  cd ${LIBCURL_SRC_PKG_NAME}
  ./configure --prefix=${LIBCURL_HOME} --with-ssl=${OPENSSL_HOME}
  make && make install

  cd ..
}

#
# XDEBUG
#
do_xdebug() {
  if [ ! -e ${STAGE_DIR}/${XDEBUG_SRC_PKG_NAME}.tgz ]; then
    curl -L -o ${XDEBUG_SRC_PKG_NAME}.tgz \
      ${XDEBUG_SRC_DIR}/${XDEBUG_SRC_PKG_NAME}.tgz
  fi

  rm -rf ${XDEBUG_SRC_PKG_NAME} ${XDEBUG_HOME}
  tar xvf ${XDEBUG_SRC_PKG_NAME}.tgz

  cd ${XDEBUG_SRC_PKG_NAME}
  ${PHP_HOME}/bin/phpize
  ./configure --prefix=${XDEBUG_HOME} --with-php-config=${PHP_HOME}/bin/php-config
  make && make install

  cd ..
  
  echo "opcache.enable=1" > ${PHP_HOME}/lib/php.ini
  echo "zend_extension=opcache.so" >> ${PHP_HOME}/lib/php.ini
  echo "zend_extension=xdebug.so" >> ${PHP_HOME}/lib/php.ini
}

#
# The MAIN function
#
main() {
  # do_gcc
  
  if (( "$DO_OPENSSL")); then
    do_openssl
  fi

  if (( "$DO_CMAKE")); then
    do_cmake
  fi

  if (( "$DO_LIBPNG")); then
    do_libpng
  fi

  if (( "$DO_LIBZIP")); then
    do_libzip
  fi

  if (( "$DO_ZLIB")); then
    do_zlib
  fi

  if (( "$DO_LIBICONV")); then
    do_libiconv
  fi

  if (( "$DO_HTTPD")); then
    do_httpd
  fi

  if (( "$DO_MYSQL")); then
    do_mysql
  fi
  
  if (( "$DO_ONIGURUMA")); then
    do_oniguruma
  fi

  if (( "$DO_LIBCURL")); then
    do_libcurl
  fi

  if (( "$DO_PHP")); then
    do_php
  fi
  
  if (( "$DO_XDEBUG")); then
    do_xdebug
  fi
}

main
