# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import csv
import data
import codecs


class UTF8Recoder:
    """
    Iterator that reads an encoded stream and reencodes the input to UTF-8
    """
    def __init__(self, f, encoding):
        self.reader = codecs.getreader(encoding)(f)

    def __iter__(self):
        return self

    def next(self):
        return self.reader.next().encode("utf-8")

class UnicodeReader:
    """
    A CSV reader which will iterate over lines in the CSV file "f",
    which is encoded in the given encoding.
    """

    def __init__(self, f, dialect=csv.excel, encoding="utf-8", **kwds):
        f = UTF8Recoder(f, encoding)
        self.reader = csv.reader(f, dialect=dialect, **kwds)

    def next(self):
        row = self.reader.next()
        return [unicode(s, "utf-8") for s in row]

    def __iter__(self):
        return self

def import_file(file_name):
    orgs = []
    first = True
    with open(file_name, 'rub') as csvfile:
        reader = UnicodeReader(csvfile)
        for row in reader:
            if first:
                first = False
                continue
            if len(row) < 9:
                row = row + [None]*(9-len(row))
            clean_row = []
            for item in row:
                if isinstance(item,basestring) and item == '':
                    clean_row.append(None)
                clean_row.append(item)
            row = clean_row
            org = {
                'name': row[0],
                'website':row[1],
                'address':row[2],
                'description':row[3],
                'category':row[4],
                'phone_number':row[5],
                'email':row[6],
                'picture_locations':row[7],
                'video_locations':row[8],
                }
            orgs.append(org)

    named_orgs = []
    for org in orgs:
        if org['name'] is not None and org['name'] != '':
            named_orgs.append(org)
    return named_orgs




def insert_db(orgs):
    query = data.orgs_table.insert()
    query_params = orgs
    query_result = data.execute_query(query,query_params=query_params)
    if query_result is None or isinstance(query_result,basestring):
        print(query_result)
        return query_result


orgs = import_file('VolunteerVenice.csv')
insert_db(orgs)
#print orgs
