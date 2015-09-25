# ${license-info}
# ${developer-info}
# ${author-info}
# ${build-info}

declaration template components/icinga2/schema;

include 'quattor/types/component';
include 'pan/types';

# Please note that the "use" directive is not supported in order to make
# validation code easier. If you want hosts to inherit settings then use
# Pan statements like create ("...") or value ("...")

type icinga2_hoststring =  string with exists ("/software/components/icinga2/hosts/" + SELF) ||
    SELF=="*" || SELF == 'dummy';

type icinga2_hostgroupstring = string with exists ("/software/components/icinga2/hostgroups/" + escape(SELF)) || SELF=="*";

type icinga2_commandstrings = string [] with exists ("/software/components/icinga2/commands/" + SELF[0]);

type icinga2_timeperiodstring = string with exists ("/software/components/icinga2/timeperiods/" + SELF) ||
    SELF=="*";

type icinga2_contactgroupstring = string with exists ("/software/components/icinga2/contactgroups/" + SELF) ||
    SELF=="*";

type icinga2_contactstring = string with exists ("/software/components/icinga2/contacts/" + SELF) ||
    SELF=="*";

type icinga2_servicegroupstring = string with exists ("/software/components/icinga2/servicegroups/" + SELF) ||
    SELF=="*";

type icinga2_servicestring = string with exists ("/software/components/icinga2/services/" + SELF) ||
    SELF=="*";

type icinga2_service_notification_string = string with match (SELF, "^(w|u|c|r|f)$");
type icinga2_host_notification_string = string with match (SELF, "^(d|u|r|f)$");
type icinga2_stalking_string = string with match (SELF, "^(o|w|u|c)$");
type icinga2_execution_failure_string = string with match (SELF, "^(o|w|u|c|p|n)$");
type icinga2_notification_failure_string = string with match (SELF, "^(o|w|u|c|p|n)$");

type structure_icinga2_host_generic = {
    "name" ? string
    "groups" ? icinga2_hostgroupstring[]
    "check_command" : icinga2_commandstrings
    "max_check_attempts" : long = 3
    "check_period" : icinga2_timeperiodstring
    "check_interval" : long = 300 # In seconds
    "retry_interval" : long = 60  # In seconds
    "enable_notifications" : boolean = true
    "enable_active_checks" : boolean = true
    "enable_passive_checks" : boolean = true
    "enable_event_handler" : boolean = true
    "enable_flapping" : boolean = false
    "enable_perfdata" : boolean = true
    "event_command" : string
    "flapping_threshold" : long # precentage
    "volatile" : boolean
    "zone" : string
    "command_endpoint" : string
    "notes" : string
    "notes_url" : string
    "action_url" : string
    "icon_image" : string
    "icon_image_url" : string
} = dict();


# Host definition.
type structure_icinga2_host = {
    "name" ? string
    "display_name" : string
    "import" ? string # Used to import a template host declaration
    "address" ? type_ip # If not present, gethostbyname will be used.
    "groups" ? icinga2_hostgroupstring[]
    "check_command" : icinga2_commandstrings
    "max_check_attempts" : long = 3
    "check_period" : icinga2_timeperiodstring
    "check_interval" : long = 300 # In seconds
    "retry_interval" : long = 60  # In seconds
    "enable_notifications" : boolean = true
    "enable_active_checks" : boolean = true
    "enable_passive_checks" : boolean = true
    "enable_event_handler" : boolean = true
    "enable_flapping" : boolean = false
    "enable_perfdata" : boolean = true
    "event_command" : string
    "flapping_threshold" : long # precentage
    "volatile" : boolean
    "zone" : string
    "command_endpoint" : string
    "notes" : string
    "notes_url" : string
    "action_url" : string
    "icon_image" : string
    "icon_image_url" : string
} = dict();

# Hostgroup definition
type structure_icinga2_hostgroup = {
    "name" ? string    
    "display_name" : string
    "groups" : icinga2_hostgroupstring[]
    "assign_where" : string[]
    "ignore_where" : string[]
} = dict();


