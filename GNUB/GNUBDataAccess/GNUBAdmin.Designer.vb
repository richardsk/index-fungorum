﻿'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated by a tool.
'     Runtime Version:2.0.50727.3082
'
'     Changes to this file may cause incorrect behavior and will be lost if
'     the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Option Strict Off
Option Explicit On

<Assembly: Global.System.Data.Objects.DataClasses.EdmSchemaAttribute("bcf09e56-6b99-4a26-8e0f-51b152f1b22c"),  _
 Assembly: Global.System.Data.Objects.DataClasses.EdmRelationshipAttribute("GNUBModel", "FK_UserProvider_Provider", "Provider", Global.System.Data.Metadata.Edm.RelationshipMultiplicity.One, GetType(Provider), "UserProvider", Global.System.Data.Metadata.Edm.RelationshipMultiplicity.Many, GetType(UserProvider)),  _
 Assembly: Global.System.Data.Objects.DataClasses.EdmRelationshipAttribute("GNUBModel", "FK_UserProvider_User", "User", Global.System.Data.Metadata.Edm.RelationshipMultiplicity.One, GetType(User), "UserProvider", Global.System.Data.Metadata.Edm.RelationshipMultiplicity.Many, GetType(UserProvider)),  _
 Assembly: Global.System.Data.Objects.DataClasses.EdmRelationshipAttribute("GNUBModel", "FK_UpdateLog_Provider", "Provider", Global.System.Data.Metadata.Edm.RelationshipMultiplicity.One, GetType(Provider), "UpdateLog", Global.System.Data.Metadata.Edm.RelationshipMultiplicity.Many, GetType(UpdateLog))> 

'Original file name:
'Generation date: 3/03/2009 9:44:54 a.m.
'''<summary>
'''There are no comments for GNUBAdminEntities in the schema.
'''</summary>
Partial Public Class GNUBAdminEntities
    Inherits Global.System.Data.Objects.ObjectContext
    '''<summary>
    '''Initializes a new GNUBAdminEntities object using the connection string found in the 'GNUBAdminEntities' section of the application configuration file.
    '''</summary>
    Public Sub New()
        MyBase.New("name=GNUBAdminEntities", "GNUBAdminEntities")
        Me.OnContextCreated
    End Sub
    '''<summary>
    '''Initialize a new GNUBAdminEntities object.
    '''</summary>
    Public Sub New(ByVal connectionString As String)
        MyBase.New(connectionString, "GNUBAdminEntities")
        Me.OnContextCreated
    End Sub
    '''<summary>
    '''Initialize a new GNUBAdminEntities object.
    '''</summary>
    Public Sub New(ByVal connection As Global.System.Data.EntityClient.EntityConnection)
        MyBase.New(connection, "GNUBAdminEntities")
        Me.OnContextCreated
    End Sub
    Partial Private Sub OnContextCreated()
        End Sub
    '''<summary>
    '''There are no comments for Provider in the schema.
    '''</summary>
    Public ReadOnly Property Provider() As Global.System.Data.Objects.ObjectQuery(Of Provider)
        Get
            If (Me._Provider Is Nothing) Then
                Me._Provider = MyBase.CreateQuery(Of Provider)("[Provider]")
            End If
            Return Me._Provider
        End Get
    End Property
    Private _Provider As Global.System.Data.Objects.ObjectQuery(Of Provider)
    '''<summary>
    '''There are no comments for User in the schema.
    '''</summary>
    Public ReadOnly Property User() As Global.System.Data.Objects.ObjectQuery(Of User)
        Get
            If (Me._User Is Nothing) Then
                Me._User = MyBase.CreateQuery(Of User)("[User]")
            End If
            Return Me._User
        End Get
    End Property
    Private _User As Global.System.Data.Objects.ObjectQuery(Of User)
    '''<summary>
    '''There are no comments for UserProvider in the schema.
    '''</summary>
    Public ReadOnly Property UserProvider() As Global.System.Data.Objects.ObjectQuery(Of UserProvider)
        Get
            If (Me._UserProvider Is Nothing) Then
                Me._UserProvider = MyBase.CreateQuery(Of UserProvider)("[UserProvider]")
            End If
            Return Me._UserProvider
        End Get
    End Property
    Private _UserProvider As Global.System.Data.Objects.ObjectQuery(Of UserProvider)
    '''<summary>
    '''There are no comments for UpdateLog in the schema.
    '''</summary>
    Public ReadOnly Property UpdateLog() As Global.System.Data.Objects.ObjectQuery(Of UpdateLog)
        Get
            If (Me._UpdateLog Is Nothing) Then
                Me._UpdateLog = MyBase.CreateQuery(Of UpdateLog)("[UpdateLog]")
            End If
            Return Me._UpdateLog
        End Get
    End Property
    Private _UpdateLog As Global.System.Data.Objects.ObjectQuery(Of UpdateLog)
    '''<summary>
    '''There are no comments for Provider in the schema.
    '''</summary>
    Public Sub AddToProvider(ByVal provider As Provider)
        MyBase.AddObject("Provider", provider)
    End Sub
    '''<summary>
    '''There are no comments for User in the schema.
    '''</summary>
    Public Sub AddToUser(ByVal user As User)
        MyBase.AddObject("User", user)
    End Sub
    '''<summary>
    '''There are no comments for UserProvider in the schema.
    '''</summary>
    Public Sub AddToUserProvider(ByVal userProvider As UserProvider)
        MyBase.AddObject("UserProvider", userProvider)
    End Sub
    '''<summary>
    '''There are no comments for UpdateLog in the schema.
    '''</summary>
    Public Sub AddToUpdateLog(ByVal updateLog As UpdateLog)
        MyBase.AddObject("UpdateLog", updateLog)
    End Sub
