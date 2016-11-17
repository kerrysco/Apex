CREATE OR REPLACE PROCEDURE ma_apps."SEND_EMAIL" ( recipient in varchar2,
                                         subject   in varchar2,
                                         message   in varchar2) as
                                         
  mailhost      varchar2(100);
  mail_conn     utl_smtp.connection;
  sender        varchar2(60) := 'MIS-Operations@marketingassociates.com';
  t_dbname      varchar2(60);
  commapos      number(3) := 0;
  recipientlist varchar2(2000);
  subrecipient  varchar2(50) := '';
  cursor c_dbname is
    select
      global_name
    from
      global_name;
  cursor c_host is
    select
      host_name
    from
      v$instance;
begin

  open c_dbname;
  fetch c_dbname into t_dbname;
  close c_dbname;
  open c_host;
  fetch c_host into mailhost;
  close c_host;

  mail_conn := utl_smtp.open_connection(mailhost);
  utl_smtp.helo(mail_conn,mailhost);
  utl_smtp.mail(mail_conn,sender);
  commapos := instr(recipient, ';');

  if commapos > 0 then
    recipientlist := recipient;
    loop
      subrecipient := substr(recipientlist, 1,
                             instr(recipientlist, ';', 1, 1) - 1);
      utl_smtp.rcpt(mail_conn, subrecipient);
      commapos := instr(recipientlist, ';');
      recipientlist := ltrim(substr(recipientlist, commapos + 1));
      commapos := instr(recipientlist, ';');
      if commapos = 0 then
        utl_smtp.rcpt(mail_conn, recipientlist);
        exit;
      end if;
    end loop;
  else
    utl_smtp.rcpt(mail_conn, recipient);
  end if;
  
  utl_smtp.open_data(mail_conn);
  utl_smtp.write_data(mail_conn,
                      'Subject: ' || t_dbname ||': '|| subject || utl_tcp.CRLF);
  utl_smtp.write_data(mail_conn, 'To: ' || recipient || utl_tcp.CRLF);
  utl_smtp.write_data(mail_conn, utl_tcp.CRLF||message);
  utl_smtp.close_data(mail_conn);
  utl_smtp.quit(mail_conn);
  
exception
  when utl_smtp.transient_error or utl_smtp.permanent_error then
    utl_smtp.quit(mail_conn);
    raise_application_error(-20000,'Failed to send mail due to the following error: ' || sqlerrm);
  when others then
    raise_application_error(-20001,'The following error has occured: ' || sqlerrm);
end;
/