/*
 Table :- load_tp_master
 Description:- Stores information about the type of extraction
 Load Key:- Record identifier
 Load_tp:- Type of extraction e.g. incremental, full
 load_frequency:- frequency of the extraction e.g. short-batch (10/15/30/60 mins interval), daily etc)
 active_flag:- Y or N whether this load type to be executed. For e.g set this flag to N during maintanance or manual/admin activities
 */
drop table if exists $$schema.etlfw_load_tp_master;
create table $$schema.etlfw_load_tp_master
(
load_key int,
load_tp varchar(20),
load_frequency varchar(20),
active_flag varchar(2)
);
/*please update the below statement with appropriate values from your environment*/
insert into $$schema.etlfw_load_tp_master values(1,'incremental','short_batch','Y')
insert into $$schema.etlfw_load_tp_master values(2,'full','daily','Y')
/*
 Table :- load_details
 Description:- Stores granualr information about the extraction
 src_tbl:- Postgres table to be extracted. Format <schema_name>.<table_name> Schema name should be the redshift external schema
 tgt_tbl:- target redshift table. Format <schema_name>.<table_name>
 Load Key:- reference key from the load_tp_master table
 load_chkpt_col:- timestamp field in the src_tbl that records time of data modification
 load_max_rows:- maximum number of rows that should be extracted in one batch
 active_flag:- Y or N whether the extraction for the source and target table to be executed. For e.g set this flag to N during maintanance or manual/admin activities
 */
drop table if exists $$schema.etlfw_load_details;
create table $$schema.etlfw_load_details
(
src_tbl varchar(200),
tgt_tbl varchar(200),
load_key int,
load_chkpt_col varchar(200),
load_max_rows int,
load_active_flag varchar(2)
);
/*please update the below statement with appropriate values from your environment*/
insert into $$schema.etlfw_load_details values ('fed_postgres_tpc_ds.web_sales_test_load', 'public.rs_stg_web_sales',1,'d_date',1000000000,'Y');
insert into $$schema.etlfw_load_details values ('fed_postgres_tpc_ds.date_dim', 'public.rs_stg_date_dim',1,'d_date',1000000000,'Y');

/*
 Table :- login_parameters
 Description:- Stores redshift login information . Password is not stored here
 redshift_cluster_id:- identifier for Redshift target cluster 
 redshift_user: Redshift user that has at least read access on external schema and read and write access on the redshift target schema. Can also be used for running Redshift Data API jobs
 redshift_database:- Redshuft database name
 redshift_log_tbl:- Log table name in Redshift. This will be created in the Redshift deployment section
 redshift_businessdate_tbl:- Table in Redshift which stores the max of last modified record timestamp
 */
drop table if exists $$schema.etlfw_login_parameters;
create table $$schema.etlfw_login_parameters
(
redshift_cluster_id varchar(200),
redshift_user varchar(200),
redshift_database varchar(200),
redshift_log_tbl varchar(200),
redshift_businessdate_tbl varchar(200)
);
/*please update the below statement with appropriate values from your environment*/
insert into $$schema.etlfw_login_parameters values ('redshift-cluster-2','awsuser','dev','public.etlfw_rs_table_load_details','public.etlfw_load_businessdate');
