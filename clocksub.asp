<%@Language="vbscript" Codepage="65001"%>
<%
    db="Clockdata.mdb"  
    Set conn = Server.CreateObject("ADODB.Connection")  
    conn.Open "driver={Microsoft Access Driver (*.mdb)};pwd=admin;dbq=" & Server.MapPath(db)   
    'response.write "数据库连接成功！"  
    Set rs = Server.CreateObject( "ADODB.Recordset" )  
    sql = "select * from data where username='" + Request.Form("mUser") + "' and password='" + Request.Form("mPsw") + "'"
    rs.open sql,conn,1,3
    if not rs.EOF then
        rs("workTime") = Request.Form("mWorkTime")
        rs("restTime") = Request.Form("mRestTime")
        rs("tomatoNum") = Request.Form("mTomatoNum")
        rs("nowTomato") = Request.Form("mNowTomato")
        rs("nowstate") = Request.Form("mNowState")
        rs("timetodo") = Request.Form("mTimeToDo")
        rs("record") = Request.Form("mRecord")
        rs("starttime") = now()
        rs.Update
        response.write "ok"
    end if
    rs.Close
    Set conn = Nothing
%>