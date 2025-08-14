<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 글쓰기</title>
</head>
<body>
	<h2>게시판 글쓰기</h2>
	<hr>
		<form action="boardWriteOk.jsp">
			글 제목 : <input type="text" name="btitle"><br><br>
			글 내용 : <textarea rows="15" cols="50" name="bcontent"></textarea><br><br>
			글쓴이 : <input type="text" name="memberid"><br><br>
			<input type="submit" value="글 등록">
		</form>
</body>
</html>