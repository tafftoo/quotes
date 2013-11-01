#!/usr/bin/env python

import argparse 
import urllib
import urllib2
import json

parser = argparse.ArgumentParser(description='Team Quotes Command line client')
parser.add_argument('-l','--list',help="List quotes",required=False)
parser.add_argument('-r','--random',action='store_true',required=False)
parser.add_argument('username', nargs='?')
parser.add_argument('quote', nargs='?')
args = parser.parse_args()

if args.random:
	json = json.load(urllib2.urlopen('http://192.168.88.86:8069/random'))
	print "%s: \"%s\"" % (json['person'], json['quote'])

elif args.list:
	json = json.load(urllib2.urlopen('http://192.168.88.86:8069/quotes/%s' % args.list))
	for q in json:
		print "%s: \"%s\"" % (q['person'], q['quote'])

elif args.quote:
	url = 'http://192.168.88.86:8069/quotes/%s' % args.username
	values = {
		'quote':args.quote
	}
	data = urllib.urlencode(values)
	req = urllib2.Request(url, data)
	urllib2.urlopen(req)
else:
	print 'quote [-r] [-l] <username> [<quote>]'