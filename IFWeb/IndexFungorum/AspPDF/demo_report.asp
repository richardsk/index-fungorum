<!--#include file="../Helpers/Utility.asp"-->
<HTML>
<HEAD>

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">

<script language="JavaScript" src="calendar.js"></script>


<SCRIPT LANGUAGE="JavaScript">
function Validate()
{
	var FormName, NumRec;
	FormName = "AspGridFormSave1";

	// check whether UPDATE or Save button is clicked.
	// In the latter case, the item AspGridUpdateRows1 is undefined
	NumRecItem = document.forms[FormName].elements['AspGridUpdateRows1'];

	if( typeof(NumRecItem) == "undefined" )
	{
		// validate Description
		if( document.forms[FormName].FIELD4.value == "")
		{
			alert('Description must be filled.');
			document.forms[FormName].FIELD4.focus();
			return false;
		}

		// validate Amount
		if( isNaN(document.forms[FormName].FIELD7.value ) )
		{
			alert('Not a number!');
			document.forms[FormName].FIELD7.focus();
			return false;
		}

		// Validate date
		var testDate=new Date(Date.parse(document.forms[FormName].FIELD6.value ) );
		if( !testDate.getYear() )
		{
			alert('Not a date!');
			document.forms[FormName].FIELD6.focus();
			return false; 
		}

		return true;
	}

	// Validate all records if UPDATE is clicked
	// Get number of visible records	
	NumRec = NumRecItem.value;

	for(i = 1; i <= NumRec; i++ )
	{
		// if this record is marked for deletion, do not validate it.
		// [0] and [1] are used because we have two check boxes with the same name on both sides.
		// If only one control column were visible, we would not need those.
		if( document.forms[FormName].elements['RowDelete1_' + i][0].checked
			|| document.forms[FormName].elements['RowDelete1_' + i][1].checked )
			continue;

		// validate Description
		if( document.forms[FormName].elements['FIELD4_' + i].value == "")
		{
			alert('Description must be filled.');
			document.forms[FormName].elements['FIELD4_' + i].focus();
			return false;
		}

		// validate Amount
		if( isNaN(document.forms[FormName].elements['FIELD7_' + i].value ) )
		{
			alert('Not a number!');
			document.forms[FormName].elements['FIELD7_' + i].focus();
			return false;
		}

		// Validate date
		var testDate=new Date(Date.parse(document.forms[FormName].elements['FIELD6_' + i].value ) );
		if( !testDate.getYear() )
		{
			alert('Not a date!');
			document.forms[FormName].elements['FIELD6_' + i].focus();
			return false; 
		}
	}
	
	return true;
}
</SCRIPT>

</HEAD>

<BODY BGCOLOR="#FFFFFF">
<TABLE WIDTH="640"><TR><TD>
<FONT FACE="Arial" SIZE="2">

<h3>AspPDF Report Demo</h3>

Add, remove, or edit records in the table below. Use 
the <IMG SRC="images/addnew.gif" BORDER="0"> button to add a new record,
<IMG SRC="images/save.gif" BORDER="0"> to save a record,
and <IMG SRC="images/update.gif" BORDER="0"> to save
changes to existing records.
When finished, click on the "Generate PDF" 
button to export the data into a PDF document. 
<P>
This demo uses <A HREF="http://www.aspgrid.com" TARGET="_new"><B>AspGrid</B></A>.

<P>

