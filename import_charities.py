# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import csv
import data
import codecs
from back_end.dbdefs.volunteer_venice import VolunteerVeniceBase
from videolab import youtube_tools
ytools = youtube_tools.YoutubeTools()

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
        self.reader = csv.reader(f, delimiter=b',', quotechar=b'"', **kwds)

    def next(self):
        row = self.reader.next()
        return [unicode(s, "utf-8") for s in row]

    def __iter__(self):
        return self


def make_tables():
    VolunteerVeniceBase.metadata.drop_all(data.engine)  # @UndefinedVariable
    VolunteerVeniceBase.metadata.create_all(data.engine)  # @UndefinedVariable

def random_vid_ids():
    while True:
        vids = ytools.get_channel_uploaded_videos('deepskyvideos')
        for vid in vids:
            yield vid.yt_video_id
    return

def import_file(file_name):
    orgs = []
    first = True
    with open(file_name, 'rub') as csvfile:
        reader = UnicodeReader(csvfile)
        for row in reader:
            if first:
                first = False
                continue
            org = {
                'name': row[0],
                'website': row[1],
                'address': row[2],
                'description': row[3],
                'category_id': row[4],
                'phone_number': row[5],
                'email': row[6],
                'picture_location': row[7],
                'video_location': row[8],
                'location_id': int(row[9])
            }
            orgs.append(org)

    named_orgs = []
    random_vid_ids_gen = random_vid_ids()
    for org in orgs:
        if org['video_location'] == '' or org['video_location'] is None:
            org['video_location'] = random_vid_ids_gen.next()
            print('adding random vid id:'+org['video_location'])
        if org['name'] is not None and org['name'] != '':
            named_orgs.append(org)
    return named_orgs

def insert_db(orgs):

    orgs_table = data.get_org_table()
    query = orgs_table.delete()
    query_result = data.execute_query(query)
    if query_result is None or isinstance(query_result, basestring):
        print(query_result)
        return query_result

    query = orgs_table.insert()
    query_params = orgs
    query_result = data.execute_query(query, query_params=query_params)
    if query_result is None or isinstance(query_result, basestring):
        print(query_result)
        return query_result


orgs = import_file('VolunteerVenice.csv')
make_tables()
insert_db(orgs)