# Service definition
type structure_icinga2_service = {
    "name" ? string    
    "display_name" : string 
    "import" : string # Used to include template
    "host_name" : icinga2_hoststring[]
    "groups" : icinga2_hostgroupstring[]
    "vars" : dict()
    "servicegroups" : icinga2_servicegroupstring []
    "check_command" ? icinga2_commandstrings
    "max_check_attempts" : long = 3
    "check_period" : icinga2_timeperiodstring
    "check_interval" : long = 300 # In seconds
    "retry_interval" : long = 60  # In seconds
    "enable_notifications" : boolean = true
    "enable_active_checks" : boolean = true
    "enable_passive_checks" : boolean = true
    "assign_where" : string[]
    "ignore_where" : string[]
} with has_host_or_hostgroup (SELF);; # should be has_host_or_hostgroup_or_assignrule

# Servicegroup definition:
type structure_icinga2_servicegroup = {
    "name" ? string    
    "display_name" : string 
    "host_names" : icinga2_hoststring[]
    "hostgroups" : icinga2_hostgroupstring[]
    "groups" : icinga2_servicegroupstring []
    "assign_where" : string[]
    "ignore_where" : string[]
} = dict();


type icinga2_user_types_string = string with 
    match (SELF, "^(DowntimeStart|DowntimeEnd|DowntimeRemoved|Custom|Acknowledgement|Problem|Recovery|FlappingStart|FlappingEnd)$");
type icinga2_user_states_string = string with 
    match (SELF, "^(OK|Warning|Critical|Unknown|Up|Down)$");

# Contact definition
type structure_icinga2_user = {
    "name" ? string    
    "display_name" : string
    "email" ? string
    "pager" : string
    "vars" : dict()
    "groups" ? icinga2_contactgroupstring []
    "enable_notifications" : boolean = true
    "period" : icinga2_timeperiodstring
    "types" : icinga2_user_types_string [] 
    "states" : icinga2_user_states_string []
} = dict();

# Contact group definition
type structure_icinga2_contactgroup = {
    "name" ? string    
    "display_name" : string
    "groups" : icinga2_contactgroupstring[]
    "users" : icinga2_contactstring[]
    "assign_where" : string[]
    "ignore_where" : string[]
} = dict(); # has_users_or_assign => not really needed since hardcoded inside a user


