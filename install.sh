#!/bin/bash

if [ -f ${HOME}/.vimrc ];then
    ln -s ${HOME}/.vim/.vimrc ${HOME}/.vimrc 
fi
