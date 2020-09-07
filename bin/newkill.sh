#!/bin/bash

if [ $# != 1 ]; then
		echo "Accepts the exact process name as an argument."
		exit 10
fi

ps -A | grep $1$ | cut -d " " -f1 > ~/.scriptpids
