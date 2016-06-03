#!/bin/sh

rm -rf ../outputClient/*
rm -rf ../outputServer/*
rm -rf ../outputAdminServer/*

if [ ! $1 ]; then
	echo "param1 not defined!!!!!!!!!!!!!!!!"
	exit 0
fi 

if [ ! $2 ]; then
	echo "param2 not defined!!!!!!!!!!!!!!!!"
	exit 0
fi 

if [ ! $3 ]; then
	echo "param3 not defined!!!!!!!!!!!!!!!!"
	exit 0
fi 

if [ ! $4 ]; then
	echo "param4 not defined!!!!!!!!!!!!!!!!"
	exit 0
fi 

./script/conf.sh $1 $2 $3 $4

./script/copyres.sh $1 $2
