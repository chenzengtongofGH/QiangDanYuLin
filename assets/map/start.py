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
	excel_file = 'MapDB.xls'
	client_template	= 'MapDB.lua'
	client_output =	'MapDB.lua'
	
	client_configs = {
		'MapDB':{
			'data_type':['int','str','str','str', 'str', 'str',	'str','int','int','int','int','int'],
			'data_template':'[%(s0)d]={"%(s1)s","%(s2)s","%(s3)s",{"%(s4)s"},{"%(s5)s"},%(s6)s,%(s7)d,%(s8)d,%(s9)d,%(s10)d,%(s11)d}',
			'placeholder':'$MapDB$'
		}
	}
	client_output_dict = converter_0(excel_file, client_configs)
	gen_file(client_template, client_output, client_output_dict)

def converter_mapmonsterdb_data2(excel_file, sheet_name):
	book = xlrd.open_workbook(excel_file)
	sheet = book.sheet_by_name(sheet_name)
	print sheet.name

	data_template1 = '[%(s0)d] = {\n%(s2)s\n'+' '*20+'}'
	data_template2 = '["%(s0)s"] = {\n%(s2)s\n'+' '*20+'}'
	rows_text = ''
	last_row_s0 = ''


	map_dict = {}
	map_txt = ''

	row_dict = {}
	row_list = ''
	last_row_d0 = 0
	last_row_s1 = ''

	for i in xrange(1, sheet.nrows):
		# 循环sheet中的行
		current_row_d0 = int(sheet.cell_value(i,0))
		current_row_s1 = _utf8(sheet.cell_value(i,1))
		if last_row_d0 == 0:
			last_row_d0 = current_row_d0
		if last_row_d0 != current_row_d0:
			if row_list != '':
				row_list = row_list[:-2]
			row_dict['s2'] = row_list
			row_data = data_template2 % row_dict
			rows_text = rows_text + ' ' * 24 + row_data + ',\n'
			if rows_text != '':
				rows_text = rows_text[:-2]
			map_dict['s2'] = rows_text
			map_data = data_template1 % map_dict
			map_txt = map_txt + ' ' * 12 + map_data + ',\n'
			map_dict = {}
			row_dict = {}
			row_list = ''
			rows_text = ''
			last_row_s1 = ''
			last_row_d0 = current_row_d0
		else:
			if last_row_s1 == '':
				last_row_s1 = current_row_s1
			if last_row_s1 != current_row_s1:
				if row_list != '':
					row_list = row_list[:-2]
				row_dict['s2'] = row_list
				row_data = data_template2 % row_dict
				rows_text = rows_text + ' ' * 24 + row_data + ',\n'
				row_list = ''
				row_dict = {}
				last_row_s1 = current_row_s1
		row_dict['s0'] = current_row_s1
		row_data = "[%d]={%d,'%s', %d, %d}, \n" % (int(sheet.cell_value(i,2)), int(sheet.cell_value(i,3)), _utf8(sheet.cell_value(i,4)), int(sheet.cell_value(i,5)), int(sheet.cell_value(i,6)))
		row_list = row_list + ' ' * 34 + row_data
		map_dict['s0'] = current_row_d0

	row_dict['s2'] = row_list
	row_data = data_template2 % row_dict
	rows_text = rows_text + ' ' * 24 + row_data + ',\n'	
	if rows_text != '':
		rows_text = rows_text[:-2]
	map_dict['s2'] = rows_text
	map_data = data_template1 % map_dict
	map_txt = map_txt + ' ' * 12 + map_data + ',\n'
	return map_txt[:-2]

def converter_mapmonsterdb_data(excel_file, sheet_name):
	book = xlrd.open_workbook(excel_file)
	sheet = book.sheet_by_name(sheet_name)
	print sheet.name

	data_template = '["%(s0)s"] = {\n%(s2)s\n'+' '*20+'}'

	rows_text = ''
	last_row_s0 = ''
	row_dict = {}
	row_list = ''

	for i in xrange(1, sheet.nrows):
		# 循环sheet中的行
		current_row_s0 = _utf8(sheet.cell_value(i,0))
		if last_row_s0 == '':
			last_row_s0 = current_row_s0
		if last_row_s0 != current_row_s0:
			if row_list != '':
				row_list = row_list[:-2]
			row_dict['s2'] = row_list
			row_data = data_template % row_dict
			rows_text = rows_text + ' ' * 12 + row_data + ',\n'
			row_dict = {}
			row_list = ''
			last_row_s0 = current_row_s0

		row_dict['s0'] = current_row_s0
		row_data = "[%d]={%d,'%s', %d, %d}, \n" % (int(sheet.cell_value(i,1)), int(sheet.cell_value(i,2)), _utf8(sheet.cell_value(i,3)), int(sheet.cell_value(i,4)), int(sheet.cell_value(i,5)))
		row_list = row_list + ' ' * 22 + row_data

	if row_list != '':
		row_list = row_list[:-2]
	row_dict['s2'] = row_list
	row_data = data_template % row_dict
	rows_text = rows_text + ' ' * 12 + row_data + ',\n'
	return rows_text[:-2]

def mapmonsterdb():
	excel_file = 'MapDB.xls'
	client_template = 'mapmonsterdb.lua'
	client_output = 'mapmonsterdb.lua'
	client_output_dict = dict()
	client_output_dict['$MAPMONSTERDB$'] = converter_mapmonsterdb_data2(excel_file, 'mapmonster')
	gen_file(client_template, client_output, client_output_dict)
if __name__	== '__main__':
	sampledb()
	mapmonsterdb()