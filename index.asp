<%@Language="vbscript" Codepage="65001"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta content="width=device-width, initial-scale=0.7, maximum-scale=0.7, user-scalable=no" name="viewport" />
    <link rel="shortcut icon" type="image/x-icon" href="clock.ico" />
    <link rel="stylesheet" type="text/css" href="clockstyle.css">
    <title>番茄在线</title>
</head>
<body>
    <div class="out">
    <h1 id="info">尚未开始</h1>
    <p id="time" class="time">您的浏览器不支持JavaScript，请换一个支持它的浏览器！</p>
    <p id="stateInput">你要做什么：<input id="inputState" value="工作"/></p>
    <div id="buttons">
        <button id="settings"， onclick="settings()">设置</button>
        <button id="bt", onclick="clickButton()">开始</button>
    </div>
    <div id="set", hidden>
        <br />
        <p>工作分钟(1-480)  ：<input id="workTime", type="number" /></p>
        <p>休息分钟(1-480)  ：<input id="restTime", type="number" /></p>
        <p>番茄总数(1- 50)   ：<input id="tomatoNum", type="number" /></p>
        <button id="save", onclick="save()">保存</button>
    </div>
    <script>
    <!--
        // Get all the cookies
        var cookies = document.cookie.split(';');
        // Get specific one
        function getCookie(key) {
            var name = key + "=";
            for (var i = 0; i < cookies.length; i++) {
                // trim is used to clear all the spaces before and after a string
                var c = cookies[i].trim();
                if (c.indexOf(name) == 0)
                    return c.substring(name.length, c.length);
            }
            return "None!";
        }
        // Set a specific cookie
        function setCookie(key, value, exdays) {
            var date = new Date();
            date.setTime(date.getTime() + (exdays * 24 * 60 * 60 * 1000));
            document.cookie = key + "=" + value + "; expires=" + date.toGMTString();
        }
		function setCookie(key, value) {
            var date = new Date();
            date.setTime(date.getTime() + (10 * 365 * 24 * 60 * 60 * 1000));
            document.cookie = key + "=" + value + "; expires=" + date.toGMTString();
        }
        // Change a number into a string
        function zeroBeforeNum(num) {
            if (num < 10) {
                return "0" + num.toString();
            }
            else {
                return num.toString();
            }
        }
        // Get the shown number
        function getShowTime(secondsLasted) {
            return zeroBeforeNum(Math.floor(secondsLasted / 60)) + ":" + zeroBeforeNum(secondsLasted % 60);
        }
        // Set the shown number
        function setShowTime(secondsLasted) {
            timeP.innerText = getShowTime(secondsLasted);
        }
        // Set the info text
        function infoText(text) {
            infoT.innerText = text;
        }
        // Set button text
        function buttonShow(text) {
            btT.innerText = text;
        }
        var data = NaN;
        // Check if set workTime
        if (getCookie("workTime") == "None!" || isNaN(data = parseInt(getCookie("workTime"))) || data > 480 || data < 1) {
            setCookie("workTime", 25);
            var workTime = 25;
        }
        else {
            var workTime = data;
        }
        // Check if set restTime
        if (getCookie("restTime") == "None!" || isNaN(data = parseInt(getCookie("restTime"))) || data > 480 || data < 1) {
            setCookie("restTime", 5);
            var restTime = 5;
        }
        else {
            var restTime = data;
        }
        // Check if set tomatoNum
        if (getCookie("tomatoNum") == "None!" || isNaN(data = parseInt(getCookie("tomatoNum"))) || data > 50 || data < 1) {
            setCookie("tomatoNum", 2);
            var tomatoNum = 2;
        }
        else {
            var tomatoNum = data;
        }
        document.getElementById("workTime").value = workTime;
        document.getElementById("restTime").value = restTime;
        document.getElementById("tomatoNum").value = tomatoNum;
        // Initial
        var nowWorking = true;
        var nowStarted = false;
        var timeP = document.getElementById("time");
        var infoT = document.getElementById("info");
        var btT = document.getElementById("bt");
        var stB = document.getElementById("settings");
        var setD = document.getElementById("set");
        var nowSec = workTime * 60;
        var nowTomato = 1;
        var recorder = "";
        var nowState = "工作";
        setShowTime(nowSec);
        // CountDown Program
        function countDown() {
            if (nowSec > 0) {
                nowSec -= 1;
            }
            else {
                if (nowTomato == tomatoNum) {
                    // Need to initial again
                    document.getElementById("stateInput").hidden = false;
                    nowStarted = false;
                    nowSec = workTime * 60;
                    nowTomato = 1;
                    infoText("已结束");
                    nowState = "NoData";
                    buttonShow("开始");
                    recorder += "<stop><tomatoNum>" + tomatoNum + "</tomatoNum><nowState>" + nowState + "</nowState><workTime>" + workTime + "</workTime><restTime>" + restTime + "</restTime></stop>";
                    updateData();
                }
                else if (nowWorking == true) {
                    nowWorking = false;
                    nowSec = restTime * 60;
                    nowState = "休息";
                    infoText("休息中..." + nowTomato + "/" + (tomatoNum - 1));
                    recorder += "<rest><nowTomato>" + nowTomato + "</nowTomato><tomatoNum>" + tomatoNum + "</tomatoNum><nowState>" + nowState + "</nowState><workTime>" + workTime + "</workTime><restTime>" + restTime + "</restTime></rest>";
                    updateData();     
                }
                else {
                    nowWorking = true;
                    nowSec = workTime * 60;
                    nowTomato += 1;
                    nowState = document.getElementById("inputState").value;
                    infoText(nowState + "中..." + nowTomato + "/" + tomatoNum);
                    recorder += "<start><nowTomato>" + nowTomato + "</nowTomato><tomatoNum>" + tomatoNum + "</tomatoNum><nowState>" + nowState + "</nowState><workTime>" + workTime + "</workTime><restTime>" + restTime + "</restTime></start>"
                    updateData();
                }
            }
            setShowTime(nowSec);
        }
        // Run!
        setInterval(function () {
            if (nowStarted) {
                countDown();
            }
        }, 1000)
        // Start
        function start() {
            document.getElementById("stateInput").hidden = true;
            nowStarted = true;
            nowWorking = true;
            nowTomato = 1;
            nowState = document.getElementById("inputState").value;
            infoText(nowState + "中..." + nowTomato + "/" + tomatoNum);
            buttonShow("结束");
            recorder += "<start><nowTomato>" + nowTomato + "</nowTomato><tomatoNum>" + tomatoNum + "</tomatoNum><nowState>" + nowState + "</nowState><workTime>" + workTime + "</workTime><restTime>" + restTime + "</restTime></start>";
            updateData();
            nowSec = workTime * 60;
            setShowTime(nowSec);
        }
        // Stop
        function stop() {
            document.getElementById("stateInput").hidden = false;
            nowStarted = false;
            nowWorking = true;
            nowTomato = 1;
            infoText("已结束");
            nowState = "NoData";
            buttonShow("开始");
            nowSec = 0;
            recorder += "<quit><nowTomato>" + nowTomato + "</nowTomato><tomatoNum>" + tomatoNum + "</tomatoNum><nowState>" + nowState + "</nowState><workTime>" + workTime + "</workTime><restTime>" + restTime + "</restTime></quit>";
            updateData();
            nowSec = workTime * 60;
            setShowTime(nowSec);
        }
        // ClickButton
        function clickButton() {
            if (nowStarted) {
                stop();
            }
            else {
                start();
            }
        }
        // Settings
        function settings() {
            if (setD.hidden == true) {
                setD.hidden = false;
                stB.innerText = "收起";
            }
            else {
                setD.hidden = true;
                stB.innerText = "设置";
            }
        }
        // Save settings
        function save() {
            var data1 = Math.floor(parseInt(document.getElementById("workTime").value));
            var data2 = Math.floor(parseInt(document.getElementById("restTime").value));
            var data3 = Math.floor(parseInt(document.getElementById("tomatoNum").value));
            if (isNaN(data1) || data1 < 1 || data1 > 480 || isNaN(data2) || data2 < 1 || data2 > 480
                || isNaN(data3) || data3 < 1 || data3 > 50) {
                alert("数据有误！请检查后重新输入！");
            }
            else {
                document.getElementById("workTime").value = (workTime = data1);
                document.getElementById("restTime").value = (restTime = data2);
                document.getElementById("tomatoNum").value = (tomatoNum = data3);
                setCookie("workTime", workTime);
                setCookie("restTime", restTime);
                setCookie("tomatoNum", tomatoNum);
                updateData();
                alert("设置成功！");
            }
        }
    //-->
    </script>
    <%
        if request.querystring("user")<> "" and request.querystring("psw")<> "" then
            db="Clockdata.mdb"  
            Set conn = Server.CreateObject("ADODB.Connection")  
            conn.Open "driver={Microsoft Access Driver (*.mdb)};pwd=admin;dbq=" & Server.MapPath(db)   
            'response.write "数据库连接成功！"  
            Set rs = Server.CreateObject( "ADODB.Recordset" )  
            sql = "select * from data where username='" + request.querystring("user") + "' and password='" + request.querystring("psw") + "'"
            rs.open sql,conn,1,1
            '这里设置成只读
            if not rs.EOF then
                response.write "<iframe id=""hidden_iframe"" name=""hidden_iframe"" hidden></iframe>"
                response.write "<form id=""me"" name=""me"" method=""post"" hidden action=""clocksub.asp"" target=""hidden_iframe"">"
                response.write "<input id=""mWorkTime"" name=""mWorkTime"" hidden value="""
                response.write rs("workTime")
                response.write """/><input id=""mRestTime"" name=""mRestTime"" hidden value="""
                response.write rs("restTime")
                response.write """/><input id=""mTomatoNum"" name=""mTomatoNum"" hidden value="""
                response.write rs("tomatoNum")
                response.write """/><input id=""mNowTomato"" name=""mNowTomato"" hidden value="""
                response.write rs("nowTomato")
                response.write """/><input id=""mNowState"" name=""mNowState"" hidden value="""
                response.write rs("nowstate")
                response.write """/><input id=""mTimeToDo"" name=""mTimeToDo"" hidden value="""
                response.write rs("timetodo")
                response.write """/><input id=""mRecord"" name=""mRecord"" hidden value="""
                response.write rs("record")
                response.write """/><input id=""mUser"" name=""mUser"" hidden value="""
                response.write request.querystring("user")
                response.write """/><input id=""mPsw"" name=""mPsw"" hidden value="""
                response.write request.querystring("psw")
                response.write """/></form><p id=""mStartTime"" hidden>"
                response.write DateDiff("s", rs("starttime"), now())
                response.write "</p>"
                'response.write "登陆成功！正在读取另一半数据..."
                sql = "select * from data where username='" + rs("pairname") + "'"
                rs.close
                rs.open sql,conn,1,1
                if not rs.EOF then
                    '两个引号代表转义后的引号
                    response.write "<br /><br />"
                    response.write "<div id=""other""><h1 id=""pairstate"" hidden>"
                    response.write rs("nowstate") + "中..."
                    response.write "</h1><p id=""pairtime"" class=""time"" hidden>"
                    response.write rs("timetodo")
                    response.write "</p><p id=""starttime"" hidden>"
                    response.write DateDiff("s", rs("starttime"), now())
                    response.write "</p></div>"
                end if
                rs.close
            else
                rs.close
            end if
            conn.Close
        end if
    %>
    <script>
    <!--
        function pairTimeGet() {
            if(timePairLeft >= 0) {
                document.getElementById("pairtime").innerText = getShowTime(timePairLeft);
            }
            timePairLeft -= 1;
            if(timePairLeft < 0) {
                location.reload();
            }
        }
        function pairStateGet() {
            if(stateGetCount >= 0) {
                document.getElementById("pairstate").innerText = "对方目前没有使用番茄在线，" + stateGetCount + "秒后自动刷新...";
            }
            stateGetCount -= 1;
            if(stateGetCount < 0) {
                location.reload();
            }
        }
        function updateData() {
            if(me) {
                document.getElementById("mWorkTime").value = workTime;
                document.getElementById("mRestTime").value = restTime;
                document.getElementById("mTomatoNum").value = tomatoNum;
                document.getElementById("mNowTomato").value = nowTomato;
                document.getElementById("mTimeToDo").value = nowSec;
                document.getElementById("mRecord").value = recorder;
                document.getElementById("mNowState").value = nowState;
                me.submit();
            }
        }
        var me = document.getElementById("me");
        if(me) {
            workTime = Math.floor(parseInt(document.getElementById("mWorkTime").value));
            restTime = Math.floor(parseInt(document.getElementById("mRestTime").value));
            tomatoNum = Math.floor(parseInt(document.getElementById("mTomatoNum").value));
            if (document.getElementById("mNowState").value != "NoData" && (Math.floor(parseInt(document.getElementById("mTimeToDo").value)) > Math.floor(parseInt(document.getElementById("mStartTime").innerText)))) {
                nowTomato = Math.floor(parseInt(document.getElementById("mNowTomato").value));
                nowSec = Math.floor(parseInt(document.getElementById("mTimeToDo").value)) - Math.floor(parseInt(document.getElementById("mStartTime").innerText));
                setShowTime(nowSec);
                recorder = document.getElementById("mRecord").value;
                nowState = document.getElementById("mNowState").value;
                document.getElementById("inputState").value = nowState;
                nowStarted = true;
                document.getElementById("stateInput").hidden = true;
                buttonShow("结束");
                if (nowState == "休息") {
                    nowWorking = false;
                    infoText("休息中..." + nowTomato + "/" + (tomatoNum - 1));
                }
                else {
                    infoText(nowState + "中..." + nowTomato + "/" + tomatoNum);
                }
            }
            document.getElementById("workTime").value = workTime;
            document.getElementById("restTime").value = restTime;
            document.getElementById("tomatoNum").value = tomatoNum;
            setCookie("workTime", workTime);
            setCookie("restTime", restTime);
            setCookie("tomatoNum", tomatoNum);
        }
        var other = document.getElementById("other");
        if(other){
            if(document.getElementById("pairstate").innerText == "NoData中...") {
                document.getElementById("pairstate").hidden = false;
                var stateGetCount = 600;
                document.getElementById("pairstate").innerText = "对方目前没有使用番茄在线，600秒后自动刷新...";
                setInterval(function(){pairStateGet();}, 1000);
            }
            else{
                var timePairLeft = Math.floor(parseInt(document.getElementById("pairtime").innerText)) - Math.floor(parseInt(document.getElementById("starttime").innerText));
                if(timePairLeft >= 0) {
                    pairTimeGet();
                    document.getElementById("pairtime").hidden = false;
                    document.getElementById("pairstate").hidden = false;
                    setInterval(function(){pairTimeGet();}, 1000);
                }
                else if(timePairLeft > -5) {
                    location.reload();
                }
                else {
                    document.getElementById("pairstate").hidden = false;
                    var stateGetCount = 600;
                    document.getElementById("pairstate").innerText = "对方目前没有使用番茄在线，600秒后自动刷新...";
                    setInterval(function(){pairStateGet();}, 1000);
                }
            }
        }
    //-->
    </script>
    <br />
    <ul>
        <li>
            <p class ="update-info">欢迎关注我们的公众号：</p>
            <div id="jpgs">
                <img src="mp1.jpg" />
                <img src="mp2.jpg" />
            </div>
        </li>
        <li>
            <p class ="update-info">我们的<a href="http://fengh16.github.io">网站</a></p>
        </li>
    </ul>
    <p class="translators_name">Build: 2017.8.16 20:05:21</p>
    </div>
    <noscript>
</body>
</html>