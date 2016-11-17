CREATE OR REPLACE PACKAGE BODY ma_apps.DAILY_OPS_V3 AS

  -- HTML needed to produce the APEX preview and emails.
  -- Title section.
  title1 varchar2(4000) :=
  '<p class=MsoSubtitle><b><o:p>&nbsp;</o:p></b></p>
   <p class=MsoSubtitle><b>';
  title2 varchar2(1000) :=
  ':</b>
   <b><span style=''font-size:11.0pt;font-family:"Calibri",sans-serif;color:windowtext;letter-spacing:0pt;font-style:normal''> </span></b>
   <b><span style=''color:#1F497D''><o:p></o:p></span></b></p>
   <p class=MsoSubtitle>
   <span style=''font-size:10.0pt;font-family:"Calibri",sans-serif;color:windowtext;letter-spacing:0pt;font-style:normal''>
     <o:p>&nbsp;</o:p></span>
   </p>'||utl_tcp.crlf;
  -- Header.
  ehead1 varchar2(4000) :=
  '<html xmlns:v="urn:schemas-microsoft-com:vml"
     xmlns:o="urn:schemas-microsoft-com:office:office"
     xmlns:w="urn:schemas-microsoft-com:office:word" 
     xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" 
     xmlns="http://www.w3.org/TR/REC-html40">
     <head>
       <meta http-equiv=Content-Type content="text/html; charset=us-ascii">
       <meta name=Generator content="Microsoft Word 15 (filtered medium)">
     <!--[if !mso]>
     <style>v\:* {behavior:url(#default#VML);}
       o\:* {behavior:url(#default#VML);}
       w\:* {behavior:url(#default#VML);}
       .shape {behavior:url(#default#VML);}
     </style>
     <![endif]-->'||utl_tcp.crlf;
  ehead2 varchar2(4000) :=
  '<style>
   <!-- /* Font Definitions */
     @font-face {
       font-family: "Cambria Math";
       panose-1: 2 4 5 3 5 4 6 3 2 4;
     }
     @font-face {
     font-family: Calibri;
     panose-1: 2 15 5 2 2 2 4 3 2 4;
     }
     @font-face {
     font-family: Cambria;
     panose-1: 2 4 5 3 5 4 6 3 2 4;
     }
     /* Style Definitions */
     p.MsoNormal,
     li.MsoNormal,
     div.MsoNormal {
     margin: 0in;
     margin-bottom: .0001pt;
     font-size: 9.0pt;
     font-family: "Arial", sans-serif;
     }
     p.MsoSubtitle,
     li.MsoSubtitle,
     div.MsoSubtitle {
       mso-style-priority: 11;
       mso-style-link: "Subtitle Char";
       margin: 0in;
       margin-bottom: .0001pt;
       font-size: 14.0pt;
       font-family: "Arial", sans-serif;
       color: #003399;
       letter-spacing: .75pt;
       font-style: normal;
     }
     a:link,
     span.MsoHyperlink {
       mso-style-priority: 99;
       color: #0563C1;
       text-decoration: underline;
     }
     a:visited,
     span.MsoHyperlinkFollowed {
       mso-style-priority: 99;
       color: #954F72;
       text-decoration: underline;
     }
     p.MsoAutoSig,
     li.MsoAutoSig,
     div.MsoAutoSig {
       mso-style-priority: 99;
       mso-style-link: "E-mail Signature Char";
       margin: 0in;
       margin-bottom: .0001pt;
       font-size: 11.0pt;
       font-family: "Calibri", sans-serif;
     }
     p.MsoListParagraph,
     li.MsoListParagraph,
     div.MsoListParagraph {
       mso-style-priority: 34;
       margin-top: 0in;
       margin-right: 0in;
       margin-bottom: 0in;
       margin-left: .5in;
       margin-bottom: .0001pt;
       font-size: 11.0pt;
       font-family: "Calibri", sans-serif;
     }
     span.SubtitleChar {
       mso-style-name: "Subtitle Char";
       mso-style-priority: 11;
       mso-style-link: Subtitle;
       font-family: "Cambria", serif;
       color: #4F81BD;
       letter-spacing: .75pt;
       font-style: italic;
     }
     span.E-mailSignatureChar {
       mso-style-name: "E-mail Signature Char";
       mso-style-priority: 99;
       mso-style-link: "E-mail Signature";
       font-family: "Times New Roman", serif;
     }
     span.EmailStyle22 {
       mso-style-type: personal;
       font-family: "Calibri", sans-serif;
       color: windowtext;
     }
     span.EmailStyle23 {
       mso-style-type: personal-reply;
       font-family: "Calibri", sans-serif;
       color: #1F497D;
     }
     .MsoChpDefault {
     mso-style-type: export-only;
     font-size: 10.0pt;
     }
     @page WordSection1 {
     size: 8.5in 11.0in;
     margin: 1.0in 1.0in 1.0in 1.0in;
     }
     div.WordSection1 {
     page: WordSection1;
     }
     -->
   </style>
   <!--[if gte mso 9]>
     <xml><o:shapedefaults v:ext="edit" spidmax="1026" /></xml>
   <![endif]-->
   <!--[if gte mso 9]><xml>
     <o:shapelayout v:ext="edit">
     <o:idmap v:ext="edit" data="1" />
     </o:shapelayout></xml><![endif]--></head>
     <body lang=EN-US link="#0563C1" vlink="#954F72">
     <p class=MsoNormal>
     <o:p>&nbsp;</o:p>
     </p>'||utl_tcp.crlf;
  -- Report header.
  header1 varchar2(4000) :=
  '<p class="MsoNormal"><o:p>&nbsp;</o:p></p>
   <p class="MsoNormal">
     <span style="color:#1F497D"><img width="290" height="53" id="Picture_x0020_1" src="http://maorautlcdb.marketingassociates.com:8081/i/malogo522x92.jpg" alt="cid:image001.jpg@01CFCE88.F387A160"></span>
     &nbsp;&nbsp;&nbsp;<o:p></o:p></p>
   <p class="MsoNormal"><o:p>&nbsp;</o:p></p>
   <p class="MsoSubtitle">
     <span style="font-size:14.0pt;font-family:&quot;Arial&quot;,sans-serif;color:#003399;font-style:normal">
       <b>Information Technology Daily Status Report&nbsp; <o:p></o:p></span>
       </b></p>
   <p class="MsoSubtitle">
     <span style="font-size:14.0pt;font-family:&quot;Arial&quot;,sans-serif;color:#003399;font-style:normal"><b>Date: ';
  header2 varchar2(4000) :=
  '</b><o:p></o:p></span></p>
   </body><p class="MsoSubtitle"><b><o:p>&nbsp;</o:p></b></p>'||utl_tcp.crlf;
  -- Risk table.
  risk1 varchar2(4000) :=
  '<table class="MsoNormalTable" border="0" cellspacing="0"
   cellpadding="0" width="751" style="width:563.0pt;margin-left:-.4pt;border-collapse:collapse">
     <tr style="height:15.0pt">
       <td width="111" nowrap="" valign="top" style="width:83.0pt;border:solid windowtext 1.0pt;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
         <p class="MsoNormal"><b><span style=''color:black''>Status<o:p></o:p></span></b></p></td>
       <td width="285" nowrap="" valign="top" style="width:214.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
         <p class="MsoNormal"><b><span style=''color:black''>Area<o:p></o:p></span></b></p></td>
       <td width="355" nowrap="" valign="top" style="width:266.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt">
         <p class="MsoNormal"><b><span style=''color:black''>Description<o:p></o:p></span></b></p></td>
     </tr>';
  risk2 varchar2(4000) :=
  '<tr style=''height:15.0pt''>
   <td width=111 nowrap valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;border-top:none;background:';
  risk3 varchar2(4000) :=
  ';padding:0in 5.4pt 0in 5.4pt;height:15.0pt''><p class=MsoNormal><span style=''color:black''>';
  risk4 varchar2(4000) :=
  '<o:p></o:p></span></p></td>
   <td width=285 nowrap valign=top style=''width:214.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
   <p class=MsoNormal><span style=''color:black''>';
  risk5 varchar2(4000) :=
  '<o:p></o:p></span></p></td>
   <td width=355 valign=top style=''width:266.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
     <p class=MsoNormal><span style=''color:black''>';
  risk6 varchar2(4000) :=
  '<o:p></o:p></span></p></td></tr>';
  risk7 varchar2(4000) :=
  '<tr style=''height:15.0pt''>
   <td width=111 nowrap valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
     <p class=MsoNormal><b><span style=''color:black''>Total<o:p></o:p></span></b></p></td>
   <td width=285 nowrap valign=top style=''width:214.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
     <p class=MsoNormal><b><span style=''color:black''>&nbsp;<o:p></o:p></span></b></p></td>
   <td width=355 valign=top style=''width:266.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
     <p class=MsoNormal align=right style=''text-align:right''><b><span style=''color:black''>';
  risk8 varchar2(4000) :=
  '<o:p></o:p></span></b></p></td></tr></table>
   <p class="MsoSubtitle"><b><o:p>&nbsp;</o:p></b></p>';
  -- Status tables.
  h_status1 varchar2(4000) :=
  '<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=1232 style=''width:924.0pt;margin-left:-.4pt;border-collapse:collapse''>
   <tr style=''height:15.0pt''>
     <td width=111 nowrap valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal><b><span style=''color:black''>Status<o:p></o:p></span></b></p></td>
     <td width=145 nowrap valign=top style=''width:109.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal><b><span style=''color:black''>Owner<o:p></o:p></span></b></p></td>
     <td width=285 valign=top style=''width:214.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal><b><span style=''color:black''>Area/Project<o:p></o:p></span></b></p></td>
     <td width=355 valign=top style=''width:266.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal><b><span style=''color:black''>Description/Resolution<o:p></o:p></span></b></p></td>
     <td width=115 valign=top style=''width:86.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal align=right style=''text-align:right''><b><span style=''color:black''>Reported Date<o:p></o:p></span></b></p></td>
     <td width=111 valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal align=right style=''text-align:right''><b><span style=''color:black''>Target Date<o:p></o:p></span></b></p></td>
     <td width=111 valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal align=right style=''text-align:right''><b><span style=''color:black''>Next Update<o:p></o:p></span></b></p></td>
   </tr>';
  h_stat_row1 varchar2(4000) :=
  '<tr><td width=111 nowrap valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;border-top:none;background:';
  h_stat_row2 varchar2(4000) :=
  ';padding:0in 5.4pt 0in 5.4pt;''><p class=MsoNormal><span style=''color:black''>';           
  h_stat_row3 varchar2(4000) :=
  '<o:p></o:p></span></p></td>
   <td width=145 nowrap valign=top style=''width:109.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 5.4pt 0in 5.4pt;''>
   <p class=MsoNormal><span style=''color:black''>';
  h_stat_row4 varchar2(4000) :=
  '<o:p></o:p></span></p></td>
   <td width=285 valign=top style=''width:214.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:white;padding:0in 5.4pt 0in 5.4pt;''>
   <p class=MsoNormal><span style=''color:black''>';
  h_stat_row5 varchar2(4000) :=
  '<o:p></o:p></span></p></td>
   <td width=355 valign=top style=''width:266.0pt;word-break:break-all;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:white;padding:0in 5.4pt 0in 5.4pt;''>
   <p class=MsoNormal><span style=''color:black''>';
  h_stat_row6 varchar2(4000) :=
  '<o:p></o:p></span></p></td>
    <td width=115 valign=top style=''width:86.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:white;padding:0in 5.4pt 0in 5.4pt;''>
    <p class=MsoNormal align=right style=''text-align:right''>';
  h_stat_row7 varchar2(4000) :=
  '<o:p></o:p></p></td>
   <td width=111 valign=top style=''width:83.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:white;padding:0in 5.4pt 0in 5.4pt;''>
   <p class=MsoNormal align=right style=''text-align:right''>';
  h_stat_row8 varchar2(4000) :=
  '<o:p></o:p></p></td>
   <td width=111 valign=top style=''width:83.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:white;padding:0in 5.4pt 0in 5.4pt;''>
   <p class=MsoNormal align=right style=''text-align:right''>';
  h_stat_row9 varchar2(4000) :=
  '<o:p></o:p></p></td></tr>';
  h_stat_row10 varchar2(4000) :=
  '<tr style=''height:15.0pt''>
   <td width=111 nowrap valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;border-top:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
   <p class=MsoNormal><b><span style=''color:black''>Total<o:p></o:p></span></b></p></td>
   <td width=145 nowrap valign=top style=''width:109.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
   <p class=MsoNormal><b><span style=''color:black''>&nbsp;<o:p></o:p></span></b></p></td>
   <td width=285 valign=top style=''width:214.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
   <p class=MsoNormal><b><span style=''color:black''>&nbsp;<o:p></o:p></span></b></p></td>
   <td width=355 valign=top style=''width:266.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
   <p class=MsoNormal><b><span style=''color:black''>&nbsp;<o:p></o:p></span></b></p></td>
   <td width=115 valign=top style=''width:86.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
   <p class=MsoNormal align=right style=''text-align:right''><b>&nbsp;<o:p></o:p></b></p></td>
   <td width=111 valign=top style=''width:83.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
   <p class=MsoNormal align=right style=''text-align:right''><b>&nbsp;<o:p></o:p></b></p></td>
   <td width=111 valign=top style=''width:83.0pt;border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
   <p class=MsoNormal align=right style=''text-align:right''><b>';
  h_stat_row11 varchar2(4000) :=
  '<o:p></o:p></b></p></td></tr></table><p class="MsoSubtitle"><b><o:p>&nbsp;</o:p></b></p>';
  -- Comment section.
  h_comments1 varchar2(4000) :=
  '<p class=MsoNormal><b><span style=''font-size:9.0pt;font-family:"Arial",sans-serif''><o:p>&nbsp;</o:p></span></b></p>
   <p class=MsoSubtitle><b>Other Comments:<o:p></o:p></b></p>
   <p class=MsoNormal><span style=''font-size:9.0pt;font-family:"Arial",sans-serif''>
     Please dial in prior to 8am so we can start promptly at 8 am</p>
   <p class=MsoNormal><span style=''font-size:9.0pt;font-family:"Arial",sans-serif''>
     Please provide all informational updates by 8:45 am each morning so the meeting notes can go out by 9 am.
   </p>';
  -- Status tables for the Exec report.
  h_estatus1 varchar2(4000) :=
  '<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=1232 style=''width:924.0pt;margin-left:-.4pt;border-collapse:collapse''>
   <tr style=''height:15.0pt''>
     <td width=111 nowrap valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal><b><span style=''color:black''>Status<o:p></o:p></span></b></p></td>
     <td width=145 nowrap valign=top style=''width:109.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal><b><span style=''color:black''>Owner<o:p></o:p></span></b></p></td>
     <td width=285 valign=top style=''width:214.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal><b><span style=''color:black''>Area/Project<o:p></o:p></span></b></p></td>
     <td width=355 valign=top style=''width:266.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal><b><span style=''color:black''>Description/Resolution<o:p></o:p></span></b></p></td>
    <td width=115 valign=top style=''width:86.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal align=right style=''text-align:right''><b>Reported Date<o:p></o:p></b></p></td>
    <td width=111 valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal align=right style=''text-align:right''><b>Target Date<o:p></o:p></b></p></td>
    <td width=111 valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
       <p class=MsoNormal align=right style=''text-align:right''><b>Next Update<o:p></o:p></b></p></td></tr>';
  -- Exec report Issue count table.
  h_ecounts1 varchar2(4000) :=
  '<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=240 style=''width:240.0pt;border-collapse:collapse''>
   <tr style=''height:15.0pt''>
   <td width=90 nowrap valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;background:#999999;padding:0in 0in 0in 0in;height:15.0pt''>
     <p class=MsoNormal><span style=''color:black''>Issue<o:p></o:p></span></p></td>
   <td width=50 nowrap valign=top style=''width:36.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 0in 0in 0in;height:15.0pt''>
     <p class=MsoNormal align=center style=''text-align:center''>
     <span style=''color:black''>Open<o:p></o:p></span></p></td></tr>';
  h_ecounts2 varchar2(4000) :=
  '<tr><td nowrap rowspan=';
  h_ecounts3 varchar2(4000) :=
  ' valign=top style=''border:solid windowtext 1.0pt;border-top:none;padding:0in 0in 0in 0in;''>
     <p class=MsoNormal><span style=''color:black''>';
  h_ecounts4 varchar2(4000) :=
  '<o:p></o:p></span></p></td>
    <td width=18 valign=top style=''width:18.0pt;border:solid windowtext 1.0pt;border-left:none;padding:0in 5.4pt 0in 5.4pt;height:15.0pt''>
    <p class=MsoNormal><b><span style=''color:black''>';
  h_ecounts5 varchar2(4000) :=
  '<o:p></o:p></span></b></p></td></tr>';
  h_ecounts6 varchar2(4000) :=
  '</table>';
  -- Meeting attendance table.
  h_attend1 varchar2(4000) :=
  '<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=352 style=''width:264.0pt;border-collapse:collapse''>
    <tr style=''height:15.0pt''>
    <td width=111 nowrap valign=top style=''width:83.0pt;border:solid windowtext 1.0pt;background:#999999;padding:0in 0in 0in 0in;height:15.0pt''>
    <p class=MsoNormal><span style=''color:black''>Team<o:p></o:p></span></p></td>
    <td width=177 nowrap valign=top style=''width:133.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 0in 0in 0in;height:15.0pt''>
    <p class=MsoNormal>    <span style=''color:black''>Attendee<o:p></o:p></span></p></td>
    <td width=64 nowrap valign=top style=''width:48.0pt;border:solid windowtext 1.0pt;border-left:none;background:#999999;padding:0in 0in 0in 0in;height:15.0pt''>
    <p class=MsoNormal align=center style=''text-align:center''>
    <span style=''color:black''>Present<o:p></o:p></span></p></td></tr>';
  h_attend2 varchar2(4000) :=
  '<tr><td width=124 nowrap rowspan=';
  h_attend3 varchar2(4000) :=
  ' valign=top style=''border:solid windowtext 1.0pt;border-top:none;padding:0in 0in 0in 0in;''>
    <p class=MsoNormal><span style=''color:black''>';
  h_attend4 varchar2(4000) :=
  '<o:p></o:p></span></p></td>';
  h_attend5 varchar2(4000) :=
  '<td nowrap valign=top style=''border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;''>
    <p class=MsoNormal><span style=''color:black''>';
  h_attend6 varchar2(4000) :=
  '<o:p></o:p></span></p></td>
    <td nowrap valign=top style=''border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;''>
    <p class=MsoNormal align=center style=''text-align:center''><span style=''color:black''>';
  h_attend7 varchar2(4000) :=
  '<o:p></o:p></span></p></td></tr>';
  h_attend8 varchar2(4000) :=
  '<tr>
    <td nowrap valign=top style=''border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:15.0pt''>
    <p class=MsoNormal><span style=''color:black''>';
  h_attend9 varchar2(4000) :=
  '<o:p></o:p></span></p></td>
    <td nowrap valign=top style=''border-top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:15.0pt''>
    <p class=MsoNormal align=center style=''text-align:center''><span style=''color:black''>';
  h_attend10 varchar2(4000) :=
  '<o:p></o:p></span></p></td></tr>';
  h_attend11 varchar2(4000) :=
  '</tr>';
  h_attend12 varchar2(4000) :=
  '</table>';
  -- Footer section.
  h_foot1 varchar2(4000) :=
  '<p class=MsoNormal><span style=''font-size:10.0pt''><o:p>&nbsp;</o:p></span></p>
    <p class=MsoNormal><o:p>&nbsp;</o:p></p>
    <p class=MsoSubtitle><b>Severity:</b> <b><o:p></o:p></b></p>
    <p class=MsoNormal><b><span style=''font-size:9.0pt;font-family:"Arial",sans-serif;background:lime;mso-highlight:lime''>
    Green</span></b><b>
    <span style=''font-size:9.0pt;color:windowtext;font-style:normal''> </span></b>
    <span style=''font-size:9.0pt;font-family:"Arial",sans-serif''>&#8211; New or Closed<b><o:p></o:p></b></span></p>
    <p class=MsoNormal><b><span style=''font-size:9.0pt;font-family:"Arial",sans-serif;background:yellow;mso-highlight:yellow''>
    Yellow</span></b><b>
    <span style=''font-size:9.0pt;font-family:"Arial",sans-serif''> </span></b>
    <span style=''font-size:9.0pt;font-family:"Arial",sans-serif''>&#8211; Assigned and Open and inside its expected completion date<b><o:p></o:p></b></span></p>
    <p class=MsoNormal><b><span style=''font-size:9.0pt;font-family:"Arial",sans-serif;background:red;mso-highlight:red;''>
    Red</span></b><b>
    <span style=''font-size:9.0pt;font-family:"Arial",sans-serif''> </span></b>
    <span style=''font-size:9.0pt;font-family:"Arial",sans-serif''>&#8211; Unassigned or Assigned and past its target completion date<b><o:p></o:p></b></span></p>
    <p class=MsoNormal><b><span style=''font-size:9.0pt;font-family:"Arial",sans-serif''><o:p>&nbsp;</o:p></span></b></p>
    <p class=MsoSubtitle><b>Status:<o:p></o:p></b></p>
    <p class=MsoNormal><span style=''font-size:9.0pt;color:windowtext;font-style:normal''>
    NEW &#8211; </span>
    <span style=''font-size:9.0pt;color:windowtext;font-style:normal''>
    Issue was just reported for the first time in today&#8217;s meeting.<b><o:p></o:p></b></span></p>
    <p class=MsoNormal><span style=''font-size:9.0pt;color:windowtext;font-style:normal''>
    IN PROGRESS </span>
    <span style=''font-size:9.0pt;color:windowtext;font-style:normal''>&#8211; Issue has been identified and or is being worked on.<o:p></o:p></span></p>
    <p class=MsoNormal><span style=''font-size:9.0pt;color:windowtext;font-style:normal''>
    HOLD </span>
    <span style=''font-size:9.0pt;color:windowtext;font-style:normal''>&#8211; Issue is waiting for more information or a period of time to begin.<b><o:p></o:p></b></span></p>
    <p class=MsoNormal><span style=''font-size:9.0pt;color:windowtext;font-style:normal''>
    CLOSED </span><span style=''font-size:9.0pt;color:windowtext;font-style:normal''>&#8211; Issue has been resolved.<o:p></o:p></span></p>
    <p class=MsoNormal><span style=''font-size:9.0pt;color:windowtext;font-style:normal''>
    NONE</span>
    <span style=''font-size:9.0pt;color:windowtext;font-style:normal''> &#8211; Nothing to report<o:p></o:p></span></p>';
    
  -- Globals
  l_body      clob;             -- Storage for warning if not html email.
  l_body_html clob;             -- Storage for html.
  g_out       varchar2(32767);  -- Storage for email/APEX output.

  ------------------------------------------------------------------------------
  --  Functions
  ------------------------------------------------------------------------------
  
  
  ------------------------------------------------------------------------------
  --  gen_title function
  --    Generates the title for each section of the report.
  --
  --  Input:  ptitle - the section title resulting from query.
  ------------------------------------------------------------------------------
  function gen_title (ptitle varchar2) return varchar2 as
    
  begin

    -- Embed the requested title in the html.
    l_body_html := title1 || ptitle || title2;

    return l_body_html;
    
  end gen_title;


  ------------------------------------------------------------------------------
  --  Procedures
  ------------------------------------------------------------------------------
  
  ------------------------------------------------------------------------------
  --  gen_email_head procedure.
  --    Generates the HEAD section of the report, including inline styles.
  --
  --  Output:  pout - Generated HTML.
  ------------------------------------------------------------------------------  
  procedure gen_email_head (pout out varchar2) as
  begin

    -- Store html head.
    pout := ehead1 || ehead2;

  end gen_email_head;


  ------------------------------------------------------------------------------
  --  gen_header procedure
  --    Generates the html header information and Email title with logo.
  --
  --  Output:  pout - Generated HTML.
  ------------------------------------------------------------------------------
  procedure gen_header (pout out varchar2) as
  
    v_today   varchar2(60);   -- Todays date for heading.
    
  begin
  
    -- Get todays date.
    select
      to_char(sysdate, 'fmDay, FMMonth DD, YYYY') into v_today
    from
      dual;
  
    -- Setup warning for html enabled email.
    l_body := 'To view the content of this message, '||
              'please use an HTML enabled mail client.'||utl_tcp.crlf;

    pout := header1 || v_today || header2;

  end gen_header;

  
  ------------------------------------------------------------------------------
  --  gen_risk procedure
  --    Generates the Risk table of the report.
  --
  --  Output:  pout - Generated HTML.
  ------------------------------------------------------------------------------
  procedure gen_risk (pout out varchar2) as
  
    vrec_total  number;       -- Counter for record total.
    
  begin
  
    vrec_total := 0;
      
    -- Generate the title for this section. pout is used to return the html.
    --   l_body_html is used to concatenate the parts together.
    pout := daily_ops_v3.gen_title('Datacenter Risk Status');
    
    l_body_html := risk1 || utl_tcp.crlf;
  
    -- Retrieve Data Center status records and color code for output.
    for crec in (
      select
        decode(b.data_center_status_name, 'Warning','yellow',
                                          'Critical','red',
                                          '#92D050') stat_color,
        b.data_center_status_name,
        a.data_center_area,
        a.data_center_desc
      from
        rec_data_center a,
        rec_data_center_status b
      where
        a.data_center_status_id = b.data_center_status_id
      order by
        a.data_center_id )
    loop
      
      -- Accumulate for the totals line of the section.
      vrec_total := vrec_total + 1;
      
      -- Store a line for the section with queried values.
      l_body_html := l_body_html || risk2 ||
                     crec.stat_color || risk3 ||
                     crec.data_center_status_name || risk4 ||
                     crec.data_center_area || risk5 ||
                     crec.data_center_desc || risk6 ||
                     utl_tcp.crlf;

    end loop;
  
    -- Now store the totals line and end the table.
    l_body_html := l_body_html || risk7 || to_char(vrec_total) ||
                                  risk8 || utl_tcp.crlf;
                                  
    pout := pout || l_body_html;
    
  end gen_risk;


  ------------------------------------------------------------------------------
  --  gen_status procedure
  --    Generates the status for the issues tables of the report.
  --
  --  Output:  pout - Generated HTML.
  ------------------------------------------------------------------------------  
  procedure gen_status_start (pout out varchar2) as
  begin
 
    -- Set up an html table. 
    pout := h_status1 || utl_tcp.crlf;
    
  end gen_status_start;


  ------------------------------------------------------------------------------
  --  gen_status row
  --    Generates the status rows in each issues table of the report.
  --
  --  Output:  pout - Generated HTML.
  ------------------------------------------------------------------------------    
  procedure gen_status_row (pissue_status_name in varchar2,
                            ptarget_date date,
                            powner_name varchar2,
                            pjob_name in varchar2,
                            pdaily_operations_id in number,
                            preported_date in date,
                            pnext_update in date,
                            pout out varchar2) as
  
    vseverity     varchar2(30);       -- Color for the severity of a record.
    vupdate       varchar2(32767);    -- Storage for the updates for each issue.
    
  begin
  
    -- Adjust the color for the severity of the record.
    -- Red = No plan; no target date.
    -- Yellow = Off plan; past target date.
    -- Green = all others.

    vseverity := '#92D050';
    
    if ptarget_date is null then
      -- Red
      vseverity := '#C00000';
    else
      if ptarget_date < sysdate then 
        vseverity := 'yellow';
      end if;
    end if;


    -- Format and store the records for the section.
    l_body_html := h_stat_row1 || vseverity ||
                   h_stat_row2 || pissue_status_name ||
                   h_stat_row3 || powner_name ||
                   h_stat_row4 || pjob_name||
                   h_stat_row5;
   
    vupdate := '';

    -- Get all the updates for the issue in descending date order and format
    -- into a single cell.

    for crec3 in (
      select
        to_char(update_date,'MM/DD') update_date,
        replace(update_desc,'<html><head><title>') update_desc
      from
        rec_daily_update
      where
        daily_operations_id = pdaily_operations_id
      order by
        daily_update_id desc)
    loop
    
      vupdate := vupdate ||
                 crec3.update_date || ' ' ||
                 crec3.update_desc || '<br />';
      
    end loop;

    -- Complete the rest of the row.
    l_body_html := l_body_html ||
    vupdate|| h_stat_row6 || to_char(preported_date,'MM/DD/YYYY') ||
              h_stat_row7 || to_char(ptarget_date,'MM/DD/YYYY') ||
              h_stat_row8 || to_char(pnext_update,'MM/DD/YYYY') ||
              h_stat_row9 || utl_tcp.crlf;

    pout := l_body_html;
    
  end gen_status_row;


  ------------------------------------------------------------------------------
  --  gen_status_end procedure
  --    Generates the summary line for each issues table of the report.
  --
  --  Input:   prec_total - Accumulated total from rows processing.
  --  Output:  pout - Generated HTML.
  ------------------------------------------------------------------------------    
  procedure gen_status_end (prec_total in number, pout out varchar2) as
  begin

    -- Add the totals row and then end the table.        
    pout := h_stat_row10 || to_char(prec_total) ||
                   h_stat_row11 || utl_tcp.crlf;
    
  end gen_status_end;

  
  ------------------------------------------------------------------------------
  --  gen_comments procedure
  --    Generate comments for the end of the report.
  --
  --  Output:  pout - Generated HTML.
  ------------------------------------------------------------------------------  
  procedure gen_comments (pout out varchar2) as
  begin
    
    -- Add comments. Later, make this a table and query.      
    pout := h_comments1 || utl_tcp.crlf;

  end gen_comments;

  ------------------------------------------------------------------------------
  --  gen_status procedure
  --    Generates the status for the issues section of the executive report.
  --
  --  Input:  pissue - the section title.
  --  Output:  pout - Generated HTML.
  ------------------------------------------------------------------------------  
  procedure exec_status (pissue in varchar2, pout out varchar2) as
  
    vrec_total2   number;             -- Counter for total records.
    vseverity     varchar2(30);       -- Color for the severity of a record.
    vupdate       varchar2(32767);    -- Storage for the updates for each issue.
    
  begin
  
    vrec_total2 := 0;
    
    -- Set up an html table.
    l_body_html := h_estatus1 || utl_tcp.crlf;

    -- Retrieve the issues for the section.
    for crec in (
      select
        a.daily_operations_id,
        b.issue_status_name,
        c.owner_name,
        a.job_name,
        a.reported_date,
        a.target_date,
        a.next_update
      from
        rec_daily_operations a,
        rec_issue_status b,
        rec_issue_owner c,
        rec_issue_type d
      where
        a.issue_status_id = b.issue_status_id and
        a.owner_id = c.owner_id and
        a.issue_type_id = d.issue_type_id and
        d.issue_type_name = pissue and
        a.reported_date > trunc(sysdate-1) and
        b.issue_status_name != 'Duplicate' and
        ( b.issue_status_name != 'Closed' or trunc(a.closed_date) = trunc(sysdate) )
      order by
        a.reported_date desc
        )
    loop
    
      vrec_total2 := vrec_total2 + 1;

      -- Format and store the records for the section.  
      l_body_html := l_body_html ||
                      h_stat_row1 || vseverity ||
                      h_stat_row2 || crec.issue_status_name ||
                      h_stat_row3 || crec.owner_name ||
                      h_stat_row4 || crec.job_name ||
                      h_stat_row5 || utl_tcp.crlf;
     
      vupdate := '';

      -- Get all the updates for the issue in descending date order and format
      -- into a single cell.
      for crec2 in (
        select
          to_char(update_date,'MM/DD') update_date,
          replace(update_desc,'<html><head><title>') update_desc
        from
          rec_daily_update
        where
          daily_operations_id = crec.daily_operations_id
        order by
          daily_update_id desc)
      loop
      
        vupdate := vupdate ||
                   crec2.update_date || ' ' ||
                   crec2.update_desc || '<br />';
        
      end loop;
 
      -- Complete the rest of the row.     
      l_body_html := l_body_html ||
      vupdate|| h_stat_row6 || to_char(crec.reported_date,'MM/DD/YYYY') ||
                h_stat_row7 || to_char(crec.target_date,'MM/DD/YYYY') ||
                h_stat_row8 || to_char(crec.next_update,'MM/DD/YYYY') ||
                h_stat_row9 || utl_tcp.crlf;
      
    end loop;

    -- Add the totals row and then end the table.
    l_body_html := l_body_html || h_stat_row10 || to_char(vrec_total2) ||
                                  h_stat_row11 || utl_tcp.crlf;
                   
    pout := l_body_html;
    
  end exec_status;
  
  
  ------------------------------------------------------------------------------
  --  gen_exec_counts procedure
  --    Generate Exec Report Issue Summary for end of the report.
  --
  --  Output:  pout - Generated HTML.
  ------------------------------------------------------------------------------  
  procedure gen_exec_counts (pout out varchar2) as
  begin
    
    l_body_html := daily_ops_v3.gen_title('Issues Open by Type');

    -- Format the column headings.
    l_body_html := l_body_html || h_ecounts1;
  
    for crec in (    
      select
        d.report_order,
        d.issue_type_name,
        count(*) cnt
      from
        rec_daily_operations a,
        rec_issue_status b,
        rec_issue_type d
      where
        a.issue_status_id = b.issue_status_id and
        a.issue_type_id = d.issue_type_id and
        b.issue_status_name != 'Duplicate' and
        ( b.issue_status_name != 'Closed' or trunc(a.closed_date) = trunc(sysdate) )
      group by
        d.report_order,
        d.issue_type_name
      order by
        d.report_order,
        d.issue_type_name )
    loop

      l_body_html := l_body_html || h_ecounts2 || crec.issue_type_name ||
                                    h_ecounts3 || crec.issue_type_name ||
                                    h_ecounts4 || to_char(crec.cnt) ||
                                    h_ecounts5 || utl_tcp.crlf;
            
    end loop;
    
    pout := l_body_html || h_ecounts6 ||utl_tcp.crlf;
    
  end gen_exec_counts;

  
  ------------------------------------------------------------------------------
  --  gen_attendees procedure
  --    Generate a list of attendees.
  --
  --  Output:  pout - Generated HTML.
  ------------------------------------------------------------------------------  
  procedure gen_attendees (pout out varchar2) as
  
    vfirst  number;         -- Counter for first member of a team.
    
  begin

    pout := daily_ops_v3.gen_title('Attendees'); 
    
    l_body_html := h_attend1 || utl_tcp.crlf;
    
    -- Query loop to get attendance.
    for crec in (
      select
        b.owner_type,
        count(*) cnt
      from
        rec_issue_owner a,
        rec_owner_type b
      where
        a.owner_type_id = b.owner_id and
        a.owner_deleted != 'Y'
      group by
        b.owner_type
      order by
        b.owner_type )
    loop
      
      l_body_html := l_body_html || h_attend2 || to_char(crec.cnt) ||
                                    h_attend3 || crec.owner_type ||
                                    h_attend4 ||utl_tcp.crlf;
     
      vfirst := 1;
     
      for crec2 in (
        select
          a.owner_name,
          decode(a.attended,'Y','X', ' ') attended
        from
          rec_issue_owner a,
          rec_owner_type b
        where
          a.owner_type_id = b.owner_id and
          b.owner_type = crec.owner_type and
          a.owner_deleted != 'Y'
        order by
          a.owner_name )
      loop

        if vfirst = 1 then
          -- First record found.
          l_body_html := l_body_html || h_attend5 || crec2.owner_name ||
                                        h_attend6 || crec2.attended ||
                                        h_attend7 || utl_tcp.crlf;
        
          vfirst := 2;
        else
          -- Subsequent records found
          l_body_html := l_body_html || h_attend8 || crec2.owner_name ||
                                        h_attend9 || crec2.attended ||
                                        h_attend10 || utl_tcp.crlf;

        end if;
       
      end loop;

      l_body_html := l_body_html || h_attend11 || utl_tcp.crlf;
           
    end loop;

    l_body_html := l_body_html || h_attend12 || utl_tcp.crlf;
      
    pout := pout || l_body_html;
    
  end gen_attendees;


  ------------------------------------------------------------------------------
  --  gen_footer procedure
  --    Generate the report key and footer.
  --
  --  Output:  pout - Generated HTML.
  ------------------------------------------------------------------------------  
  procedure gen_footer (pout out varchar2) as
  begin
    
    pout := h_foot1 || utl_tcp.crlf;
      
  end gen_footer;


  ------------------------------------------------------------------------------
  --  save_attendance procedure
  --    Save the currently recorded attendance to the history table and reset.
  --
  ------------------------------------------------------------------------------    
  procedure save_attendance as
  begin
  
    insert into rec_attendance_history (
      owner_id,
      attendance_date,
      attended )
    select
      owner_id,
      trunc(sysdate),
      attended
    from
      rec_issue_owner
    where
      owner_deleted != 'Y';
    
    update rec_issue_owner
    set attended = 'N';
    
    commit;
  
  exception
    when DUP_VAL_ON_INDEX then
      null;
    when OTHERS then
      raise;
  end save_attendance;
  
  ------------------------------------------------------------------------------
  --  send_html procedure
  --    Call the gen_* procedures to format the report and then send via email.
  --
  ------------------------------------------------------------------------------  
  procedure send_html as

    e_out clob;
    vcnt number;
                        
  begin
  
    daily_ops_v3.gen_email_head (g_out);
    e_out := g_out || utl_tcp.crlf;
    
    -- Initialize and start the html page.
    daily_ops_v3.gen_header (g_out);
    e_out := e_out || g_out || utl_tcp.crlf;
    
    -- Generate the Risk section.
    daily_ops_v3.gen_risk (g_out);
    e_out := e_out || g_out|| utl_tcp.crlf;

    -- Get the issues.
    for crec in (
      select
        issue_type_id,
        issue_type_name
      from
        rec_issue_type
      order by
        report_order )
    loop

      -- Generate the title for this section.
      e_out := e_out || daily_ops_v3.gen_title(crec.issue_type_name);       
      
      daily_ops_v3.gen_status_start(g_out);
      e_out := e_out || g_out || utl_tcp.crlf;
      
      g_out := '';
      vcnt := 0;
      
      for crec2 in (
        select
          a.daily_operations_id,
          b.issue_status_name,
          c.owner_name,
          a.job_name,
          a.reported_date,
          a.target_date,
          a.next_update
        from
          rec_daily_operations a,
          rec_issue_status b,
          rec_issue_owner c,
          rec_issue_type d
        where
          a.issue_status_id = b.issue_status_id and
          a.owner_id = c.owner_id and
          a.issue_type_id = d.issue_type_id and
          d.issue_type_name = crec.issue_type_name and
          b.issue_status_name != 'Duplicate' and
          ( b.issue_status_name != 'Closed' or
            trunc(a.closed_date) = trunc(sysdate) )
        order by
          a.reported_date desc,
          a.job_name )
      loop
        daily_ops_v3.gen_status_row(crec2.issue_status_name,
                                    crec2.target_date,
                                    crec2.owner_name,
                                    crec2.job_name,
                                    crec2.daily_operations_id,
                                    crec2.reported_date,
                                    crec2.next_update,
                                    g_out);

        e_out := e_out || g_out || utl_tcp.crlf;
        
        vcnt := vcnt + 1;
        
      end loop;
      
      daily_ops_v3.gen_status_end(vcnt,g_out);
      e_out := e_out || g_out || utl_tcp.crlf;
      
    end loop;
   
    daily_ops_v3.gen_attendees(g_out);
    e_out := e_out || g_out || utl_tcp.crlf;
    
    daily_ops_v3.gen_footer (g_out);
    e_out := e_out || g_out || utl_tcp.crlf;
    
    daily_ops_v3.gen_comments (g_out);
    e_out := e_out || g_out || utl_tcp.crlf;

/* kls 
    for crec in (
      select
        email
      from
        rec_distribution_list
      where
        exec_list is null or exec_list = 'N' )
    loop
       
      apex_mail.send(
      p_to   => crec.email,
      p_from => 'MIS-Operations@marketingassociates.com',
      p_body      => l_body,
      p_body_html => l_body_html,
      p_subj      => 'Information Technology Daily Status Report');

   end loop;
*/
-- remove     
      apex_mail.send(
      p_to   => 'kscott@marketingassociates.com',
      p_from => 'MIS-Operations@marketingassociates.com',
      p_body      => l_body,
      p_body_html => e_out,
      p_subj      => 'Information Technology Daily Status Report');

  end;

  ------------------------------------------------------------------------------
  --  send_html procedure
  --    Call the gen_* procedures to format the report and then send via email.
  --
  ------------------------------------------------------------------------------  
  procedure exec_html as
  
    e_out clob;
    vcnt number;
    
  begin
  
    -- Initialize and start the html page.
    daily_ops_v3.gen_email_head (g_out);
    e_out := g_out || utl_tcp.crlf;
    
    -- Initialize and start the html page.
    daily_ops_v3.gen_header (g_out);
    e_out := e_out || g_out || utl_tcp.crlf;
    
    -- Generate the Risk section.
    daily_ops_v3.gen_risk (g_out);
    e_out := e_out || g_out|| utl_tcp.crlf;
    
    -- Get the issues.
    for crec in (
      select
        issue_type_id,
        issue_type_name
      from
        rec_issue_type
      where
        issue_type_name in ('Outages','JAMS Issues')
      order by report_order )
    loop
    
      -- Generate the title for this section.
      e_out := e_out || daily_ops_v3.gen_title(crec.issue_type_name);       
      
      daily_ops_v3.exec_status(crec.issue_type_name, g_out);
      e_out := e_out || g_out || utl_tcp.crlf;
      
    end loop;
    
    daily_ops_v3.gen_exec_counts(g_out);
    e_out := e_out || g_out || utl_tcp.crlf;
        
    daily_ops_v3.gen_attendees(g_out);
    e_out := e_out || g_out || utl_tcp.crlf;

        -- Finally, send and email with the generated html. 
    for crec in (
      select
        email
      from
        rec_distribution_list
      where
        exec_list = 'Y' )
    loop
       
/* kls      apex_mail.send(
      p_to   => crec.email,
      p_from => 'MIS-Operations@marketingassociates.com',
      p_body      => l_body,
      p_body_html => l_body_html,
      p_subj      => 'Information Technology Daily Status Report');   */

      null;
      
    end loop;
      
  -- Update attendance history.
    save_attendance;

-- remove
    apex_mail.send(
    p_to   => 'kscott@marketingassociates.com',
    p_from => 'MIS-Operations@marketingassociates.com',
    p_body      => l_body,
    p_body_html => e_out,
    p_subj      => 'Information Technology Daily Status Report');
    
  end exec_html;
  
END DAILY_OPS_V3;
/