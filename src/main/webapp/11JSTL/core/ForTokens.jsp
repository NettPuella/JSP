<%@page import="java.util.StringTokenizer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSTL - forTokens</title>
</head>
<body>
	<!--  
	forTokens 태그 : 문자열에서 특정 구분자를 통해 반환된 배열의 크기만큼
		반복해야할때 사용한다.
	속성
		items : 구분자를 포함한 문자열을 지정한다. 단 컬렉션이나 배열은
		delims(delimiter) : 구분자를 지정한다. (여러가지 특수기호를
			사용할 수 있다)
		var : 구분자를 통해 잘래낸 토근을 저장한다.
		※토큰이란? 문법적으로 의미있는 최소단위를 말한다. 하이픈으로
			구분되어 있는 전화번호를 분리했을떄 각각의 번호가 토큰이다.
	-->
	<%
	//콤마로 구분된 문자열을 정의한다.
	String rgba = "Red, Green, Blue, Black";
	%>
	<h4>JSTL의 forTokens 태그 사용</h4>
	<c:forTokens items="<%= rgba %>" delims="," var="color">
	<span style="color:${ color };">${ color }</span><br>
	</c:forTokens>
	
	<h4>StringTokenizer 클래스 사용</h4>
	<%
	StringTokenizer tokens = new StringTokenizer(rgba, ",");
	out.println("토큰수:" + tokens.countTokens() + "<bt>");
	while(tokens.hasMoreTokens()){
		String token = tokens.nextToken();
		out.println(token + "<br>");
	}
	%>
	<h4>String 클래스와 slit() 메서드 사용</h4>
	<%
	String[] colorArr = rgba.split(",");
	for(String s : colorArr){
		out.println(s + "<br>");
	}
	%>
</body>
</html>
















