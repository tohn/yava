#!/bin/bash

# http://www.postgresql.org/docs/9.1/static/app-pgdump.html

root=$(dirname $0)
dump="$root/dump"
secret_dump="$root"
now=$(date +%F-%H-%M-%S)

schema="$dump/schema-${now}.pg.sch"
dumpws="$dump/dump_with_schema-${now}.pg.dump"
dumpwos="$dump/dump_without_schema-${now}.pg.dump"

if [[ $# == 0 ]] ; then
	db="yava_prod"
else
	db="$1"
fi

if [[ ! -d $dump ]] ; then
	mkdir $dump
fi

# get schema
pg_dump -s -O $db > $schema

# get dump with schema, w/o users, w/o emailhashes
pg_dump -O -T 'users' -T 'emailhashes' $db > $dumpws

# get dump w/o schema, w/o users, w/o emailhashes
pg_dump -a -O -T 'users' -T 'emailhashes' $db > $dumpwos

# TODO: create diffs!
# also weekly full dump, daily increment dump
# so user don't need the daily full dump, only the incremental one

# TODO: sqlite-sequences?
# TODO: schema_migrations?
