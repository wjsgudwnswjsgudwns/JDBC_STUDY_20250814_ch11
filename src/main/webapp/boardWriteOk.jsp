<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 등록 확인</title>
</head>
<body>
	<%
	
		request.setCharacterEncoding("UTF-8");
		
		String btitle = request.getParameter("btitle"); // 제목
		String bcontent = request.getParameter("bcontent"); // 내용
		String memberid = request.getParameter("memberid"); // 이름
		// DB에 삽입할 준비 완료
		
		//DB에 커넥션 준비
		String driverName = "com.mysql.jdbc.Driver"; // MySQL JDBC 드라이버 이름
		String url = "jdbc:mysql://localhost:3306/jspdb"; // MySQL이 설치된 서버의 주소(ip)와 연결할 DB(스키마) 이름
		// String url = "jdbc:mysql://172.30.1.55:3306";
		String username ="root";
		String password = "12345";
		
		//SQL문
		String sql = "INSERT INTO board(btitle, bcontent, memberid) VALUES ('"+btitle+"','"+bcontent+"','"+memberid+"')";
		
		Connection conn = null; // 커넥션 인터페이스를 선언 후 null로 초기화
		Statement stmt = null; // SQL문을 관리해주는 객체를 선언해주는 인터페이스로 stmt 선언 (SQL문을 실행해주는 객체)
		int result = 0; //글 삽입 성공 여부 저장할 변수
		
		try {
			Class.forName(driverName); // MySQL 드라이버 클래스 불러오기
			
			conn = DriverManager.getConnection(url, username, password); // 커넥션이 메모리에 생성(DB와 연결 커넥션 conn 생성)
			
			stmt = conn.createStatement(); // stmt 인스턴스화
			result = stmt.executeUpdate(sql); //성공하면 1이 반환, 실패하면 0이 반환
			int sqlResult = stmt.executeUpdate(sql); // SQL문을 DB에서 실행 -> 성공시 1 반환, 실패시 1이 아닌 값을 반환
			
		} catch (Exception e){
			out.println("DB 에러 발생. 회원가입 실패.");
			e.printStackTrace();
		} finally { // 에러 발생여부와 상관없이 Connection 닫기 실행
			try {
				if(stmt != null) { // stmt가 null이 아니면 닫기. conn 닫기보다 먼저 실행 되어야만 함
					stmt.close();
				}
				if (conn != null) { // Connection이 null이 아닐때만 닫기 실행
					conn.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if(result == 1) { //참이면 글쓰기 성공->글 목록 출력 화면으로 이동
			RequestDispatcher dispatcher = request.getRequestDispatcher("boardWriteList.jsp");
			dispatcher.forward(request, response);
		}
		
		//request.setAttribute("boardList", boardList);
		//RequestDispatcher dispatcher = request.getRequestDispatcher("boardList.jsp");
		//dispatcher.forward(request, response);
	%>
	
	<a href="boardWrite.jsp">글 쓰기</a>
	<a href="boardList.jsp">글목록 보기</a>
</body>
</html>