<%
	' Create an instance of AspGrid
	Set Grid = Server.CreateObject("Persits.Grid")
	
	' Specify location of button images
	Grid.Imagepath = "images/"


	' Specify SQL statement. We store session IDs to allow simultaneos users to run the demo transparently
	Grid.SQL = "select id, sessionid, category, description, billable, expensedate, amount from demo_expense where sessionid =" & protectSQL(Session.SessionID, true) & " order by id"

	' Connect using a DSNless connection string
	Grid.Connect Session("ConnectStr"), "", ""
	
	' Optional: specify a client-side JavaScript validation routine
	Grid.FormOnSubmit = "return Validate();"

	' Use POST rather than GET
	Grid.MethodGet = False

	' specify <TABLE> attributes of the grid
	Grid.Table.CellSpacing = 0
	Grid.Table.CellPadding = 0
	Grid.Table.Width = 640

	' Hide the ID and SESSIONID columns
	Grid.ColRange(1, 2).Hidden = True

	' specify the default value for the hidden SESSIONID column
	Grid.Cols("SessionID").DefaultValue = Session.SessionID

	' Enable control buttons at both sides of grid
	Grid.ShowLeftSideButtons

	' Set header captions
	Grid("category").Caption = "Category"
	Grid("description").Caption = "Description"
	Grid("billable").Caption = "Billable?"
	Grid("expensedate").Caption = "Date"
	Grid("amount").Caption = "Amount"

	' Set column width
	Grid.Cols(0).Header.Width = 35
	Grid.Cols(0).Cell.Width = 35
	Grid.Cols(0).Cell.NoWrap = True

	' Columns 1 and 2 (id and sessionid) are hidden
	
	Grid.Cols(3).Cell.Width = 100
	Grid.Cols(3).Header.Width = 100
	
	Grid.Cols(4).Cell.Width = 200
	Grid.Cols(4).Header.Width = 200

	Grid.Cols(5).Cell.Width = 90
	Grid.Cols(5).Header.Width = 90

	Grid.Cols(6).Cell.Width = 120
	Grid.Cols(6).Header.Width = 120

	Grid.Cols(7).Cell.Width = 80
	Grid.Cols(7).Header.Width = 80
	
	Grid.Cols(999).Cell.Width = 35
	Grid.Cols(999).Header.Width = 35
	Grid.Cols(999).Cell.NoWrap = True
	
	' Set fonts, colors for the control columns
	Grid.Cols(0).Header.BgColor = "#90F0FE"
	Grid.Cols(0).Cell.Align = "CENTER"
	Grid.Cols(0).Cell.BgColor = "#FFFFFF"
	Grid.Cols(0).Cell.AltBgColor = "#E0E0E0"
	Grid.Cols(0).Footer.Align = "CENTER"
	Grid.Cols(999).Header.BgColor = "#90F0FE"
	Grid.Cols(999).Cell.Align = "CENTER"	
	Grid.Cols(999).Cell.BgColor = "#FFFFFF"
	Grid.Cols(999).Cell.AltBgColor = "#E0E0E0"	
	Grid.Cols(999).Footer.Align = "CENTER"

	' Set fonts, colors and sizes for the data columns
	Grid.ColRange(2, 7).Header.Font.Face = "Arial"
	Grid.ColRange(2, 7).Header.Font.Size = 2
	Grid.ColRange(2, 7).Header.BgColor = "#90F0FE"
	Grid.ColRange(2, 7).Header.NoWrap = True
	Grid.ColRange(2, 7).Cell.Font.Face = "Arial"
	Grid.ColRange(2, 7).Cell.Font.Size = 2
	Grid.ColRange(2, 7).Cell.BgColor = "#FFFFFF"
	Grid.ColRange(2, 7).Cell.AltBgColor = "#E0E0E0"

	' Grid.Cols(<index>) is equivalent to Grid(<index>) as Cols is the default property
	
	' Set the SIZE attribute for <INPUT TYPE=TEXT>
	Grid("category").InputSize = 9
	Grid("description").InputSize = 27
	Grid("amount").InputSize = 7
	Grid("expensedate").InputSize = 9

	' Display Category field as a drop-down list
	Grid("category").Array = Array("Travel", "Meals", "Office Suppl.", "Misc")
	Grid("category").VArray = Array(4, 1, 3, 2) ' corresponding DB values (in the matching order)

	' Display Billable column as a checkbox
	Grid("billable").AttachCheckBox "Yes", "No"
	Grid("billable").Cell.Align = "CENTER"

	' Format the Amount column
	Grid("amount").FormatNumeric 2, True, True, True, "$"
	Grid("amount").Cell.Align = "RIGHT"
	Grid("amount").DefaultValue = 0
	Grid("amount").InputUserAttributes = "style=""text-align: right;"""

	' Format the Date column, attach calendar to it	
	Grid("expensedate").FormatDate "%d %b %Y", "%d %b %Y"
	Grid("expensedate").DefaultValue = Date
	Grid("expensedate").AttachCalendar
	Grid("expensedate").Cell.NoWrap = True

	' Enable client-side confirmation on record deletion
	Grid.DeleteButtonOnClick = "Are you sure you want to delete this record?"

	' Enable client-side validation routine
	Grid.FormOnSubmit = "return Validate();"

	' Display an icon of scissors on top of control button columns
	Grid(0).Caption = "<IMG SRC=""images/delete.gif"">"	
	Grid(999).Caption = "<IMG SRC=""images/delete.gif"">"

	Grid.BuildForm(False)

	' Display grid manually
	Response.Write Grid.Output.TableTag
	Response.Write Grid.Output.CaptionTag ' if appropriate

	' Display Header
	Set HRow = Grid.Output.HeaderRow
	Response.Write HRow.TR
	For Each Block in HRow.Blocks
		Response.Write Block.Value
	Next
	Response.Write HRow.CloseTR

	' Display a single <FORM> tag for both the body and footer areas
	Response.Write Grid.Output.Form

	' Display Body
	For Each Row in Grid.Output.Rows
		Response.Write Row.TR

		For Each Block in Row.Blocks
			Response.Write Block.TD
			Response.Write Block.Font

			Response.Write Block.Value

			Response.Write Block.CloseFont
			Response.Write Block.CloseTD
		Next
		Response.Write Row.CloseTR
	Next

	' Display Footer
	Set FRow = Grid.Output.FooterRow 
	Response.Write FRow.TR
	For Each Block in FRow.Blocks
		Response.Write Block.TD
		Response.Write Block.Value
		Response.Write Block.CloseTD
	Next
	Response.Write FRow.CloseTR

	' Display </FORM>
	Response.Write Grid.Output.CloseForm
	
	' Display </TABLE> tag
	Response.Write Grid.Output.CloseTableTag

	Set Grid = Nothing

%>


<FORM METHOD="POST" ACTION="demo_report_pdf.asp">
<INPUT TYPE="SUBMIT" VALUE="Generate PDF">
</FORM>

<P>
<B><A HREF="demo_text.zip">Download source code for this demo</A></B>

</FONT>
</TD></TR></TABLE>
</BODY>
</HTML>
