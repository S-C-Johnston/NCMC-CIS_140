#!/usr/bin/env bash

## Author: Stewart Johnston <johnstons1@student.ncmich.edu>
## Summary: Project 4, task 3
## Version: 1.0
## Purpose: Demonstrate understanding of the stream editor

sed 's/\<([0-9]){3}-/(&) /' <PhoneList.csv >PhoneList.csv.new
# Match at the boundary of a word 3 digits followed by -, capture the numbers, and wrap them in parens
sed 's/\<([A-Za-z0-9._%+-])+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\>/\1@starhealth.org/'
# www.regular-expressions.info/email.html
# Repurposed for my needs, capturing the user's name and swapping out the old domain name
