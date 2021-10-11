#!/bin/bash
inotifywait -m ./ -e create | 
while read path action file;
do
	echo "$path$file was created"
	xpra send-file "$path$file" 
done