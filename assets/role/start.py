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

def	roledb():
	excel_file = 'roledb.xls'
	client_template	= 'roledb.lua'
	client_output =	'roledb.lua'
	
	client_configs = {
		'role':{
			'data_type':['int','unicode','str','int', 'int', 'int', 'int', 'float', 'int','int', 'int', 'unicode','unicode', 'str','float','float','int','str'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s",%(s3)d,%(s4)d,%(s5)d,%(s6)d,%(s7).2f, %(s8)d,%(s9)d,%(s10)d,"%(s11)s","%(s12)s","%(s13)s",%(s14).2f,%(s15).2f,%(s16)d,{%(s17)s}}',
			'placeholder':'$ROLEDB$'
		}
	}
	client_output_dict = converter_0(excel_file, client_configs)
	gen_file(client_template, client_output, client_output_dict)

if __name__	== '__main__':
	roledb()
