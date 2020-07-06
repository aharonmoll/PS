#!/bin/bash

 if [ -f gs_installation.properties ]; then
            source gs_installation.properties
        fi

for f in $xpaDir/GigaSpaces-xpa/lib/xpa/pu/*.jar 
do
        fname=$(basename "${f}" .jar)
	gigaspaces-${gsType}-enterprise-${gsVersion}/bin/gs.sh pu deploy $fname $f
done
