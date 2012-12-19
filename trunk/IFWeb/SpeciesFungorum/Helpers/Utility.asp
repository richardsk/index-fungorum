<%
function encodeHTML(strData)
'take a string HTMLencode then replace the typesetting stuff
strData = server.htmlencode(strData)
strData = replace(strData,"&lt;i&gt;","<i>")
strData = replace(strData,"&lt;/i&gt;","</i>")
strData = replace(strData,"&lt;italic&gt;","<i>")
strData = replace(strData,"&lt;roman&gt;","</i>")
strData = replace(strData,"&lt;b&gt;","<b>")
strData = replace(strData,"&lt;/b&gt;","</b>")
strData = replace(strData,"&lt;bold&gt;","<b>")
strData = replace(strData,"&lt;light&gt;","</b>")
strData = replace(strData,"&lt;p&gt;","<p>")
strData = replace(strData,"&lt;/p&gt;","</p>")
strData = replace(strData,"&lt;sup&gt;","<sup>")
strData = replace(strData,"&lt;/sup&gt;","</sup>")
encodeHTML = strData
end function

function protectSQL(sqlStatement, noPunc)
    'protect from sql injection
    sql = replace(sqlStatement, "'", "''")

    if noPunc then
        sql = replace(sql, "'", "")
        sql = replace(sql, """", "")
        sql = replace(sql, "-", "")
        sql = replace(sql, "=", "")
        sql = replace(sql, "+", "")
        sql = replace(sql, "_", "")
        sql = replace(sql, "[", "")
        sql = replace(sql, "]", "")
        sql = replace(sql, ":", "")
        sql = replace(sql, ";", "")
        sql = replace(sql, "{", "")
        sql = replace(sql, "}", "")
        sql = replace(sql, "<", "")
        sql = replace(sql, ">", "")
        sql = replace(sql, ".", "")
        sql = replace(sql, ",", "")
    end if

    protectSQL = sql
end function
%>