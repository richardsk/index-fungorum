
<!--#include file="../Helpers/Utility.asp"-->
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>AspPDF Report Demo - PDF Generation</TITLE>
</HEAD>
<BODY>
<BASEFONT FACE="Arial" SIZE="2">

<%

	Set PDF = Server.CreateObject("Persits.Pdf")

	' Create empty param objects to be used across the app
	Set Param = PDF.CreateParam
	Set TextParam = PDF.CreateParam

	' Create document
	Set Doc = PDF.CreateDocument

	
	' Create table with one row (header), and 5 columns
	Set Table = Doc.CreateTable("width=500; height=20; Rows=1; Cols=5; Border=1; CellSpacing=-1; cellpadding=2 ")
	Table.Font = Doc.Fonts("Helvetica")
	Set HeaderRow = Table.Rows(1)
	Param.Set("alignment=center")
	With HeaderRow
		.BGColor = &H90F0FE
		.Cells(1).AddText "Category", Param
		.Cells(2).AddText "Description", Param
		.Cells(3).AddText "Billable", Param
		.Cells(4).AddText "Date", Param
		.Cells(5).AddText "Amount", Param
	End With

	' Set column widths
	With Table.Rows(1)
		.Cells(1).Width = 80
		.Cells(2).Width = 160
		.Cells(3).Width = 50
		.Cells(4).Width = 70
		.Cells(5).Width = 60
	End With

	
	' Populate table with data
	Set rs = Server.CreateObject("adodb.recordset")
	rs.Open "select * from demo_expense where sessionid='" & protectSQL(session.SessionID, true) & "' order by id", Session("ConnectStr") 

	param.Set "expand=true" ' expand cell vertically to accomodate text
	Dim categories(4)
	categories(0) = "Meals"
	categories(1) = "Misc"
	categories(2) = "Office Supplies"
	categories(3) = "Travel"


	Do While Not rs.EOF
		Set Row = Table.Rows.Add(20) ' row height
		
		param.Add "alignment=left"
		Row.Cells(1).AddText categories(rs("Category")-1), param
		Row.Cells(2).AddText rs("Description"), param
		
		param.Add "alignment=center"
		Row.Cells(3).AddText rs("Billable"), param
		Row.Cells(4).AddText pdf.FormatDate( rs("ExpenseDate"), "%d %b %Y" ), param
		
		param.Add "alignment=right"
		Row.Cells(5).AddText pdf.FormatNumber(rs("Amount"), "precision=2, delimiter=true"), param

		rs.MoveNext

	Loop

	' Draw table on page
	Set Page = Doc.Pages.Add(612, 150) ' small pages to demonstrate paging functionality
	

	Param.Clear	
	Param("x") = (Page.Width - Table.Width) / 2 ' center table on page
	Param("y") = Page.Height - 20
	Param("MaxHeight") = 100
	
	FirstRow = 2 ' use this to print record count on page
	Do While True
		' Draw table. This method returns last visible row index
		LastRow = Page.Canvas.DrawTable( Table, Param )

		' Print record numbers
		TextParam("x") = (Page.Width - Table.Width) / 2
		TextParam("y") = Page.Height - 5
		TextParam.Add("color=darkgreen")
		TextStr = "Records " & FirstRow - 1 & " to " & LastRow - 1 & " of " & Table.Rows.Count - 1
		Page.Canvas.DrawText TextStr, TextParam, doc.fonts("Courier-Bold")

		' Print page count
		TextParam("x") = Page.Width - 10
		TextParam("y") = 15
		TextParam.Add("color=maroon")
		Page.Canvas.DrawText Page.Index, TextParam, doc.fonts("Helvetica")
		
		if LastRow >= Table.Rows.Count Then Exit Do ' entire table displayed

		' Display remaining part of table on the next page
		Set Page = Page.NextPage
		Param.Add( "RowTo=1; RowFrom=1" ) ' Row 1 is header - must always be present.
		Param("RowFrom1") = LastRow + 1 ' RowTo1 is omitted and presumed infinite

		FirstRow = LastRow + 1
	Loop


	' We use Session ID for file names
	' false means "do not overwrite"
	' The method returns generated file name
	Path = Server.MapPath( "files") & "\" & Session.SessionID & ".pdf"
	FileName = Doc.Save( Path, false)

	Response.Write "<P><B>Success. Your PDF file <font color=gray>" & FileName & "</font> can be downloaded <A HREF=""files/" & FileName & """><B>here</B></A></B>."
	Set Doc = Nothing
	Set Pdf = Nothing
%>
<P>
<A HREF="demo_report.asp">Back to the Report demo</A>

</BASEFONT>
</BODY>
</HTML>
