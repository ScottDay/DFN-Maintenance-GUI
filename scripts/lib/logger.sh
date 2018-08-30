#!/bin/bash -l
 
colred='\033[0;31m' # Red.
colgrn='\033[0;32m' # Green.
colylw='\033[0;33m' # Yellow.
colpur='\033[0;35m' # Purple.
colrst='\033[0m'    # Text Reset.
 
verbosity=4
section=0
statement_count=1
 
# Verbosity levels.
silent_lvl=0
crt_lvl=1
err_lvl=2
wrn_lvl=3
ntf_lvl=4
inf_lvl=5
dbg_lvl=6
 
# esilent prints output even in silent mode.
function esilent()  { verb_lvl=$silent_lvl elog "$@" ;}
function enotify()  { verb_lvl=$ntf_lvl elog "$@" ;}
function eok()      { verb_lvl=$ntf_lvl elog "SUCCESS - $@" ;}
function ewarn()    { verb_lvl=$wrn_lvl elog "${colylw}WARNING${colrst} - $@" ;}
function einfo()    { verb_lvl=$inf_lvl elog "INFO ---- $@" ;}
function edebug()   { verb_lvl=$dbg_lvl elog "${colgrn}DEBUG${colrst} --- $@" ;}
function eerror()   { verb_lvl=$err_lvl elog "${colred}ERROR${colrst} --- $@" ;}
function ecrit()    { verb_lvl=$crt_lvl elog "${colpur}FATAL${colrst} --- $@" ;}
function edumpvar() { for var in $@ ; do edebug "$var = ${!var}" ; done }

function esection() { if [ $section == 0 ]; then echo ""; fi; datestring=`date +"%Y-%m-%d %H:%M:%S"`; echo -e "[$datestring] $@"; section=1; statement_count=1 ;}
function elog()     { if [ $verbosity -ge $verb_lvl ]; then datestring=`date +"%Y-%m-%d %H:%M:%S"`; echo -e "[$datestring] [$statement_count] $@"; section=0; statement_count="$(($statement_count + 1))"; fi }