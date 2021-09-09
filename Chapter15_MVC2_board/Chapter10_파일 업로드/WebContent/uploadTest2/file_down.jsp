<%-- <%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%> --%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%	// get방식으로 넘어왔으므로 인코딩방식지정 안해도됨
	// 1. 클라이언트에서 파라미터로 전송한 다운로드할 파일이름(중복 방지처리한 파일명)을 얻어옴
	String fileName = request.getParameter("file_name"); // 예) a1.txt

	// 2. 업로드한 폴더의 위치와 업로드 폴더의 이름을 알아야 한다.
	String savePath = "upload"; // 서버에 파일이 업로드된 폴더명 지정
	
	// 이때, 절대경로 기준의 진짜 경로를 얻어와야한다.
	ServletContext context = request.getServletContext();
	String sDownloadPath = context.getRealPath(savePath); // 예) c:/test/upload
	
	// 실제 경로 테스트. 테스트 후 주석처리
	System.out.println("서버상의 실제 경로(절대경로) : " + sDownloadPath);
	
	// 3. 저장되어있는 폴더경로/저장된 파일명으로 풀path를 만들어준다.
	//String sFilePath = sDownloadPath + "\\" + fileName; // 예) c:\\test\\upload\\a1.txt
	//★ File.separator : 윈도우면 \(원표시), 리눅스면 /로 표시해줌
	String sFilePath = sDownloadPath + File.separator + fileName;
	
	// 4. 풀path에 대한걸 파일객체로 인식시킨다.
	File file = new File(sFilePath);
	
	// 5. 한번에 읽고 출력할 바이트 크기로 배열 생성
	// 저장된 파일을 읽어와 저장할 버퍼를 임시로 만들고 버퍼의 용량은 이전에 한번에 업로드할 수 있는 파일 크기로 지정한다.
	byte[] b = new byte[10*1024*1024]; //10M
	
	// 6. 다운로드할 파일의 경로를 매개값으로 지정하면서 FileInputStream객체 생성
	FileInputStream in = new FileInputStream(file);
	
	// 7. 유형 확인 : 읽어올 경로의 파일의 유형 -> 페이지 생성할 때 타입을 설정해야한다.
	String sMimeType = request.getServletContext().getMimeType(sFilePath);
	
	out.println("sMimeType(MIME 타입유형) >> " + sMimeType); // 실행 후 주석처리
	
	// 8. 지정되지 않은 MIME타입유형은 예외발생
	if (sMimeType == null) { // 다운로드 할 파일의 MIME타입이 제대로 반환되지 않으면
		sMimeType = "application/octet-stream"; // 기본 MIME타입을 지정한다.
	}
	
	// 9. 파일 다운로드 시작 - 유형을 지정해준다.
	// 응답할 데이터의 MIME타입을 다운로드할 파일의 MIME타입으로 지정
	response.setContentType(sMimeType); // 원래는 "text/html"인데 -> 다운로드할 파일의 MIME타입으로 수정
	
	// 10. 브라우저에 따라 업로드 파일의 제목이 깨질 수 있으므로 인코딩을 해준다.
	// 클라이언트가 사용하는 브라우저 종류가 Internet Explorer(=IE)이면
	// 다운로드 시 한글파일명이 깨지지 않도록 UTF-8로 처리하고
	// Internet Explorer(=IE)의 경우 공백 부분이 + 문자로 변경되므로 다시 공백문자(%20)으로 변경해 줘야함
	String agent = request.getHeader("user-Agent");
	String fileNameEncoding;
	if (agent.indexOf("MSIE") > -1 || agent.indexOf("Trident") > -1) {
		fileNameEncoding = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
	} else {
		// 사용브라우저 종류가 Internet Explorer(=IE)가 아니면
		// 다운로드시 한글 파일명이 깨지지 않도록 UTF-8로 처리
		fileNameEncoding = new String(fileName.getBytes("UTF-8"),"ISO-8859-1"); // ISO-8859-1 아니면 8859_1로 써도됨
	}
	/*
	UTF-8은 모든 유니코드 문자를 나타낼 수 있는 멀티 바이트 인코딩이다.(가변길이 인코딩)
	ISO-8859-1은 첫 256개의 유니코드 문자를 나타낼 수 있는 1바이트 인코딩이다.(1바이트 고정길이 인코딩)
	*/
	
	// 11. 브라우저에서 해석되어 실행되는 파일들(JPG,html등)도 다운로드 박스가 출력되도록 처리하는 방식
	// Content-Disposition값을 attachment로 설정하면 모든 파일에 대해서 다운로드 박스가 실행됨
	response.setHeader("Content-Disposition", "attachment; filename=" + fileNameEncoding);
	
	// 12. 브라우저에 쓰기
	// 12-1. 파일 다운로드 역할을 하는 바이트 기반 출력 스트림 객체를 생성
	ServletOutputStream out2 = response.getOutputStream(); // out은 이미 내장객체로 존재하므로 out2라고 변수 선언함
	
	/*  12-2. 바이트배열 b의 인덱스 0부터 한번에 최대 b.length만큼 읽어온다.
		이때, 파일이 위치한 곳에 연결된 InputStream(=in)에서 읽되 끝(-1) 전까지 while문을 반복
	*/
	int numRead;
	while((numRead = in.read(b, 0, b.length)) != -1) {
		// 12-3. 읽어올 것이 더이상 없으면 -1을 리턴하면서 while문을 종료
		
		// 12-4. 브라우저에 출력
		out2.write(b, 0, numRead); // b배열에 있는 데이터의 0번째(인덱스)부터 최대 numRead 만큼 출력한다.
	}
	
	// 13. 자원해제
	out2.flush();
	out2.close();
	in.close();
%>