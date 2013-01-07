<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <h1>GNUB REST Service</h1>
    <p>To request details about a particular GNUB Taxon Name Usage (TNU), use the URL format http://gnub.bishopmuseum.org/gnubservice/name/{ID}</p>
    <p>To request all GNUB Taxon Name Usages, use the URL format http://gnub.bishopmuseum.org/gnubservice/names/all.  
    An if-modified-since HTTP header can be provided with the call to check if the all 
        names dump file has changed.  
    The response format will be a CSV formatted file with the following columns:<br />
    TaxonID<br />
    dc:source<br />
    ScientificName<br />
    HigherTaxonID<br />
    TaxonRank<br />
    NomenclaturalCode<br />
    TaxonAccordingTo<br />
    NamePublishedIn<br />
    TaxonomicStatus<br />
    NomenclaturalStatus<br />
    AcceptedTaxonID<br />
    BasionymID
    </p>
    </div>
    </form>
</body>
</html>
