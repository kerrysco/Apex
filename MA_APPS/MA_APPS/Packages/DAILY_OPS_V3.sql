CREATE OR REPLACE PACKAGE ma_apps."DAILY_OPS_V3" AS 

  -- Procedures to generate the Daily Ops Report
  
  -- Generate the sections titles.
  function gen_title (ptitle in varchar2) return varchar2;
  
  procedure gen_email_head (pout out varchar2);
  
  -- Generate the Logo and header.
  procedure gen_header (pout out varchar2);
  
  -- Generate the Datacenter Risk Status table.
  procedure gen_risk (pout out varchar2);
  
  -- Generate the Issue tables column headings.
  procedure gen_status_start (pout out varchar2);
  
  -- Generate the Issue tables rows.
  procedure gen_status_row (pissue_status_name in varchar2,
                            ptarget_date in date,
                            powner_name in varchar2,
                            pjob_name in varchar2,
                            pdaily_operations_id in number,
                            preported_date in date,
                            pnext_update in date,
                            pout out varchar2);
  
  -- Generate the Issue tables total line.
  procedure gen_status_end (prec_total in number, pout out varchar2);
  
  -- Generate the Comments section.
  procedure gen_comments (pout out varchar2);
  
  -- Generate the Attendance section.
  procedure gen_attendees (pout out varchar2);
  
  -- Generate the Executive Report Status sections.
  procedure exec_status (pissue in varchar2, pout out varchar2);
  
  -- Generate the Executive Report Issue Counts
  procedure gen_exec_counts (pout out varchar2);
  
  -- Generate the report footer.
  procedure gen_footer (pout out varchar2);
  
  -- Execute the sections and email to distribution list.
  procedure send_html;
  
  -- Execute the Executive report and email.
  procedure exec_html;

end DAILY_OPS_V3;
/