<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
dim tMsgObj, chSet
%>
<!--#include file="../include/gChkCook.asp"-->
<%
ChkCookie
%>
<html>
    <head>
        <meta content="text/html; charset=<%=chSet%>" />
        <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
        <title>WebAccess Express</title>
        <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    </head>
    <form name="toaspx" id="toaspx" action="/express/express.aspx" method="post">
        <%
            for each Item  in Session.Contents
                Response.Write("<input type=""hidden"" name=""" & Item)
                Response.Write( """ value=""" & Session(item) & """ >")
            next
        %>
        <div style="position:absolute; width:185px; height:45px; border:1px solid #6593cf; background: #c3daf9; padding:2px; left:50%; top:50%; margin-left:-100px; margin-top:-45px;">
            <div id="loading" align="center" style="background: #fbfbfb; border:1px solid #a3bad9; color:#222; padding:5px; font:normal 22px tahoma, arial, helvetica, sans-serif;">
                <img src="/broadweb/express/images/loading.gif" style="vertical-align:middle">&nbsp;<%=tMsgObj.GetTextMsg(2065)%>...
            </div>
        </div>
    </form>
    <script type="text/javascript">
        $('#toaspx').submit();
    </script>
</html>