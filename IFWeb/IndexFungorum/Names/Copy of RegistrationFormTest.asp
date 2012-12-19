<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Index Fungorum-Name RegistrationForm</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=700,height=495,left=100,top=00');");
}
function MM_displayStatusMsg(msgStr) { //v1.0
  status=msgStr;
  document.MM_returnValue = true;
}
</script>
<link href="../StyleIXF.css" rel="stylesheet" type="text/css">
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#CCCCCC">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="105"> <table width="100%" border="0" class="mainbody">
        <tr> 
          <td width="50%" class="h1"> <img src="../IMAGES/LogoIF.gif" alt="Index Fungorum - Species Fungorum" width="100" height="100">Index&nbsp;Fungorum</td>
          <td valign="top">&nbsp;</td>
        </tr>
        <tr> 
          <td colspan="2"><hr noshade></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" cellpadding="5">
        <tr> 
          <td>
<style>
  input {
  width: 200px;
  font-family: Tahoma;
  font-size: 8pt;
  }
  .label {
width:50px;
  }
  textarea {
width: 200px;
  font-family: Tahoma;
  font-size: 8pt;
  }
  body {
font-family: Tahoma;
  font-size: 8pt;
  }
  .error {
  font-family: Tahoma;
font-size: 8pt;
  color: red;
  margin-left: 50px;
  display:none;
  }
</style>
  
<script>
  function checkForm() {
name = document.getElementById("name").value;
  email = document.getElementById("email").value;
  comment = document.getElementById("comment").value;
  
  if (name == "") {
  hideAllErrors();
document.getElementById("nameError").style.display = "inline";
document.getElementById("name").select();
document.getElementById("name").focus();
  return false;
  } else if (email == "") {
hideAllErrors();
document.getElementById("emailError").style.display = "inline";
document.getElementById("email").select();
document.getElementById("email").focus();
  return false;
  } else if (comment == "") {
hideAllErrors();
document.getElementById("commentError").style.display = "inline";
document.getElementById("comment").select();
document.getElementById("comment").focus();
  return false;
  }
  return true;
  }
 
  function hideAllErrors() {
document.getElementById("nameError").style.display = "none"
document.getElementById("emailError").style.display = "none"
document.getElementById("commentError").style.display = "none"
  }
</script>

<style>
  input {
  width: 200px;
  font-family: Tahoma;
  font-size: 8pt;
  }
  
  .label {
  width:50px;
  }
  
  textarea {
  width: 200px;
  font-family: Tahoma;
  font-size: 8pt;
  }
   
  body {
  font-family: Tahoma;
  font-size: 8pt;
  }

  .error {
  font-family: Tahoma;
  font-size: 8pt;
  color: red;
  margin-left: 50px;
  display:none;
  }
</style>
  
<%
sub DisplayRecord()

   response.write("<form name='frmIndexFungorumAdd' onSubmit='return checkForm();' method=post action='../Names/RegisterName.asp'>")
   response.write("<table width='100%' border='1' cellspacing='0' cellpadding='5'>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Name</span></td>")
   response.write("<td width='85%'><input type=text value='' id=name size='68' maxlength='100'>")
   response.write("<div class=error id=nameError>Required: Please enter your name</div></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Email:</span></td>")
   response.write("<td width='85%'><input type=text value='' id=email size='68' maxlength='100'>")
   response.write("<div class=error id=emailError>Required: Please enter your email address<br></div></td>")
   response.write("</tr>")

   response.write("<tr>")
   response.write("<td width='15%'><span class=label>Comment:</span></td>")
   response.write("<td width='85%'><textarea type=text value='' id=comment cols='60' rows='5'></textarea>")
   response.write("<div class=error id=commentError>Required: Please enter a comment<br></div></td>")
   response.write("</tr>")


   response.write("</tr>")
   response.write("<td width='15%'><input type='submit' name='Submit' value='Register Name'></td>")
   response.write("<td width='85%'><input type='hidden' name='RECORDNUMBER' value='1'></td>")
   response.write("</tr>")
   response.write("</table>")

   response.write("</form>")


end sub
%> <%
   response.write("<h3><font color='#FF0000'>Index Fungorum name registration form</font></h3>")
   DisplayRecord()
   response.write("<a href='javascript:history.go(-1)'>back to previous page</a>")
%>
</body>
</html>

</td>
        </tr>
      </td>
  </tr>
  <tr> 
    <td height="10" class="Footer"> <hr noshade> &copy; 2010 <a href=javascript:popUp("../Names/IndexFungorumPartnership.htm") onMouseOver="MM_displayStatusMsg('Index Fungorum Partnership');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">Index 
      Fungorum Partnership</a>. Return to <a href="../Index.htm" onMouseOver="MM_displayStatusMsg('CABI Bioscience Databases home page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">main 
      page</a>. Return to <a href="#TopOfPage" onMouseOver="MM_displayStatusMsg('Go to top of page');return document.MM_returnValue" onMouseout="MM_displayStatusMsg('');return document.MM_returnValue">top 
      of page</a>. </td>
  </tr>
</table>
<a name="BottomOfPage"></a> 
</body>
</html>
