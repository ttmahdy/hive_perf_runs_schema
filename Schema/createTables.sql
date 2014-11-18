drop table if exists perf_runs ;
drop table if exists cluster;
drop table if exists test_result;
drop table if exists resource_utilization_summary;
drop table if exists tez_vertex_info;

create table perf_runs (
pr_id int not null auto_increment primary key,
pr_start varchar(50),
pr_end varchar(50),
pr_cluster_id integer,
pr_testName varchar(1024),
pr_database_name varchar(1024),
pr_workload varchar(1024),
pr_workload_version double,
pr_misc varchar(1024)
);

create table cluster (
c_id int not null auto_increment primary key,
c_name varchar(50),
c_processor_model varchar(50),
c_node_count int,
c_logical_proccount int,
c_memory_size_gb int,
c_spinning_disk_count int,
c_ssd_disk_count int,
c_spinning_disk_size_total_gb int,
c_ssd_disk_size_total_gb int,
c_nic_cards_count int,
c_nic_cards_model varchar(250),
c_misc varchar(1024)
);

create table test_result (
tr_id int not null auto_increment primary key,
tr_perf_runs_id int,
tr_name varchar(250),
tr_application_id varchar(250),
tr_start_time DATETIME,
tr_end_time DATETIME,
tr_elapsed_time_secs double,
tr_vertex_count int,
tr_task_count int,
tr_failed_tasks int,
tr_killed_tasks int,
tr_cpu_time_millis bigint, 
tr_gc_time_millis bigint, 	 
tr_input_records bigint, 	 
tr_output_records bigint,
tr_semantic_analyze_time_ms        		double null,
tr_tez_build_dag_time_ms            	double null,
tr_tez_submit_to_running_dag_time_ms  	double null,
tr_tez_total_prep_time_ms 				double null,
tr_misc varchar(1024),
tr_explain_plan MEDIUMTEXT,
tr_application_summary MEDIUMTEXT,
tr_parse_time_ms    double null
);
                           
create table resource_utilization_summary (
rus_id int not null auto_increment primary key,
rus_tes_result_id int,
rus_elapsed_time_secs 	 double,
rus_avg_cpu_user 	 double,
rus_avg_cpu_sys 	 double,
rus_avg_disk_read_bytes_per_sec 	double,
rus_avg_disk_write_bytes_per_sec 	double, 	 
rus_avg_network_read_bytes_per_sec 	double,
rus_avg_network_write_bytes_per_sec double,
rus_total_cpu_user 	  double,
rus_total_cpu_sys 	  double,
rus_total_disk_read_bytes 	  double,
rus_total_disk_write_bytes 	  double,
rus_total_network_read_bytes 	  double,
rus_total_network_write_bytes  double,
rus_misc varchar(1024)
);

create table tez_vertex_info (
tvi_id int not null auto_increment primary key,
tvi_tes_result_id int,
tvi_vertex_name varchar(50),
tvi_vertex_duration_seconds double,
tvi_vertex_task_count double,
tvi_vertex_failed_attempts double,
tvi_vertex_killed_tasks double,
tvi_vertex_cpu_time_millis double,
tvi_vertex_gc_time_millis double,
tvi_vertex_input_records double,
tvi_vertex_output_records double
);


ALTER TABLE tez_vertex_info ADD FOREIGN KEY fk_tvf_tr (tvi_tes_result_id) REFERENCES test_result (tr_id)  ON DELETE CASCADE;
ALTER TABLE resource_utilization_summary ADD FOREIGN KEY fk_rus_tr (rus_tes_result_id) REFERENCES test_result (tr_id)  ON DELETE CASCADE;
ALTER TABLE test_result ADD FOREIGN KEY fk_tr_pr (tr_perf_runs_id) REFERENCES perf_runs (pr_id)  ON DELETE CASCADE;
ALTER TABLE perf_runs ADD FOREIGN KEY fk_pr_c (pr_cluster_id) REFERENCES cluster (c_id)  ON DELETE CASCADE;
