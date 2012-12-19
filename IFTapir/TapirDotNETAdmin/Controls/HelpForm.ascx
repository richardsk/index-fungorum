
<%@ Control CodeBehind="HelpForm.ascx.cs" Language="c#" AutoEventWireup="True" Inherits="TapirDotNET.Controls.HelpForm" %>
<center>
<span class="section"><%Response.Write(Name);%></span>
<br>
<div width="80%" class="box2"><span class="msg"><%Response.Write(Doc);%></span>
</div>
</center>