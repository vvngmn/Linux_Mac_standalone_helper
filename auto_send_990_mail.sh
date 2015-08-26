#!/bin/bash
for i in {0..99}
do
	./sm.pl -f imail3 -u mxuser$i msg1.txt -c 990 &
done

