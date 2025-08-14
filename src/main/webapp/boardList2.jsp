<%@page import="member.BoardDto"%>
<%@page import="member.MemberDto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글목록 조회</title>
</head>
<body>
	<%
	
		request.setCharacterEncoding("UTF-8");
		
		//String mid = request.getParameter("sid"); // 아이디
		// DB에 삽입할 준비 완료
		
		//DB에 커넥션 준비
		String driverName = "com.mysql.jdbc.Driver"; // MySQL JDBC 드라이버 이름
		String url = "jdbc:mysql://localhost:3306/jspdb"; // MySQL이 설치된 서버의 주소(ip)와 연결할 DB(스키마) 이름
		// String url = "jdbc:mysql://172.30.1.55:3306";
		String username ="root";
		String password = "12345";
		
		//SQL문
		String sql = "SELECT bnum, btitle, membername, bdate FROM board INNER JOIN members ON board.memberid = members.memberid";
		
		Connection conn = null; // 커넥션 인터페이스를 선언 후 null로 초기화
		Statement stmt = null; // SQL문을 관리해주는 객체를 선언해주는 인터페이스로 stmt 선언 (SQL문을 실행해주는 객체)
		ResultSet rs = null; // select문 실행시 DB에서 반환해주는 레코드 결과를 받아주는 자료타입 rs 선언
		List<BoardDto> boardList = new ArrayList<BoardDto>(); // 1명의 회원정보가 저장될 Dto 객체들이 여러개 저장될 리스트 선언
		
		try {
			Class.forName(driverName); // MySQL 드라이버 클래스 불러오기
			
			conn = DriverManager.getConnection(url, username, password); // 커넥션이 메모리에 생성(DB와 연결 커넥션 conn 생성)
			
			stmt = conn.createStatement(); // stmt 인스턴스화
			
			rs = stmt.executeQuery(sql); // select문 실행 -> 결과가 DB로부터 반환 -> 그 결과(레코드)를 받아주는 ResultSet 타입 객체로 받아야 함.
			

			while (rs.next()) {
				BoardDto boardDto = new BoardDto();
				boardDto.setBnum(rs.getString("bnum"));
				boardDto.setBtitle(rs.getString("btitle"));
				//boardDto.setBcontent(rs.getString("bcontent"));
				boardDto.setMembername(rs.getString("membername"));
				boardDto.setBdate(rs.getString("bdate"));
				
				boardList.add(boardDto);
			}
			
			for(BoardDto bdto : boardList) {
				out.println(bdto.getBnum() + " / ");
				out.println(bdto.getBtitle() + " / ");
				//out.println(bdto.getBnum() + " / ");
				out.println(bdto.getMembername() + " / ");
				out.println(bdto.getBdate() + "<br>");
			}
		} catch (Exception e){
			out.println("DB 에러 발생");
			e.printStackTrace();
		} finally { // 에러 발생여부와 상관없이 Connection 닫기 실행
			try {
				if(rs != null) {
					rs.close();
				}
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
	
	%>
</body>
</html>