#!/usr/bin/env bash

while getopts ":l:r" opt; do
	case $opt in
		l)
			LIST_USER_QUOTES=true
			LIST_USER=$OPTARG
			;;
		r)
			RANDOM_QUOTE=true
			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			exit 1
			;;
		?)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
	esac

	if [ $LIST_USER_QUOTES ]; then
		echo "Listing quotes for user: $LIST_USER"
		curl -i -H "Accept: application/json" http://localhost:8080/quotes/$LIST_USER

	fi

	if [ $RANDOM_QUOTE ]; then
		curl -i http://localhost:8080/random
	fi
done