End Class
'''<summary>
'''There are no comments for GNUBModel.Provider in the schema.
'''</summary>
'''<KeyProperties>
'''ProviderID
'''</KeyProperties>
<Global.System.Data.Objects.DataClasses.EdmEntityTypeAttribute(NamespaceName:="GNUBModel", Name:="Provider"),  _
 Global.System.Runtime.Serialization.DataContractAttribute(IsReference:=true),  _
 Global.System.Serializable()>  _
Partial Public Class Provider
    Inherits Global.System.Data.Objects.DataClasses.EntityObject
    '''<summary>
    '''Create a new Provider object.
    '''</summary>
    '''<param name="providerID">Initial value of ProviderID.</param>
    '''<param name="providerName">Initial value of ProviderName.</param>
    '''<param name="url">Initial value of Url.</param>
    '''<param name="protocol">Initial value of Protocol.</param>
    Public Shared Function CreateProvider(ByVal providerID As Global.System.Guid, ByVal providerName As String, ByVal url As String, ByVal protocol As String) As Provider
        Dim provider As Provider = New Provider
        provider.ProviderID = providerID
        provider.ProviderName = providerName
        provider.Url = url
        provider.Protocol = protocol
        Return provider
    End Function
    '''<summary>
    '''There are no comments for Property ProviderID in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(EntityKeyProperty:=true, IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property ProviderID() As Global.System.Guid
        Get
            Return Me._ProviderID
        End Get
        Set
            Me.OnProviderIDChanging(value)
            Me.ReportPropertyChanging("ProviderID")
            Me._ProviderID = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value)
            Me.ReportPropertyChanged("ProviderID")
            Me.OnProviderIDChanged
        End Set
    End Property
    Private _ProviderID As Global.System.Guid
    Partial Private Sub OnProviderIDChanging(ByVal value As Global.System.Guid)
        End Sub
    Partial Private Sub OnProviderIDChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property ProviderName in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property ProviderName() As String
        Get
            Return Me._ProviderName
        End Get
        Set
            Me.OnProviderNameChanging(value)
            Me.ReportPropertyChanging("ProviderName")
            Me._ProviderName = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value, false)
            Me.ReportPropertyChanged("ProviderName")
            Me.OnProviderNameChanged
        End Set
    End Property
    Private _ProviderName As String
    Partial Private Sub OnProviderNameChanging(ByVal value As String)
        End Sub
    Partial Private Sub OnProviderNameChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property Url in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property Url() As String
        Get
            Return Me._Url
        End Get
        Set
            Me.OnUrlChanging(value)
            Me.ReportPropertyChanging("Url")
            Me._Url = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value, false)
            Me.ReportPropertyChanged("Url")
            Me.OnUrlChanged
        End Set
    End Property
    Private _Url As String
    Partial Private Sub OnUrlChanging(ByVal value As String)
        End Sub
    Partial Private Sub OnUrlChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property Protocol in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property Protocol() As String
        Get
            Return Me._Protocol
        End Get
        Set
            Me.OnProtocolChanging(value)
            Me.ReportPropertyChanging("Protocol")
            Me._Protocol = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value, false)
            Me.ReportPropertyChanged("Protocol")
            Me.OnProtocolChanged
        End Set
    End Property
    Private _Protocol As String
    Partial Private Sub OnProtocolChanging(ByVal value As String)
        End Sub
    Partial Private Sub OnProtocolChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property LastUpdate in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property LastUpdate() As Global.System.Nullable(Of Date)
        Get
            Return Me._LastUpdate
        End Get
        Set
            Me.OnLastUpdateChanging(value)
            Me.ReportPropertyChanging("LastUpdate")
            Me._LastUpdate = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value)
            Me.ReportPropertyChanged("LastUpdate")
            Me.OnLastUpdateChanged
        End Set
    End Property
    Private _LastUpdate As Global.System.Nullable(Of Date)
    Partial Private Sub OnLastUpdateChanging(ByVal value As Global.System.Nullable(Of Date))
        End Sub
    Partial Private Sub OnLastUpdateChanged()
        End Sub
    '''<summary>
    '''There are no comments for UserProvider in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmRelationshipNavigationPropertyAttribute("GNUBModel", "FK_UserProvider_Provider", "UserProvider"),  _
     Global.System.Xml.Serialization.XmlIgnoreAttribute(),  _
     Global.System.Xml.Serialization.SoapIgnoreAttribute(),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property UserProvider() As Global.System.Data.Objects.DataClasses.EntityCollection(Of UserProvider)
        Get
            Return CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedCollection(Of UserProvider)("GNUBModel.FK_UserProvider_Provider", "UserProvider")
        End Get
        Set
            If (Not (value) Is Nothing) Then
                CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.InitializeRelatedCollection(Of UserProvider)("GNUBModel.FK_UserProvider_Provider", "UserProvider", value)
            End If
        End Set
    End Property
    '''<summary>
    '''There are no comments for UpdateLog in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmRelationshipNavigationPropertyAttribute("GNUBModel", "FK_UpdateLog_Provider", "UpdateLog"),  _
     Global.System.Xml.Serialization.XmlIgnoreAttribute(),  _
     Global.System.Xml.Serialization.SoapIgnoreAttribute(),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property UpdateLog() As Global.System.Data.Objects.DataClasses.EntityCollection(Of UpdateLog)
        Get
            Return CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedCollection(Of UpdateLog)("GNUBModel.FK_UpdateLog_Provider", "UpdateLog")
        End Get
        Set
            If (Not (value) Is Nothing) Then
                CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.InitializeRelatedCollection(Of UpdateLog)("GNUBModel.FK_UpdateLog_Provider", "UpdateLog", value)
            End If
        End Set
    End Property
End Class
'''<summary>
'''There are no comments for GNUBModel.User in the schema.
'''</summary>
'''<KeyProperties>
'''UserID
'''</KeyProperties>
<Global.System.Data.Objects.DataClasses.EdmEntityTypeAttribute(NamespaceName:="GNUBModel", Name:="User"),  _
 Global.System.Runtime.Serialization.DataContractAttribute(IsReference:=true),  _
 Global.System.Serializable()>  _
Partial Public Class User
    Inherits Global.System.Data.Objects.DataClasses.EntityObject
    '''<summary>
    '''Create a new User object.
    '''</summary>
    '''<param name="userID">Initial value of UserID.</param>
    '''<param name="userLogin">Initial value of UserLogin.</param>
    '''<param name="password">Initial value of Password.</param>
    '''<param name="email">Initial value of Email.</param>
    '''<param name="enabled">Initial value of Enabled.</param>
    Public Shared Function CreateUser(ByVal userID As Global.System.Guid, ByVal userLogin As String, ByVal password() As Byte, ByVal email As String, ByVal enabled As Boolean) As User
        Dim user As User = New User
        user.UserID = userID
        user.UserLogin = userLogin
        user.Password = password
        user.Email = email
        user.Enabled = enabled
        Return user
    End Function
    '''<summary>
    '''There are no comments for Property UserID in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(EntityKeyProperty:=true, IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property UserID() As Global.System.Guid
        Get
            Return Me._UserID
        End Get
        Set
            Me.OnUserIDChanging(value)
            Me.ReportPropertyChanging("UserID")
            Me._UserID = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value)
            Me.ReportPropertyChanged("UserID")
            Me.OnUserIDChanged
        End Set
    End Property
    Private _UserID As Global.System.Guid
    Partial Private Sub OnUserIDChanging(ByVal value As Global.System.Guid)
        End Sub
    Partial Private Sub OnUserIDChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property UserLogin in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property UserLogin() As String
        Get
            Return Me._UserLogin
        End Get
        Set
            Me.OnUserLoginChanging(value)
            Me.ReportPropertyChanging("UserLogin")
            Me._UserLogin = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value, false)
            Me.ReportPropertyChanged("UserLogin")
            Me.OnUserLoginChanged
        End Set
    End Property
    Private _UserLogin As String
    Partial Private Sub OnUserLoginChanging(ByVal value As String)
        End Sub
    Partial Private Sub OnUserLoginChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property Password in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property Password() As Byte()
        Get
            Return Global.System.Data.Objects.DataClasses.StructuralObject.GetValidValue(Me._Password)
        End Get
        Set
            Me.OnPasswordChanging(value)
            Me.ReportPropertyChanging("Password")
            Me._Password = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value, false)
            Me.ReportPropertyChanged("Password")
            Me.OnPasswordChanged
        End Set
    End Property
    Private _Password() As Byte
    Partial Private Sub OnPasswordChanging(ByVal value() As Byte)
        End Sub
    Partial Private Sub OnPasswordChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property Email in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property Email() As String
        Get
            Return Me._Email
        End Get
        Set
            Me.OnEmailChanging(value)
            Me.ReportPropertyChanging("Email")
            Me._Email = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value, false)
            Me.ReportPropertyChanged("Email")
            Me.OnEmailChanged
        End Set
    End Property
    Private _Email As String
    Partial Private Sub OnEmailChanging(ByVal value As String)
        End Sub
    Partial Private Sub OnEmailChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property Enabled in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property Enabled() As Boolean
        Get
            Return Me._Enabled
        End Get
        Set
            Me.OnEnabledChanging(value)
            Me.ReportPropertyChanging("Enabled")
            Me._Enabled = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value)
            Me.ReportPropertyChanged("Enabled")
            Me.OnEnabledChanged
        End Set
    End Property
    Private _Enabled As Boolean
    Partial Private Sub OnEnabledChanging(ByVal value As Boolean)
        End Sub
    Partial Private Sub OnEnabledChanged()
        End Sub
    '''<summary>
    '''There are no comments for UserProvider in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmRelationshipNavigationPropertyAttribute("GNUBModel", "FK_UserProvider_User", "UserProvider"),  _
     Global.System.Xml.Serialization.XmlIgnoreAttribute(),  _
     Global.System.Xml.Serialization.SoapIgnoreAttribute(),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property UserProvider() As Global.System.Data.Objects.DataClasses.EntityCollection(Of UserProvider)
        Get
            Return CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedCollection(Of UserProvider)("GNUBModel.FK_UserProvider_User", "UserProvider")
        End Get
        Set
            If (Not (value) Is Nothing) Then
                CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.InitializeRelatedCollection(Of UserProvider)("GNUBModel.FK_UserProvider_User", "UserProvider", value)
            End If
        End Set
    End Property
End Class
'''<summary>
'''There are no comments for GNUBModel.UserProvider in the schema.
'''</summary>
'''<KeyProperties>
'''UserId
'''ProviderId
'''</KeyProperties>
<Global.System.Data.Objects.DataClasses.EdmEntityTypeAttribute(NamespaceName:="GNUBModel", Name:="UserProvider"),  _
 Global.System.Runtime.Serialization.DataContractAttribute(IsReference:=true),  _
 Global.System.Serializable()>  _