# General options
type structure_icinga2_icinga2_cfg = {
    "log_file" : string = "/var/log/icinga2/icinga.log"
    "object_cache_file" : string = "/var/icinga2/objects.cache"
    "resource_file" : string = "/etc/icinga2/resource.cfg"
    "status_file" : string = "/var/icinga2/status.dat"
    "icinga2_user" : string = "icinga"
    "icinga2_group" : string = "icinga"
    "check_external_commands" : boolean = false
    "command_check_interval" : long = -1
    "command_file" : string = "/var/icinga2/rw/icinga.cmd"
    "external_command_buffer_slots" : long = 4096
    "lock_file" : string = "/var/icinga2/icinga.pid"
    "temp_file" : string = "/var/icinga2/icinga.tmp"
    "event_broker_options" : long = -1
    "log_rotation_method" : string = "d"
    "log_archive_path" : string = "/var/log/icinga2/archives"
    "use_syslog" : boolean = true
    "log_notifications" : boolean = true
    "log_service_retries" : boolean = true
    "log_host_retries" : boolean = true
    "log_event_handlers" : boolean = true
    "log_initial_states" : boolean = false
    "log_current_states" : boolean = true
    "log_external_commands" : boolean = true
    "log_passive_checks" : boolean = true
    "log_external_commands_user" : boolean = false
    "log_long_plugin_output" : boolean = false
    "global_host_event_handler" ? string
    "service_inter_check_delay_method" : string = "s"
    "max_service_check_spread" : long = 30
    "service_interleave_factor" : string = "s"
    "host_inter_check_delay_method" : string = "s"
    "max_host_check_spread" : long = 30
    "max_concurrent_checks" : long = 0
    "service_reaper_frequency" : long = 10
    "check_result_buffer_slots" ? long
    "auto_reschedule_checks" : boolean = false
    "auto_rescheduling_interval" : long = 30
    "auto_rescheduling_window" : long = 180
    "sleep_time" : string = "0.25"
    "service_check_timeout" : long = 40
    "host_check_timeout" : long = 20
    "event_handler_timeout" : long = 30
    "notification_timeout" : long = 30
    "ocsp_timeout" : long = 5
    "perfdata_timeout" : long = 5
    "retain_state_information" : boolean = true
    "state_retention_file" : string = "/var/icinga2/retention.dat"
    "retention_update_interval" : long = 60
    "use_retained_program_state" : boolean = true
    "dump_retained_host_service_states_to_neb" : boolean = true
    "use_retained_scheduling_info" : boolean = false
    "interval_length" : long = 60
    "use_aggressive_host_checking" : boolean = false
    "execute_service_checks" : boolean = true
    "accept_passive_service_checks" : boolean = false
    "execute_host_checks" : boolean = true
    "accept_passive_host_checks" : boolean = true
    "enable_notifications" : boolean = true
    "enable_event_handlers" : boolean = true
    "process_performance_data" : boolean = true
    "service_perfdata_command" : icinga2_commandstrings = list("process-service-perfdata")
    "host_perfdata_command" : icinga2_commandstrings = list("process-host-perfdata")
    "host_perfdata_file" : string = "/var/icinga2/host-perf.dat"
    "service_perfdata_file" : string = "/var/icinga2/service-perf.dat"
    "host_perfdata_file_template" : string = "[HOSTPERFDATA]\t$TIMET$\t$HOSTNAME$\t$HOSTEXECUTIONTIME$\t$HOSTOUTPUT$\t$HOSTPERFDATA$"
    "service_perfdata_file_template" : string = "[SERVICEPERFDATA]\t$TIMET$\t$HOSTNAME$\t$SERVICEDESC$\t$SERVICEEXECUTIONTIME$\t$SERVICELATENCY$\t$SERVICEOUTPUT$\t$SERVICEPERFDATA$"
    "host_perfdata_file_mode" : string = "a"
    "service_perfdata_file_mode" : string = "a"
    "host_perfdata_file_processing_interval" : long = 0
    "service_perfdata_file_processing_interval" : long = 0
    "host_perfdata_file_processing_command" ? icinga2_commandstrings
    "service_perfdata_file_processing_command" ? icinga2_commandstrings
    "allow_empty_hostgroup_assignment" ? boolean
    "obsess_over_services" : boolean = false
    "check_for_orphaned_services" : boolean = true
    "check_service_freshness" : boolean = true
    "service_freshness_check_interval" : long = 60
    "check_host_freshness" : boolean = true
    "host_freshness_check_interval" : long = 60
    "status_update_interval" : long = 30
    "enable_flap_detection" : boolean = true
    "low_service_flap_threshold" : long = 15
    "high_service_flap_threshold" : long = 25
    "low_host_flap_threshold" : long = 5
    "high_host_flap_threshold" : long = 20
    "date_format" : string = "euro"
    "p1_file" ? string = "/usr/bin/p1.pl"
    "enable_embedded_perl" : boolean = false
    "use_embedded_perl_implicitly" : boolean = true
    "stalking_event_handlers_for_hosts" : boolean = false
    "stalking_event_handlers_for_services" : boolean = false
    "illegal_object_name_chars" : string = "`~!$%^&*|'<>?,()\""
    "illegal_macro_output_chars" : string = "`~$^&|'<>\""
    "use_regexp_matching" : boolean = true
    "use_true_regexp_matching" : boolean = false
    "admin_email" : string = "icinga"
    "admin_pager" : string = "pageicinga"
    "daemon_dumps_core" : boolean = false
    # To be used on icinga v3
    "check_result_path" ? string
    "precached_object_file" ? string = "/var/icinga2/objects.precache"
    "temp_path" ? string
    "retained_host_attribute_mask" ? boolean
    "retained_service_attribute_mask" ? boolean
    "retained_process_host_attribute_mask" ? boolean
    "retained_process_service_attribute_mask" ? boolean
    "retained_contact_host_attribute_mask" ? boolean
    "retained_contact_service_attribute_mask" ? boolean
    "max_check_result_file_age" ? long
    "translate_passive_host_checks" ? boolean
    "passive_host_checks_are_soft" ? boolean
    "enable_predictive_host_dependency_checks" ? boolean
    "enable_predictive_service_dependency_checks" ? boolean
    "cached_host_check_horizon" ? long
    "cached_service_check_horizon" ? long
    "use_large_installation_tweaks" ? boolean
    "free_child_process_memory" ? boolean
    "child_processes_fork_twice" ? boolean
    "enable_environment_macros" ? boolean
    "soft_state_dependencies" ? boolean
    "ochp_timeout" ? long
    "ochp_command" ? string
    "use_timezone" ? string
    "broker_module" ? string[]
    "debug_file" ? string
    "debug_level" ? long
    "debug_verbosity" ? long (0..2)
    "max_debug_file_size" ? long
    "ocsp_command" ? string
    "check_result_path" : string = "/var/icinga2/checkresults"
    "event_profiling_enabled" : boolean = false
    "additional_freshness_latency" ? long
    "check_for_orphaned_hosts" ? boolean
    "check_result_reaper_frequency" ? long
    "keep_unknown_macros" ? boolean
    "max_check_result_reaper_time" ? long
    "obsess_over_hosts" ? boolean
    "service_check_timeout_state" ? string
    "stalking_notifications_for_hosts" ? boolean
    "stalking_notifications_for_services" ? boolean
    "syslog_local_facility" ? long
    "use_daemon_log" ? boolean
    "use_syslog_local_facility" ? boolean
} = dict();

