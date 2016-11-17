CREATE OR REPLACE PACKAGE BODY ma_apps."DAILY_UPDATES_V2" as

  -- begin
  --     ctx_ddl.create_policy('REC_DAILY_POLICY','CTXSYS.AUTO_FILTER');
  -- end;
  -- grant execute on ctx_ddl to ma_apps
  --
  
  --  Default email message for non-html clients.
  l_body clob := 'To view the content of this message, ' ||
                 'please use an HTML enabled mail client.' ||
                  utl_tcp.crlf;

  ------------------------------------------------------------------------------
  --  no_html function
  --    Cleans html tags from strings.
  --    Returns the cleaned string.
  ------------------------------------------------------------------------------
  function no_html (p_clob in clob) return clob as
    
    v_blob        blob;
    v_clob        clob;
    v_dest_offset number := 1;
    v_src_offset  number := 1;
    v_lang        number := 0;
    v_warning     varchar2(1000);
    
  begin
    -- Convert to blob.
    dbms_lob.createtemporary(v_blob, FALSE);
    dbms_lob.converttoblob( v_blob,
                            p_clob,
                            DBMS_LOB.LOBMAXSIZE,
                            v_dest_offset,
                            v_src_offset,
                            DBMS_LOB.DEFAULT_CSID,
                            v_lang,
                            v_warning);
     dbms_lob.createtemporary(v_clob, TRUE);
     -- Filter out the tags.
     ctx_doc.policy_filter('REC_DAILY_POLICY', v_blob, v_clob, TRUE);
     dbms_lob.freetemporary(v_blob);
     return v_clob;
     dbms_lob.freetemporary(v_clob);
     
  end no_html;

  ------------------------------------------------------------------------------
  --  get_daily_updates function
  --    Concatenates all the update records together for display in reports.
  --    Returns an html tables containing the update information.
  ------------------------------------------------------------------------------
  function get_daily_updates (p_daily_operations_id number) return clob as
  
    l_str clob;         -- Holds the update text with tags.
    l_cnt number := 0;  -- Indicator of records found.
    
  begin
  
    -- Initialize the table.
    l_str := '<table class="inlineTable">';
    l_str := l_str ||
             '<tr><th>Date of Update</th><th align="center">Update</th></tr>';
       
    -- Loop through any records, building the html table.
    for cur in (
      select
        to_char(update_date,'MM/DD/YYYY') update_date,
        replace(update_desc,'<html><head><title>') update_desc
      from
        rec_daily_update
      where
        daily_operations_id = p_daily_operations_id
      order
        by rec_daily_update.daily_update_id desc )
    loop

      -- Build a row of data.
      l_str := l_str || '<tr>';
      l_str := l_str || '<td nowrap style="width:100px">' ||
               cur.update_date || '</td><td>' ||
               substr(cur.update_desc,1,60)||'...' || '</td>';
      l_str    := l_str || '</tr>';
      l_cnt    := l_cnt + 1;
      
    end loop;
    
    -- End the table.
    l_str    := l_str || '</table>';

    -- Return a result.
    if l_cnt = 0 then
      return '';
    else
     return l_str;
    end if;

  end get_daily_updates;

  ------------------------------------------------------------------------------
  --  get_daily_update_full function
  --    Concatenates all the update records together for display in reports.
  --    Returns an html tables containing the update information.
  --    Not limited to width 100.
  ------------------------------------------------------------------------------
  function get_daily_updates_full (p_daily_operations_id number) return clob as
  
    l_str clob;         -- Holds the update text with tags.
    l_cnt number := 0;  -- Indicator of records found.
    
  begin
  
    -- Initialize the table.
    l_str := '<table class="inlineTable">';
    l_str := l_str ||
             '<tr><th>Date of Update</th><th align="center">Update</th></tr>';

    -- Loop through any records, building the html table.       
    for cur in (
      select
        to_char(update_date,'MM/DD/YYYY') update_date,
        replace(update_desc,'<html><head><title>') update_desc
      from
        rec_daily_update
      where
        daily_operations_id = p_daily_operations_id
      order by
        rec_daily_update.daily_update_id )
    loop
    
      -- Build a row of data.
      l_str := l_str || '<tr>';
      l_str := l_str || '<td nowrap>' ||
               cur.update_date || '</td><td>' ||
               cur.update_desc || '</td>';
      l_str := l_str || '</tr>';
      l_cnt := l_cnt + 1;
      
    end loop;

    -- End the table.    
    l_str    := l_str || '</table>';

    -- Return a result.
    if l_cnt = 0 then
      return '';
    else
      return l_str;
    end if;

  end get_daily_updates_full;

  ------------------------------------------------------------------------------
  --  chk_target_date function
  --    Validates if target date can be changed.
  --    Input: daily_operations_id - used to look up the issue history.
  --    Returns true if the data can be changed.
  ------------------------------------------------------------------------------  
  function chk_target_date (p_daily_operations_id in number,
                            p_target_date in date) return BOOLEAN as
  
    v_changes number;
    
  begin
  
    select
      count(*)
    into
      v_changes
    from
      rec_target_history
    where
      v('APP_USER') not in ( select
                                upper(hem_login)
                              from
                                rec_hems) and
      owner_id not in ( select
                          owner_id
                        from
                          rec_issue_owner
                        where
                          loader = 'Y') and
      daily_operations_id = p_daily_operations_id and
      target_date != p_target_date;
    
    if v_changes > 0 then
      return FALSE;
    end if;
    
    return TRUE;
  
  exception
    when others then
      return TRUE;
  end chk_target_date;
  
  ------------------------------------------------------------------------------
  --  get_status_color process
  --    Set status color to return to APEX.
  --    Input: target_date - date to address issue.
  --           reported_date - date issue was discovered.
  --           status_id - Status of the issue.
  ------------------------------------------------------------------------------  
  function get_status_color ( p_target_date date,
                              p_reported_date date,
                              p_status_id number ) return varchar2 as
  begin
  
    -- If "in progress" and past the target date, then red.
    if p_status_id = 2 and (sysdate >= p_target_date or p_target_date is null) then
      return 'red';
    else
      -- If more than 1 day after report and not past the target, "in progress"
      if sysdate >= p_reported_date + 1 and sysdate < p_target_date and p_status_id = 2 then
        return 'DarkOrange';
      else
        return 'green';
      end if;
    end if;
    
  end get_status_color;

  ------------------------------------------------------------------------------
  --  update_warning process
  --    Input:  buffer - number of days allowed
  --
  --    Note: This procedure may be un-implemented.
  ------------------------------------------------------------------------------    
  procedure update_warning (p_buffer number)
  as
  begin
  
    for crec in (
      select 
        a.daily_operations_id daily_operations_id,
        a.next_update next_update,
        c.owner_name owner_name,
        b.m_date
      from
        rec_daily_operations a,
        rec_issue_owner c,
        ( select
            daily_operations_id,
            max(update_date) m_date 
          from
            rec_daily_update
          group by
            daily_operations_id ) b
      where
        a.daily_operations_id = b.daily_operations_id and
        a.owner_id = c.owner_id and
        trunc(sysdate) >= trunc(a.next_update + p_buffer) and
        trunc(b.m_date) < trunc(a.next_update) and
        a.issue_status_id != 3 )    
    loop
    
      insert into rec_daily_update
      values (
        rec_daily_update_seq.nextval,
        crec.daily_operations_id,
        crec.owner_name,
        sysdate,
        'No New Update' );
      
      update rec_daily_operations
      set next_update = sysdate
      where daily_operations_id = crec.daily_operations_id;
      
      commit;
      
    end loop;
    
  end update_warning;

  ------------------------------------------------------------------------------
  --  load_jams process
  --    Input:  buffer - number of days allowed
  --
  --    Note: This procedure may be un-implemented.
  ------------------------------------------------------------------------------    
  procedure load_jams (o_result out number) as
    
  begin
    
    -- Days issues were loaded by APEX into a staging table. Loop through
    -- and insert to the "rec" tables.
    for c1 in (
      select
        issue_name,
        error_desc,
        reported_date
      from
        rec_load )
    loop
    
      insert into rec_daily_operations (
        daily_operations_id,
        issue_status_id,
        owner_id,
        issue_type_id,
        job_name,
        reported_date,
        target_date,
        next_update,
        request_close )
      values (
        rec_daily_operations_seq.nextval,
        1,  -- New
        81, -- Anna
        3,  -- JAMS Issue
        c1.issue_name,
        c1.reported_date,
        c1.reported_date + 1,
        c1.reported_date + 1,
        'N' );
      
      insert into rec_daily_update (
        daily_update_id,
        daily_operations_id,
        update_user,
        update_date,
        update_desc )
      values (
        rec_daily_update_seq.nextval,
        rec_daily_operations_seq.currval,
        'ABLIN',
        c1.reported_date,
        no_html(c1.error_desc) );
        
    end loop;
    
    delete from rec_load;
    
    commit;
    
    o_result := 0;
  
  exception
    when others then
      o_result := 1;
  end load_jams;

  ------------------------------------------------------------------------------
  --  resolve_dupes process
  --    Handles cross-reference of repeating issues.
  --    Input:  operations_id - used to look up the issue.
  --            update_id - used to look up the updates.
  --            job_desc - Name for the issue.
  --    Output: result - error code.
  ------------------------------------------------------------------------------      
  procedure resolve_dupes (poperations_id in number,
                           pupdate_id in number,
                           pjob_desc in varchar2,
                           o_result out number) as
                           
    vinit_ops_id    number;     -- Initial ops_id.
    vinit_owner_id  number;     -- Initial issue owner.
    vinit_email varchar2(120);  -- Initial owner email.
    vdupe_date      date;       -- Date of issue reoccurance. Use to mark initial.
    vinit_upd_date  date;       -- Data if the initial issue. Use to mark dupe.
    e_out           clob;       -- concatenated html output
    
  begin
     
    -- get all the open issues with matching names.
    for crec1 in (
      select
        rdo.daily_operations_id,
        rdo.owner_id,
        rio.owner_email,
        rdu.daily_update_id,
        rdu.update_date,
        rdu.update_desc
      from
        rec_daily_operations rdo,
        rec_daily_update rdu,
        rec_issue_owner rio
      where
        rdo.daily_operations_id = rdu.daily_operations_id and
        rdo.owner_id = rio.owner_id and
        rdo.job_name = pjob_desc and
        rdo.closed_date is null and
        rdo.issue_type_id in (3,42)
      order by
        daily_operations_id desc,
        daily_update_id desc )
    loop

      -- If this is the record that was marked by the user, it is the dupe.
      if crec1.daily_update_id = pupdate_id then     
        vdupe_date := crec1.update_date;
      end if;
      
      -- Save the values for the record so we have the last record, which is
      -- the first occurrance of the issue.
      vinit_ops_id := crec1.daily_operations_id;
      vinit_upd_date := crec1.update_date;
      vinit_owner_id := crec1.owner_id;
      vinit_email := crec1.owner_email;
      

    end loop;
    
    -- New we have all the data needed to cross-reference the dupe to the
    -- original.
    if vinit_ops_id != poperations_id then
    
      -- Update the old issue with a reference to the current dupe.
      insert into rec_daily_update (
        daily_update_id,
        daily_operations_id,
        update_user,
        update_date,
        update_desc )
      values (
        rec_daily_update_seq.nextval,
        vinit_ops_id,
        v('APP_USER'),
        trunc(sysdate),
        'Issue reoccurred on '||to_char(vdupe_date,'MM/DD/YYYY'));
      
      -- Update the duplicate issue with a reference to old issue.
      insert into rec_daily_update (
        daily_update_id,
        daily_operations_id,
        update_user,
        update_date,
        update_desc )
      values (
        rec_daily_update_seq.nextval,
        poperations_id,
        v('APP_USER'),
        trunc(sysdate),
        'Duplicate of issue that ocurred on ' ||
          to_char(vinit_upd_date,'MM/DD/YYYY')); 
  
      -- Set the issue to duplicate.
      update rec_daily_operations
      set issue_status_id = 23,
          owner_id = vinit_owner_id
      where
        daily_operations_id = poperations_id;
  
      commit;

      -- Send email to the owner, that there was a re-occurrance of the issue.
      e_out := 'The JAMS/Backup issue "'||pjob_desc||
               '" first reported on '||
               to_char(vinit_upd_date,'MM/DD/YYYY')||
               ' and assigned to you, has re-occurred on '||
               to_char(vdupe_date,'MM/DD/YYYY')||
               '. View at http://maorautlcdb.marketingassociates.com:8081/apex/f?p=103:1';

      apex_mail.send(
        p_to => vinit_email,
--        p_to   => 'kscott@marketingassociates.com',
        p_from => 'MIS-Operations@marketingassociates.com',
        p_body      => l_body,
        p_body_html => e_out,
        p_subj      => 'Information Technology Daily Status Issue');
       
      o_result := 0;
      
    else
    
      -- The chosen record was the original. This is not allowed.
      o_result := 1;
     
    end if;
  
  exception
    when others then
      o_result := 2;
  end resolve_dupes;
  
  ------------------------------------------------------------------------------
  --  send_alert process
  --    Notification of owner change.
  --    Input:  operations_id - used to look up the issue.
  --            issue_status_id - used to look up the issue status.
  --            owner_id - used to look up the owner name/email.
  --            issue_type_id - used to look up the type of issue.
  --            job_desc - Name for the issue.
  --            reported_date - date the issue was reported.
  ------------------------------------------------------------------------------
  procedure send_alert (p_type in varchar2,
                        p_daily_operations_id in number,
                        p_issue_status_id in number,
                        p_owner_id in number,
                        p_issue_type_id in number,
                        p_job_name in varchar2,
                        p_reported_date in date) as

    e_out clob;           -- concatenated email output.
    
    -- Lookup column definitions.
    v_issue_status_name   rec_issue_status.issue_status_name%type;
    v_owner_email         rec_issue_owner.owner_email%type;
    v_loader              rec_issue_owner.loader%type;
    v_issue_type_name     rec_issue_type.issue_type_name%type;
    v_update_desc         rec_daily_update.update_desc%type;

  begin

    -- Get the issue status.
    select
      issue_status_name
    into
      v_issue_status_name
    from
      rec_issue_status
    where
      issue_status_id = p_issue_status_id;
    
    -- Get the owner email address.
    select
      owner_email,
      nvl(loader,'N')
    into
      v_owner_email,
      v_loader
    from
      rec_issue_owner
    where
      owner_id = p_owner_id;
    
    -- Get the type of issue.
    select
      issue_type_name
    into
      v_issue_type_name
    from
      rec_issue_type
    where
      issue_type_id = p_issue_type_id;

    -- Block for error handling.
    begin
      -- Get the initial update description.
      select
        rdu.update_desc
      into
        v_update_desc
      from
        rec_daily_update rdu,
        ( select
            daily_operations_id,
            min(daily_update_id) first_update
          from
            rec_daily_update
          group by
            daily_operations_id ) fup
      where
        rdu.daily_operations_id = fup.daily_operations_id and
        rdu.daily_operations_id = p_daily_operations_id and
        rdu.daily_update_id = fup.first_update;
    exception
      when no_data_found then
        v_update_desc := 'Not yet entered.';
    end;

    -- A record was inserted to daily ops.    
    if p_type = 'I' then

      -- As long as the owner is not the loader of data, send notification.
      if v_loader != 'Y' then

        -- If no rows returned, then no email to send. Owner was a loader.
        e_out := 'The '||rtrim(v_issue_type_name,'s')||' "'||p_job_name||
                 '" has been assigned to you.'||
                 ' The issue was reported on '||
                 to_char(p_reported_date, 'MM/DD/YYYY')||'.'||
                 ' Error: '||v_update_desc||'   '||
                 ' View at http://maapexapp01.marketingassociates.com/apex/appdev/f?p=103:1';

        apex_mail.send(
          p_to => v_owner_email,
--          p_to   => 'kscott@marketingassociates.com',
          p_from => 'MIS-Operations@marketingassociates.com',
          p_body      => l_body,
          p_body_html => e_out,
          p_subj      => 'Information Technology Daily Status Issue');

      end if;

    -- A record was updated or is a recurring issue.
    elsif p_type = 'R' then
    
      e_out := 'The '||rtrim(v_issue_type_name,'s')||' "'||p_job_name||
         '" with status -'||v_issue_status_name||
         '- has been re-assigned to you.'||
         ' The issue was reported on '||
         to_char(p_reported_date, 'MM/DD/YYYY')||'.'||
         ' Error: '||v_update_desc||'   '||
         ' View at http://maapexapp01.marketingassociates.com/apex/appdev/f?p=103:1';

      apex_mail.send(
        p_to => v_owner_email,
--        p_to   => 'kscott@marketingassociates.com',
        p_from => 'MIS-Operations@marketingassociates.com',
        p_body      => l_body,
        p_body_html => e_out,
        p_subj      => 'Information Technology Daily Status Issue');
          
    end if;

  exception
    when others then
      raise_application_error(-20210,sqlerrm);
  end send_alert;

  ------------------------------------------------------------------------------
  --  mark_customer
  --    Marks an new issue as handled by the customer.
  --    Input:  operations_id - used to look up the issue.
  --            job_id - used to look up a matching job definition.
  --            customer_id - used to look up the customer.
  --    Output: o_result - error code.
  ------------------------------------------------------------------------------
  procedure mark_customer (poperations_id in number,
                           powner_id in number,
                           o_result out number) as
  begin

    -- Need to mark the issue as closed and note the action.
    -- Send an email to the HEM.
    
          -- Set the issue to duplicate.
      update rec_daily_operations
      set issue_status_id = 3,
          owner_id = powner_id,
          closed_date = trunc(sysdate),
          request_close = 'Y'
      where
        daily_operations_id = poperations_id;
        
      -- Update the closed issue with a reference to the customer.
      insert into rec_daily_update (
        daily_update_id,
        daily_operations_id,
        update_user,
        update_date,
        update_desc )
      values (
        rec_daily_update_seq.nextval,
        poperations_id,
        v('APP_USER'),
        trunc(sysdate),
        'Information sent to the client. '||
        'Client supports this job and is responsible for the issue. '||
        'Closing issue.');
      
      commit;
      
      o_result := 0;
      
  exception
    when others then
      raise_application_error(-20210,sqlerrm);
  end mark_customer;
  
end daily_updates_v2;
/