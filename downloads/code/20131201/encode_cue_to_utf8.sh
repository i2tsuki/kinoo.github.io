#!/bin/sh
for file in `find . -type f -name '*.cue'`;
do
    nkf -w --in-place file
done

exit
