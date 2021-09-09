<%@page import="java.net.URLEncoder"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.Enumeration" %>

<%	// 1. post방식으로 넘겼기 때문에 한글처리를위한 인코딩방식 지정. get방식은 생략가능
	request.setCharacterEncoding("UTF-8");
	// 2. 폼에서 파라미터값을 받아서 각 변수에 저장
	//Enumeration<String> names = request.getParameterNames();
	
	String user = request.getParameter("user");
	String subject = request.getParameter("subject");
	
	String filename1 = request.getParameter("filename1");
	String origfilename1 = request.getParameter("origfilename1");
	
	String filename2 = request.getParameter("filename2");
	String origfilename2 = request.getParameter("origfilename2");
	
	String fileSize1 = request.getParameter("fileSize1");
	String fileSize2 = request.getParameter("fileSize2");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>업로드 확인 및 다운로드</title>
</head>
<body>
	작성자 : <%=user %><br>
	제목 : <%=subject %><br>
	<!-- 주의사항 : 다운로드페이지로 이동할 때 파일이름은 서버상의 실제 파일명을 넣어야한다. 
	★한글파일명을 전송할 경우 인코딩 문제가 발생하여 한글이 깨져 정상작동하지 않을 수 있으므로 항상 인코딩을 해서 전송하자!! -->
	파일명1 : <a href="file_down.jsp?file_name=<%=URLEncoder.encode(filename1,"utf-8") %>"><%=origfilename1 %></a>(<%=fileSize1 %>)bytes<br>
	파일명2 : <a href="file_down.jsp?file_name=<%=URLEncoder.encode(filename2,"utf-8") %>"><%=origfilename2 %></a>(<%=fileSize2 %>)bytes<br>
</body>
</html>