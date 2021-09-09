<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FileUpload Test Form</title>
<style>
	#uploadFormArea {
		margin: auto;
		width: 350px;
		border: 1px solid black;
	}
	.td_title {
		font-size: xx-large;
		text-align: center;
	}
</style>
</head>
<body>
<!-- 파일업로드 주의사항 
1. 서블릿에 요청해 파일업로드, 요청 방식은 반드시 post방식 그래야 용량에 제한없이 파일전송가능
2. 반드시 form의 enctype을 "multipart/form-data"로 설정.
      이 타입으로 지정하지 않으면 파일 선택박스에서 선택된 파일객체가 전송되는것이 아니고
      파일 이름만 문자열형태로 서버로 전송되기 때문에 업로드 기능을 제대로 구현할 수 없다. -->
	<section id="uploadFormArea">
		<form action="fileUpload2.jsp" method="post" enctype="multipart/form-data">
			<table>
				<tr>
					<td colspan="2" class="td_title">파일 업로드 폼</td>
				</tr>
				<tr>
					<td>작성자 : </td>
					<td><input type="text" name="user"></td>
				</tr>
				<tr>
					<td>제목 : </td>
					<td><input type="text" name="subject"></td>
				</tr>
				<tr>
					<td>파일명1 : </td>
					<td><input type="file" name="fileName1"></td>
				</tr>
				<tr>
					<td>파일명2 : </td>
					<td><input type="file" name="fileName2"></td>
				</tr>
				<tr>
					<th colspan="2">
						<input type="submit" value="전송">
					</th>
				</tr>
			</table>
		</form>
	</section>
</body>
</html>