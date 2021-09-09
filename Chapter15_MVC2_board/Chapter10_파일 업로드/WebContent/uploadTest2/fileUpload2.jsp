<%@page import="java.io.File"%>
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
	
	String filename = ""; // 서버상의 업로드된 실제 파일명
	String origfilename = ""; // 클라이언트 폼에서 선택한 원본파일명
	
	String fileType = ""; // 파일타입
	File realfile = null;
	
	long fileSize = 0; // 파일 용량 사이즈
	
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
%>
<html>
<body>
	<form action="fileCheck.jsp" method="post" name="f">
		<input type="hidden" name="user" value="<%=user %>">
		<input type="hidden" name="subject" value="<%=subject %>">
		<%
			int i = 1;
			while (files.hasMoreElements()) {
				String file = (String)files.nextElement(); // 첫번째 파일이름 얻어와...두번째~
				
				// 원본 파일이름
				origfilename = multi.getOriginalFileName(file);
				if (origfilename == null) continue; // 3개의 파일 중 만약 두번째 파일을 올리지 않았다면 세번째 파일을 받기위해 위로올라감
				
				// 중복 처리한 파일이름
				filename = multi.getFilesystemName(file);
				
				// 전송된 파일 타입 정보를 가져옴(MIME 타입 : JPG, html,txt 등)
				fileType = multi.getContentType(file);
				
				realfile = multi.getFile(file); // 실제 파일을 가져옴
				fileSize = realfile.length(); // 그 파일객체의 크기를 알아냄
				
				// 테스트 테스트 후 주석처리
				out.println("파라미터 이름 : " + file + "<br>");
				out.println("실제 파일 이름 : " + origfilename + "<br>");
				out.println("서버에 저장된 파일 이름 : " + filename + "<br>");
				out.println("파일 타입 : " + fileType + "<br>");
				
				if (realfile != null) {
					out.println("파일 크기 : " + fileSize + "<br>" );
				}
				out.println("----------------------------------------<br>");
		%>
				<input type="hidden" name="filename<%=i %>" value="<%=filename %>">
				<input type="hidden" name="origfilename<%=i %>" value="<%=origfilename %>">
				<input type="hidden" name="fileSize<%=i %>" value="<%=fileSize %>">
		<%
			i++; // 1->2
			} // while문의 끝
		%>
	</form>
<%
	} catch (Exception e) {
		//e.printStackTrace();
		out.println("파일 업로드 문제발생" + e); // e : 예외종류 + e.getMessage()호출하여 출력
		// 디스패치 방식(=새요청)으로 fileUploadForm.jsp로 포워딩
		request.getRequestDispatcher("fileUploadForm.jsp").forward(request, response);
	}
%>

	<!-- 저자가 전송버튼을 대체하기 위해 만듬 -->
	<a href="#" onclick="javascript:f.submit()">업로드 확인 및 다운로드 페이지로 이동</a>
</body>
</html>