from sqlalchemy import create_engine,MetaData,Table
con_str = 'sqlite:///test_db'
engine = create_engine(con_str)#,client_encoding='utf-8')

meta = MetaData()
orgs_table_name = 'orgs'
orgs_table = Table(orgs_table_name, meta, autoload=True, autoload_with=engine)
conn = engine.connect()

def execute_query(query,query_params=None):
    try:
        if query_params is None:
            results = conn.execute(query)
        else:
            results = conn.execute(query,query_params)
        return results
    except Exception,e:
        error = 'db error of some sort exception:' +  unicode(e)
        print(error)
        return error
    finally:
        if conn is not None:
            conn.close()
