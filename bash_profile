#!/bin/bash

if [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi

. ~/.bashrc