type structure_icinga2_service_list=structure_icinga_service[];

type structure_icinga2_ido2db_cfg = {
    "lock_file" : string = "/var/icinga2/ido2db.lock"
    "ido2db_user" : string = "icinga"
    "ido2db_group" : string = "icinga"
    "socket_type" : string = "unix"
    "socket_name" : string = "/var/icinga2/ido.sock"
    "tcp_port" : long = 5668
    "use_ssl" : boolean = false
    "db_servertype" : string = "pgsql"
    "db_host" : string = "localhost"
    "db_port" : long = 5432
    "db_name" : string = "icinga"
    "db_prefix" : string = "icinga2_"
    "db_user" : string = "icinga"
    "db_pass" : string = "icinga"
    "max_timedevents_age" : long = 60
    "max_systemcommands_age" : long = 1440
    "max_servicechecks_age" : long = 1440
    "max_hostchecks_age" : long = 1440
    "max_eventhandlers_age" : long = 10080
    "max_externalcommands_age" : long = 10080
    "clean_realtime_tables_on_core_startup" : boolean = true
    "clean_config_tables_on_core_startup" : boolean = true
    "trim_db_interval" : long = 3600
    "housekeeping_thread_startup_delay" : long = 300
    "debug_level" : long = 0
    "debug_verbosity" : long = 1
    "debug_file" : string = "/var/icinga2/ido2db.debug"
    "max_debug_file_size" : long = 100000000
    "oci_errors_to_syslog" : boolean = true
    "debug_readable_timestamp" ? boolean
    "max_acknowledgements_age" ? long
    "max_contactnotificationmethods_age" ? long
    "max_contactnotifications_age" ? long
    "max_logentries_age" ? long
    "max_notifications_age" ? long
    "socket_perm" ? string
} = dict();

# Everything that can be handled by this component
type structure_component_icinga2 = {
    include structure_component
    "ignore_hosts" ? string[]
    "hosts" : structure_icinga2_host {}
    "hosts_generic" ? structure_icinga2_host_generic {}
    "hostgroups" ? structure_icinga2_hostgroup {}
    "hostdependencies" ? structure_icinga2_hostdependency {}
    "services" : structure_icinga2_service_list {}
    "servicegroups" ? structure_icinga2_servicegroup {}
    "general" : structure_icinga2_icinga_cfg
    "cgi" : structure_icinga2_cgi_cfg
    "serviceextinfo" ? structure_icinga2_serviceextinfo []
    "servicedependencies" ?  structure_icinga2_servicedependency []
    "timeperiods" : structure_icinga2_timeperiod {}
    "contacts" : structure_icinga2_contact {}
    "contactgroups" : structure_icinga2_contactgroup {}
    "commands" : string {}
    "macros" ? string {}
    "external_files" ? string[]
    "external_dirs" ? string[]
    "ido2db" : structure_icinga2_ido2db_cfg
    # Service escalations and dependencies are left for later
    # versions.
};

bind "/software/components/icinga2" = structure_component_icinga2;

