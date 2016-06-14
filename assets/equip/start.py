#!/usr/bin/env python
# encoding:	utf-8
import os
#from __future__ import	with_statement

import xlrd

import sys
sys.path.append("../")

from script.util import	_int
from script.util import	_utf8
from script.util import	_j2f
from script.util import	multilanguagefd
from script.util import	multilanguage
from script.util import	converter_0
from script.util import	converter_3
from script.util import	gen_file
from script.util import	gen_adminserver_file

def	equipdb():
	excel_file = 'equipdb.xls'
	client_template	= 'equipdb.lua'
	client_output =	'equipdb.lua'
	
	client_configs = {
		'equip':{
			'data_type':['int','unicode','str'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s"}',
			'placeholder':'$EQUIPDB$'
		}
	}
	client_output_dict = converter_0(excel_file, client_configs)
	gen_file(client_template, client_output, client_output_dict)

if __name__	== '__main__':
	equipdb()
