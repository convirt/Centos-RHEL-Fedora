insert into operations(name,description,display_name,display_id,display,has_separator,display_seq,icon,created_by,created_date,modified_by,modified_date) values('START_VIEW_CONSOLE','START_VIEW_CONSOLE','Start and View Console', 'start_view_console', 1,0,113,'start_view_console.png','',now(),'',now());
insert into operation_opgroup(op_id,opgroup_id) select operations.id,operation_groups.id from operations,operation_groups where operations.name='START_VIEW_CONSOLE' AND operation_groups.name='FULL_DOMAIN';
insert into operation_opgroup(op_id,opgroup_id) select operations.id,operation_groups.id from operations,operation_groups where operations.name='START_VIEW_CONSOLE' AND operation_groups.name='OP_DOMAIN';
insert into ops_enttypes(op_id,entity_type_id) select operations.id,entity_types.id from operations,entity_types where operations.name='START_VIEW_CONSOLE' AND entity_types.name='DOMAIN';