Partial Public Class UserProvider
    Inherits Global.System.Data.Objects.DataClasses.EntityObject
    '''<summary>
    '''Create a new UserProvider object.
    '''</summary>
    '''<param name="userId">Initial value of UserId.</param>
    '''<param name="providerId">Initial value of ProviderId.</param>
    Public Shared Function CreateUserProvider(ByVal userId As Global.System.Guid, ByVal providerId As Global.System.Guid) As UserProvider
        Dim userProvider As UserProvider = New UserProvider
        userProvider.UserId = userId
        userProvider.ProviderId = providerId
        Return userProvider
    End Function
    '''<summary>
    '''There are no comments for Property UserId in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(EntityKeyProperty:=true, IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property UserId() As Global.System.Guid
        Get
            Return Me._UserId
        End Get
        Set
            Me.OnUserIdChanging(value)
            Me.ReportPropertyChanging("UserId")
            Me._UserId = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value)
            Me.ReportPropertyChanged("UserId")
            Me.OnUserIdChanged
        End Set
    End Property
    Private _UserId As Global.System.Guid
    Partial Private Sub OnUserIdChanging(ByVal value As Global.System.Guid)
        End Sub
    Partial Private Sub OnUserIdChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property ProviderId in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(EntityKeyProperty:=true, IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property ProviderId() As Global.System.Guid
        Get
            Return Me._ProviderId
        End Get
        Set
            Me.OnProviderIdChanging(value)
            Me.ReportPropertyChanging("ProviderId")
            Me._ProviderId = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value)
            Me.ReportPropertyChanged("ProviderId")
            Me.OnProviderIdChanged
        End Set
    End Property
    Private _ProviderId As Global.System.Guid
    Partial Private Sub OnProviderIdChanging(ByVal value As Global.System.Guid)
        End Sub
    Partial Private Sub OnProviderIdChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property IsPrimary in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property IsPrimary() As Global.System.Nullable(Of Boolean)
        Get
            Return Me._IsPrimary
        End Get
        Set
            Me.OnIsPrimaryChanging(value)
            Me.ReportPropertyChanging("IsPrimary")
            Me._IsPrimary = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value)
            Me.ReportPropertyChanged("IsPrimary")
            Me.OnIsPrimaryChanged
        End Set
    End Property
    Private _IsPrimary As Global.System.Nullable(Of Boolean)
    Partial Private Sub OnIsPrimaryChanging(ByVal value As Global.System.Nullable(Of Boolean))
        End Sub
    Partial Private Sub OnIsPrimaryChanged()
        End Sub
    '''<summary>
    '''There are no comments for Provider in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmRelationshipNavigationPropertyAttribute("GNUBModel", "FK_UserProvider_Provider", "Provider"),  _
     Global.System.Xml.Serialization.XmlIgnoreAttribute(),  _
     Global.System.Xml.Serialization.SoapIgnoreAttribute(),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property Provider() As Provider
        Get
            Return CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedReference(Of Provider)("GNUBModel.FK_UserProvider_Provider", "Provider").Value
        End Get
        Set
            CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedReference(Of Provider)("GNUBModel.FK_UserProvider_Provider", "Provider").Value = value
        End Set
    End Property
    '''<summary>
    '''There are no comments for Provider in the schema.
    '''</summary>
    <Global.System.ComponentModel.BrowsableAttribute(false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property ProviderReference() As Global.System.Data.Objects.DataClasses.EntityReference(Of Provider)
        Get
            Return CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedReference(Of Provider)("GNUBModel.FK_UserProvider_Provider", "Provider")
        End Get
        Set
            If (Not (value) Is Nothing) Then
                CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.InitializeRelatedReference(Of Provider)("GNUBModel.FK_UserProvider_Provider", "Provider", value)
            End If
        End Set
    End Property
    '''<summary>
    '''There are no comments for User in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmRelationshipNavigationPropertyAttribute("GNUBModel", "FK_UserProvider_User", "User"),  _
     Global.System.Xml.Serialization.XmlIgnoreAttribute(),  _
     Global.System.Xml.Serialization.SoapIgnoreAttribute(),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property User() As User
        Get
            Return CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedReference(Of User)("GNUBModel.FK_UserProvider_User", "User").Value
        End Get
        Set
            CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedReference(Of User)("GNUBModel.FK_UserProvider_User", "User").Value = value
        End Set
    End Property
    '''<summary>
    '''There are no comments for User in the schema.
    '''</summary>
    <Global.System.ComponentModel.BrowsableAttribute(false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property UserReference() As Global.System.Data.Objects.DataClasses.EntityReference(Of User)
        Get
            Return CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedReference(Of User)("GNUBModel.FK_UserProvider_User", "User")
        End Get
        Set
            If (Not (value) Is Nothing) Then
                CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.InitializeRelatedReference(Of User)("GNUBModel.FK_UserProvider_User", "User", value)
            End If
        End Set
    End Property
End Class
'''<summary>
'''There are no comments for GNUBModel.UpdateLog in the schema.
'''</summary>
'''<KeyProperties>
'''UpdateLogId
'''</KeyProperties>
<Global.System.Data.Objects.DataClasses.EdmEntityTypeAttribute(NamespaceName:="GNUBModel", Name:="UpdateLog"),  _
 Global.System.Runtime.Serialization.DataContractAttribute(IsReference:=true),  _
 Global.System.Serializable()>  _
Partial Public Class UpdateLog
    Inherits Global.System.Data.Objects.DataClasses.EntityObject
    '''<summary>
    '''Create a new UpdateLog object.
    '''</summary>
    '''<param name="updateLogId">Initial value of UpdateLogId.</param>
    '''<param name="startDate">Initial value of StartDate.</param>
    Public Shared Function CreateUpdateLog(ByVal updateLogId As Global.System.Guid, ByVal startDate As Date) As UpdateLog
        Dim updateLog As UpdateLog = New UpdateLog
        updateLog.UpdateLogId = updateLogId
        updateLog.StartDate = startDate
        Return updateLog
    End Function
    '''<summary>
    '''There are no comments for Property UpdateLogId in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(EntityKeyProperty:=true, IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property UpdateLogId() As Global.System.Guid
        Get
            Return Me._UpdateLogId
        End Get
        Set
            Me.OnUpdateLogIdChanging(value)
            Me.ReportPropertyChanging("UpdateLogId")
            Me._UpdateLogId = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value)
            Me.ReportPropertyChanged("UpdateLogId")
            Me.OnUpdateLogIdChanged
        End Set
    End Property
    Private _UpdateLogId As Global.System.Guid
    Partial Private Sub OnUpdateLogIdChanging(ByVal value As Global.System.Guid)
        End Sub
    Partial Private Sub OnUpdateLogIdChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property StartDate in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(IsNullable:=false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property StartDate() As Date
        Get
            Return Me._StartDate
        End Get
        Set
            Me.OnStartDateChanging(value)
            Me.ReportPropertyChanging("StartDate")
            Me._StartDate = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value)
            Me.ReportPropertyChanged("StartDate")
            Me.OnStartDateChanged
        End Set
    End Property
    Private _StartDate As Date
    Partial Private Sub OnStartDateChanging(ByVal value As Date)
        End Sub
    Partial Private Sub OnStartDateChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property CompleteDate in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property CompleteDate() As Global.System.Nullable(Of Date)
        Get
            Return Me._CompleteDate
        End Get
        Set
            Me.OnCompleteDateChanging(value)
            Me.ReportPropertyChanging("CompleteDate")
            Me._CompleteDate = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value)
            Me.ReportPropertyChanged("CompleteDate")
            Me.OnCompleteDateChanged
        End Set
    End Property
    Private _CompleteDate As Global.System.Nullable(Of Date)
    Partial Private Sub OnCompleteDateChanging(ByVal value As Global.System.Nullable(Of Date))
        End Sub
    Partial Private Sub OnCompleteDateChanged()
        End Sub
    '''<summary>
    '''There are no comments for Property Status in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmScalarPropertyAttribute(),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property Status() As String
        Get
            Return Me._Status
        End Get
        Set
            Me.OnStatusChanging(value)
            Me.ReportPropertyChanging("Status")
            Me._Status = Global.System.Data.Objects.DataClasses.StructuralObject.SetValidValue(value, true)
            Me.ReportPropertyChanged("Status")
            Me.OnStatusChanged
        End Set
    End Property
    Private _Status As String
    Partial Private Sub OnStatusChanging(ByVal value As String)
        End Sub
    Partial Private Sub OnStatusChanged()
        End Sub
    '''<summary>
    '''There are no comments for Provider in the schema.
    '''</summary>
    <Global.System.Data.Objects.DataClasses.EdmRelationshipNavigationPropertyAttribute("GNUBModel", "FK_UpdateLog_Provider", "Provider"),  _
     Global.System.Xml.Serialization.XmlIgnoreAttribute(),  _
     Global.System.Xml.Serialization.SoapIgnoreAttribute(),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property Provider() As Provider
        Get
            Return CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedReference(Of Provider)("GNUBModel.FK_UpdateLog_Provider", "Provider").Value
        End Get
        Set
            CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedReference(Of Provider)("GNUBModel.FK_UpdateLog_Provider", "Provider").Value = value
        End Set
    End Property
    '''<summary>
    '''There are no comments for Provider in the schema.
    '''</summary>
    <Global.System.ComponentModel.BrowsableAttribute(false),  _
     Global.System.Runtime.Serialization.DataMemberAttribute()>  _
    Public Property ProviderReference() As Global.System.Data.Objects.DataClasses.EntityReference(Of Provider)
        Get
            Return CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.GetRelatedReference(Of Provider)("GNUBModel.FK_UpdateLog_Provider", "Provider")
        End Get
        Set
            If (Not (value) Is Nothing) Then
                CType(Me,Global.System.Data.Objects.DataClasses.IEntityWithRelationships).RelationshipManager.InitializeRelatedReference(Of Provider)("GNUBModel.FK_UpdateLog_Provider", "Provider", value)
            End If
        End Set
    End Property
End Class
