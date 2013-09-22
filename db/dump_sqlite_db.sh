#!/bin/bash

# http://stackoverflow.com/questions/75675/how-do-i-dump-the-data-of-some-sqlite3-tables

# TODO: postgresql!

root=$(dirname $0)
dump="$root/dump"
secret_dump="$root"
now=$(date +%F-%H-%M-%S)

schema="$dump/schema-${now}.sch"
users="$secret_dump/users-${now}.dump"
emailhashes="$secret_dump/emailhashes-${now}.dump"
full="$secret_dump/full-${now}.dump"
dumpws="$dump/dump_with_schema-${now}.dump"
dumpwos="$dump/dump_without_schema-${now}.dump"

if [[ $# == 0 ]] ; then
	db="$root/development.sqlite3"
else
	if [[ -e "$root/$1" ]] ; then
		db="$root/$1"
	fi
fi

if [[ ! -d $dump ]] ; then
	mkdir $dump
fi

# get schema
sqlite3 $db .sch > $schema

# get users
sqlite3 $db ".dump 'users'" > $users

# get emailhashes
sqlite3 $db ".dump 'emailhashes'" > $emailhashes

# get full dump
sqlite3 $db .dump > $full

# get dump with schema, w/o users, w/o emailhashes
grep -v -f $users -v -f $emailhashes $full > $dumpws

# get dump w/o schema, w/o users, w/o emailhashes
grep -v -f $users -v -f $emailhashes -v -f $schema $full > $dumpwos

# TODO: create diffs!
# also weekly full dump, daily increment dump
# so user don't need the daily full dump, only the incremental one

# TODO: sqlite-sequences?
# TODO: schema_migrations?
