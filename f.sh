#!/bin/sh

# export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libpython3.12.so:/home/oof/ruzzy/ext/cruzzy/cruzzy.so" # Load the python stuff first.

while true; do
	bundle exec rails runner -e development /home/oof/dev/gdk/gitlab/ruzzy_tracer.rb --- somefile -dict=final.txt -timeout=1000 -max_len=1000 corpus/ 2>> fuzz_output.txt # The three dashes are on purpose.
done



