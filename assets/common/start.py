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

def	sampledb():
    excel_file = 'sampledb.xls'
    client_template	= 'sampledb.lua'
    client_output =	'sampledb.lua'
	
    client_configs = {
        'sample':{
            'data_type':['int','unicode','unicode','int', 'int', 'int',	'int', 'int'],
            'data_template':'[%(s0)d]={"%(s1)s","%(s2)s",%(s3)d,%(s4)d,%(s5)d,%(s6)d,%(s7)d}',
            'placeholder':'$SAMPLEDB$'
        }
    }
    client_output_dict = converter_0(excel_file, client_configs)
    gen_file(client_template, client_output, client_output_dict)
def	stringdb():
    excel_file = 'stringdb.xls'
    client_template	= 'stringdb.lua'
    client_output =	'stringdb.lua'
	
    client_configs = {
        'stringdb':{
            'data_type':['str','unicode'],
            'data_template':'["%(s0)s"]="%(s1)s"',
            'placeholder':'$STRINGDB$'
        },
		'name':{
			'data_type':['int','unicode'],
            'data_template':'[%(s0)d]="%(s1)s"',
            'placeholder':'$NAMEDB$'
		},
		'prefix':{
			'data_type':['int','unicode'],
            'data_template':'[%(s0)d]="%(s1)s"',
            'placeholder':'$PREFIX$'
		}
    }
    client_output_dict = converter_0(excel_file, client_configs)
    gen_file(client_template, client_output, client_output_dict)
def	serverinfodb():
    excel_file = 'serverinfo.xls'
    client_template	= 'serverinfodb.lua'
    client_output =	'serverinfodb.lua'
	
    client_configs = {
        'ServerInfoDB':{
            'data_type':['int','str','int','unicode','unicode','unicode'],
            'data_template':'[%(s0)d]={"%(s1)s","%(s2)d","%(s3)s","%(s4)s","%(s5)s"}',
            'placeholder':'$ServerInfoDB$'
        }
    }
    client_output_dict = converter_0(excel_file, client_configs)
    gen_file(client_template, client_output, client_output_dict)

def autofree_db():
    """
    """    
    client_template = 'autofreedb.lua'
    client_output = 'autofreedb.lua'

    client_configs = {
        'autofree': {
            'data_type': ['str', 'int', 'int', 'int'],
            'data_template': '["%(s0)s"]={%(s1)d,%(s2)d,%(s3)d}',
            'placeholder': '$AUTOFREE$'
        }
    }

    client_output_dict = converter_0('autofree.xls', client_configs)


    gen_file(client_template, client_output, client_output_dict)

def remind_db():
    """
    """    
    client_template = 'reminddb.lua'
    client_output = 'reminddb.lua'

    client_configs = {
        'remind': {
            'data_type': ['str', 'str', 'float', 'int', 'int', 'int'],
            'data_template': '["%(s0)s"]={"%(s1)s",%(s2)f,%(s3)d,%(s4)d,%(s5)d}',
            'placeholder': '$REMIND$'
        }
    }

    client_output_dict = converter_0('remind.xls', client_configs)


    gen_file(client_template, client_output, client_output_dict)

if __name__	== '__main__':
    stringdb()
    serverinfodb()
    autofree_db()
    remind_db()