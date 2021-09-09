<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	// 1. WebContent에 upload 폴더 만들기
	
	// 2. 파일을 업로드할 서버상의 실제 경로를 구해온다.
	//String uploadPath = request.getRealPath("/upload"); // 책에서 쓴 위 코드는 권장하지 않음
	ServletContext context = request.getServletContext();
	String uploadPath = context.getRealPath("/upload"); // 루트를 중심으로 상대경로 JSP책 224p참조
	
	// 실제 경로 테스트. 테스트 후 주석처리
	out.println("서버상의 실제 경로(절대경로) : " + uploadPath);
	/*
		//C: C:\Users\yn-08\Documents\정보처리산업기사\JSP2-3\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\Chapter10_파일 업로드\\upload
	*/
	
	// 3. 한번에 올릴 수 있는 최대 파일용량 10M로 제한(파일 여러개를 업로드시 각 용량을 합친 크기)
	int size = 10*1024*1024;
	
	// 바디안에 표현식으로 출력하기 위해 try밖에 변수선언 변수를 try안에 선언하면 try안의 코드실행후 변수들이 스택메모리에서 삭제됨
	String user = ""; // 작성자
	String subject = ""; // 제목
	
	String filename1 = ""; // 서버상의 업로드된 실제 파일명1
	String filename2 = ""; // 서버상의 업로드된 실제 파일명2
	
	String origfilename1 = ""; // 클라이언트 폼에서 선택한 원본파일명1
	String origfilename2 = ""; // 클라이언트 폼에서 선택한 원본파일명2
	
	try {
		// JSP책 309p 참조
		MultipartRequest multi =  new MultipartRequest(request, // request는 폼에서 전달된 파라미터값을 얻기위해 객체지정
				uploadPath, // 파일을 업로드할 서버상의 실제 경로
				size, // 한번에 올릴수 있는 최대용량. 만약 이 크기를 넘는 파일이 전송되어 올 경우 Exception(예외)이 발생하여 업로드 안됨
				"UTF-8", // 파일명이 한글일 경우 한글을 제대로 인식시키기 위해
				new DefaultFileRenamePolicy()); // 예)서버상에 a.txt가 기존에 있을 때 동일파일명으로 업로드한다면 자동으로 인덱스를 부여(a1.txt)하여 파일이름 중복을 피하게해줌

		/*
		★주의사항 : 폼에서 작성자와 제목과 같은 일반 파라미터값들(타입이 file인것 제외한 나머지것들)은
		 		  request의 getParameter()로 반환받을 수 없다.
				   이유? form enctype이 multipart/form-date로 설정되어 있기 때문에
				   그러므로 request의 getParameter()를 쓰지않고 MultipartRequest의 변수의 getParameter()를 쓴다
		*/
		user = multi.getParameter("user");//작성자
		subject = multi.getParameter("subject");//제목
		
		Enumeration<?> files = multi.getFileNames();//파일타입의 Name들을 얻어와
		
		/*책의 저자는 파일이 몇개들어가는지 알기때문에 while문을 안씀*/
		
		/*--------------첫번째 파일--------------*/
		String file1 = (String)files.nextElement(); // 첫번째 파일이름을 얻어와
		// 만약 중복된 이름의 파일이 업로드된 상황이라면 : 서버상에 a.txt있다면 중복은 a1.txt로 변경되어 올라감
		// 서버상의 업로드된 실제 파일명을 얻어오고
		filename1 = multi.getFilesystemName(file1); // a1.txt
		// 클라이언트 폼에서 선택한 원본 파일명을 얻어옴
		origfilename1 = multi.getOriginalFileName(file1); // a.txt
		
		/*--------------두번째 파일--------------*/
		String file2 = (String)files.nextElement();
		filename2 = multi.getFilesystemName(file2);
		origfilename2 = multi.getOriginalFileName(file2);
	} catch (Exception e) {
		//e.printStackTrace();
		out.println("파일 업로드 문제발생" + e); // e : 예외종류 + e.getMessage()호출하여 출력
		// 디스패치 방식(=새요청)으로 fileUploadForm.jsp로 포워딩
		request.getRequestDispatcher("fileUploadForm.jsp").forward(request, response);
	}
%>
<!DOCTYPE html>
<html>
<body>
<!-- 파일 다운로드를 처리하기 위해서 필요한 값들을 hidden타입의 입력상자 값으로 지정 
	  표현식으로 출력하기 위해서는 try안에 변수선언하면 안됨 -->
	<form action="fileCheck.jsp" method="post" name="f">
		<input type="hidden" name="user" value="<%=user %>">
		<input type="hidden" name="subject" value="<%=subject %>">
		
		<input type="hidden" name="filename1" value="<%=filename1 %>">
		<input type="hidden" name="filename2" value="<%=filename2 %>">
		
		<input type="hidden" name="origfilename1" value="<%=origfilename1 %>">
		<input type="hidden" name="origfilename2" value="<%=origfilename2 %>">
	</form>
	<!-- 저자가 전송버튼을 대체하기 위해 만듬 -->
	<a href="#" onclick="javascript:f.submit()">업로드 확인 및 다운로드 페이지로 이동</a>
</body>
</html>