import json
import boto3
import os
import psycopg2

def getCredentials():
    credential = {}
    
    secret_name = os.environ.get('secret_name')
    region_name = os.environ.get('AWS_REGION')
    
    client = boto3.client(
      service_name='secretsmanager',
      region_name=region_name
    )
    
    get_secret_value_response = client.get_secret_value(
      SecretId=secret_name
    )
    
    secret = json.loads(get_secret_value_response['SecretString'])
    
    credential['username'] = secret['username']
    credential['password'] = secret['password']
    credential['host'] = secret['host']
    credential['db'] = "postgres"
    
    return credential
    
def query_db(query, args=(), one=False):
    credential = getCredentials()
    connection = psycopg2.connect(user=credential['username'], password=credential['password'], host=credential['host'], database=credential['db'])
    cur = connection.cursor()
    cur.execute(query, args)
    results = cur.fetchall()
    #r = [dict((cur.description[i][0], value) \
    #           for i, value in enumerate(row)) for row in cur.fetchall()]
    cur.connection.close()
    #return (r[0] if r else None) if one else r
    return results
  # see above
  
  
def lambda_handler(event, context):
    load_type = event['load_type']
    load_frequency = event['load_frequency']
    validation_query = query_db("select src_tbl, tgt_tbl,load_chkpt_col,load_max_rows,redshift_cluster_id,redshift_user,redshift_database,redshift_log_tbl,redshift_businessdate_tbl, 'call sp_sync_merge_changes(SYSDATE,'''||src_tbl||''','''||tgt_tbl||''','''||load_chkpt_col||''','''||redshift_log_tbl||''','''||redshift_businessdate_tbl||''','||load_max_rows||')' as SQL_inp from db_etlfw.load_details a inner join db_etlfw.load_tp_master b on a.load_key=b.load_key cross join db_etlfw.login_parameters where load_tp = %s and load_frequency = %s", (load_type, load_frequency))
    results = json.dumps(validation_query)
    response = []
    
    
    for row in validation_query:
        resp = {'src_tbl': row[0], 'tgt_tbl': row[1], 'load_chkpt_col': row[2], 'load_max_rows': row[3], 'redshift_cluster_id': row[4], 'redshift_user': row[5], 'redshift_database': row[6], 'redshift_log_tbl': row[7], 'redshift_businessdate_tbl': row[8], 'SQL_inp': row[9]}
        response.append(resp)
    print (results)
    print (validation_query)
    print (response)
    return response
