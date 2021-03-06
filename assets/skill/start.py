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

def	skilldb():
	excel_file = 'skilldb.xls'
	client_template	= 'skilldb.lua'
	client_output =	'skilldb.lua'
	
	client_configs = {
		'skill':{
			'data_type':['int','unicode','unicode','unicode','int', 'str', 'int', 'int', 'int', 'str', 'int', 'int', 'str', 'str', 'str', 'int', 'int', 'str','str'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s", %(s4)d, {%(s5)s},%(s6)d, %(s7)d, %(s8)d, "%(s9)s", %(s10)d, %(s11)d, "%(s12)s", "%(s13)s", "%(s14)s", %(s15)d, %(s16)d,"%(s3)s","%(s17)s","%(s18)s"}',
			'placeholder':'$SKILLDB$'
		}
	}
	client_output_dict = converter_0(excel_file, client_configs)
	gen_file(client_template, client_output, client_output_dict)


def	skilldetaildb():
	excel_file = 'skilldb.xls'
	client_template	= 'skilldetaildb.lua'
	client_output =	'skilldetaildb.lua'
	
	client_configs1 = {
		'1':{
			'data_type':['int','str','str','str','int','str', 'int', 'int', 'int', 'int', 'int', 'int', 'int', 'float', 'unicode',"str"],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s","%(s3)s",%(s4)d,"%(s5)s",%(s6)d, %(s7)d, %(s8)d, %(s9)d, %(s10)d, %(s11)d, %(s12)d, %(s13).2f,{%(s15)s}}',
			'placeholder':'$SKILLDETAIL1$'
		}
	}
	client_configs2 = {
		'2':{
			'data_type':['int','str','str','str', 'int', 'int','int','int','float','float', 'int', 'float', 'int', 'int', 'unicode','str', 'int', 'int', 'int'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s","%(s3)s", %(s4)d, %(s5)d,%(s6)d,%(s7)d,%(s8).2f,%(s9).2f,%(s10)d,%(s11).2f, %(s12)d, %(s13)d ,"%(s15)s", %(s16)d, %(s17)d, %(s18)d}',
			'placeholder':'$SKILLDETAIL2$'
		}
	}
	client_configs3 = {
		'3':{
			'data_type':['int','str','str','str','str', 'int', 'int', 'int', 'float', 'int'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s",{%(s3)s},"%(s4)s",%(s5)d, %(s6)d,%(s7)d, %(s8).2f,%(s9)d}',
			'placeholder':'$SKILLDETAIL3$'
		}
	}
	client_configs4 = {
		'4':{
			'data_type':['int','int', 'unicode', 'str', 'str'],
			'data_template':'[%(s0)d]={%(s1)d, "%(s2)s", "%(s3)s"}',
			'placeholder':'$SKILLDETAIL4$'
		}
	}
	client_configs5 = {
		'5':{
			'data_type':['int','str','str','str','str','int', 'int', 'int','int','int','int','int','float','str', 'str'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s","%(s3)s","%(s4)s",%(s5)d, %(s6)d,%(s7)d,%(s8)d,%(s9)d,%(s10)d,%(s11)d,%(s12).2f,{%(s13)s},"%(s14)s"}',
			'placeholder':'$SKILLDETAIL5$'
		}
	}
	client_configs6 = {
		'6':{
			'data_type':['int','str','str','int', 'int', 'float', 'str'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s",%(s3)d,%(s4)d, %(s5).2f,"%(s6)s"}',
			'placeholder':'$SKILLDETAIL6$'
		}
	}
	client_configs7 = {
		'7':{
			'data_type':['int','int','int','int', 'unicode'],
			'data_template':'[%(s0)d]={%(s1)d,%(s2)d, %(s3)d}',
			'placeholder':'$SKILLDETAIL7$'
		}
	}
	client_configs8 = {
		'8':{
			'data_type':['int','str','str','str', 'str', 'str', 'int', 'int', 'int', 'int', 'int', 'int', 'float', 'int'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s","%(s3)s", "%(s4)s",{%(s5)s}, %(s6)d, %(s7)d, %(s8)d, %(s9)d, %(s10)d, %(s11)d, %(s12).2f, %(s13)d}',
			'placeholder':'$SKILLDETAIL8$'
		}
	}
	client_configs9 = {
		'9':{
			'data_type':['int', 'str', 'str', 'str', 'int', 'int', 'int', 'int', 'float', 'unicode','str'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s","%(s3)s", %(s4)d, %(s5)d, %(s6)d, %(s7)d, %(s8).2f,{%(s9)s}}',
			'placeholder':'$SKILLDETAIL9$'
		}
	}
	client_configs10 = {
		'10':{
			'data_type':['int','str','str','str', 'int', 'int', 'int', 'int', 'float', 'str', 'unicode','int','int','int'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s","%(s3)s",%(s4)d, %(s5)d, %(s6)d, %(s7)d, %(s8).2f, {%(s9)s},"%(s10)s",%(s11)d,%(s12)d,%(s13)d}',
			'placeholder':'$SKILLDETAIL10$'
		}
	}
	client_configs11 = {
		'11':{
			'data_type':['int','str','str','str', 'str', 'str', 'int', 'int', 'int', 'int', 'float'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s","%(s3)s","%(s4)s", {%(s5)s}, %(s6)d, %(s7)d, %(s8)d, %(s9)d ,%(s10).2f}',
			'placeholder':'$SKILLDETAIL11$'
		}
	}
	client_configs12 = {
		'12':{
			'data_type':['int','int','int','float', 'int', 'int', 'float', 'int', 'int', 'str','str','str','str'],
			'data_template':'[%(s0)d]={%(s1)d, %(s2)d, %(s3).2f, %(s4)d, %(s5)d, %(s6).1f, %(s7)d, %(s8)d, {%(s9)s},"%(s10)s","%(s11)s",{%(s12)s}}',
			'placeholder':'$SKILLDETAIL11$'
		}
	}
	client_output_dict = {}
	client_output_dict['$SKILLDETAIL1$'] = converter_3(excel_file, client_configs1)
	client_output_dict['$SKILLDETAIL2$'] = converter_3(excel_file, client_configs2)
	client_output_dict['$SKILLDETAIL3$'] = converter_3(excel_file, client_configs3)
	client_output_dict['$SKILLDETAIL4$'] = converter_3(excel_file, client_configs4)
	client_output_dict['$SKILLDETAIL5$'] = converter_3(excel_file, client_configs5)
	client_output_dict['$SKILLDETAIL6$'] = converter_3(excel_file, client_configs6)
	client_output_dict['$SKILLDETAIL7$'] = converter_3(excel_file, client_configs7)
	client_output_dict['$SKILLDETAIL8$'] = converter_3(excel_file, client_configs8)
	client_output_dict['$SKILLDETAIL9$'] = converter_3(excel_file, client_configs9)
	client_output_dict['$SKILLDETAIL10$'] = converter_3(excel_file, client_configs10)
	client_output_dict['$SKILLDETAIL11$'] = converter_3(excel_file, client_configs11)
	client_output_dict['$SKILLDETAIL12$'] = converter_3(excel_file, client_configs12)
	gen_file(client_template, client_output, client_output_dict)

if __name__	== '__main__':
	skilldb()
	skilldetaildb()