/*
 Table :- etlfw_load_businessdate
 Description:- Stores max of last modified record timestamp
 src_tbl:- Postgres table to be extracted. Format <schema_name>.<table_name> Schema name should be the redshift external schema
 Load Key:- reference key from the load_tp_master table
 last_load_businessdate: Stores max of last modified record timestamp
 */
drop table if exists $$schema.etlfw_load_businessdate;
create table $$schema.etlfw_load_businessdate
(
src_tbl varchar(200),
load_key int,
last_load_businessdate timestamp
);
/*please update the below statement with appropriate values from your environment*/
insert into $$schema.etlfw_load_businessdate values ('fed_postgres_tpc_ds.web_sales_test_load', 1, '2002-12-31');
insert into $$schema.etlfw_load_businessdate values ('fed_postgres_tpc_ds.date_dim', 1, '1900-01-01');


/*
 Table :- etlfw_rs_load_details
 Description:- table where actions are logged
 batch_timeT:- imestamp for this batch. Used to timestamp the log
 source_table:- Postgres table to be extracted. Format <schema_name>.<table_name> Schema name should be the redshift external schema
 target_table:- target redshift table. Format <schema_name>.<table_name>
 sync_column:- timestamp field in the src_tbl that records time of data modification
 sync_status:- status for the job
 sync_queies:- Query id of the ETL job
 row_count:-  Total no of rows inserted.deleted.updated
 :-
 */
drop table if exists $$schema.etlfw_rs_load_details;
CREATE TABLE $$schema.etlfw_rs_load_details (
                           batch_time   TIMESTAMP
                         , source_table VARCHAR
                         , target_table VARCHAR
                         , sync_column  VARCHAR
                         , sync_status  VARCHAR
                         , sync_queries VARCHAR --Query ID of the INSERT
                         , row_count    INT);
