CREATE OR REPLACE PACKAGE ma_apps."DAILY_UPDATES_V2" as

  -- Clean out html tags.
  FUNCTION no_html (p_clob in clob) return clob;

  -- Generate html table of updates.
  FUNCTION get_daily_updates (p_daily_operations_id number) return clob;
  
  -- Generate html table of updates, no width restriction.
  FUNCTION get_daily_updates_full (p_daily_operations_id number) return clob;
  
  -- Make sure target date is not changed too often.
  FUNCTION chk_target_date (p_daily_operations_id in number,
                            p_target_date in date) return boolean;
  
  -- Get the html color tag for status.  
  FUNCTION get_status_color (p_target_date date,
                             p_reported_date date,
                             p_status_id number ) return varchar2;
  
  -- Warn when there are no updates on or after the update date setting.
  PROCEDURE update_warning (p_buffer number);
  
  -- Process to move CSV loaded data the the rec_daily_operations table.
  PROCEDURE load_jams (o_result out number);
  
  -- Resolve the re-occurrances.
  PROCEDURE resolve_dupes (poperations_id in number,
                           pupdate_id in number,
                           pjob_desc in varchar2,
                           o_result out number);
  
  -- Send email notifications of triggering events.               
  PROCEDURE send_alert (p_type in varchar2,
                        p_daily_operations_id in number,
                        p_issue_status_id in number,
                        p_owner_id in number,
                        p_issue_type_id in number,
                        p_job_name in varchar2,
                        p_reported_date in date);
                        
  PROCEDURE mark_customer (poperations_id in number,
                           powner_id in number,
                           o_result out number);
    
end daily_updates_v2;
/