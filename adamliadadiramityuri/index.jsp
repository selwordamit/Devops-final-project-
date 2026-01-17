<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DevOps Project - Simple JSP</title>
</head>
<body>

<h2>Welcome to our JSP Application</h2>

<form method="post">
    Enter text:
    <input type="text" name="userText" />
    <input type="submit" value="Submit" />
</form>

<%
    String text = request.getParameter("userText");
    if (text != null && !text.isEmpty()) {
%>
        <p>You entered: <b><%= text %></b></p>
<%
    }
%>

</body>
</html>