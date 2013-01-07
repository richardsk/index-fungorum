
Imports System.ServiceModel.Web
Imports System.ServiceModel.Channels
Imports System.ServiceModel

<ServiceContract()> _
Public Interface INamesREST

    <OperationContract()> _
    <WebGet(UriTemplate:="name/{nameId}")> _
    Function GetName(ByVal nameId As String) As Message

    <OperationContract()> _
    <WebGet(UriTemplate:="names/all")> _
    Function GetAllNames() As Message

End Interface

