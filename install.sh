#!/bin/bash -
#===============================================================================
#
#          FILE:  install.sh
#
#         USAGE:  ./install.sh
#
#   DESCRIPTION:
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Karl Zheng (), ZhengKarl#gmail.com
#       COMPANY: Meizu
#       CREATED: 2013年12月02日 20时03分52秒 CST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error



if [ ! -f ${HOME}/.vimrc ];then
    ln -s $(pwd)/.vimrc ${HOME}/.vimrc
fi

if [ ! -d ${HOME}/.vim ];then
    ln -s $(pwd)/.vim ${HOME}/.vim
fi
