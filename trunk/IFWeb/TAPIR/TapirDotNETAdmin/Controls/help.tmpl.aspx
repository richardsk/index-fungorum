
<%@ Page CodeBehind="help.tmpl.aspx.cs" Language="c#" AutoEventWireup="True" Inherits="TapirDotNET.Controls.help_tmpl" %>
<!doctype html public "-//W3C//DTD HTML 4.0 //EN">
<html>
<head>
<title>Help</title>
<link rel = "StyleSheet" href = "layout.css" type = "text/css">
</head>
<body bgcolor = "#FFFFFF">
<center>
<span class="section"><%Response.Write(name);
%></span>
<br>
<div width="80%" class="box2">
<span class="msg"><%Response.Write(Utility.StringSupport.Nl2br(doc));
%></span>
</div>
</center>
</body>
</html>