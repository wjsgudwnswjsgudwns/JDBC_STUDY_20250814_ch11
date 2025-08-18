<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="member.BoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 조회</title>
</head>
<body>
	<h2>모든 글 목록 리스트</h2>
	<hr>
	<%
		request.setCharacterEncoding("utf-8");
	
		//String mid = request.getParameter("sid"); //조회할 아이디		
		//DB에 삽입할 데이터 준비 완료
		
		//DB 커넥션 준비
		String driverName = "com.mysql.jdbc.Driver"; //MySQL JDBC 드라이버 이름
		String url = "jdbc:mysql://localhost:3306/jspdb"; //MySQL이 설치된 서버의 주소(ip)와 연결할 DB(스키마) 이름		
		String username = "root";
		String password = "12345";
		
		//SQL문 만들기
		//String sql = "SELECT * FROM members WHERE memberid='" + mid + "'";
		String sql = "SELECT * FROM board ORDER BY bnum DESC"; //모든 게시판 글 리스트 반환
		
		
		Connection conn = null; //커넥션 인터페이스로 선언 후 null로 초기값 설정
		Statement stmt = null; //sql문을 관리해주는 객체를 선언해주는 인터페이스로 stmt 선언
		ResultSet rs = null; //select문 실행 시 DB에서 반환해주는 레코드 결과를 받아주는 자료타입 rs 선언
		List<BoardDto> boardList = new ArrayList<BoardDto>();
		//1명의 회원정보 Dto객체들이 여러 개 저장될 리스트 선언
		
		try {
			Class.forName(driverName); //MySQL 드라이버 클래스 불러오기			
			conn = DriverManager.getConnection(url, username, password);
			//커넥션이 메모리 생성(DB와 연결 커넥션 conn 생성)
			stmt = conn.createStatement(); //stmt 객체 생성
			rs = stmt.executeQuery(sql); 
			//select문 실행->결과가 DB로부터 반환->그 결과(레코드(행))을 받아 주는 ResultSet 타입 객체로 받아야 함			
			
			//String sid = null;
			
			while(rs.next()) {
				BoardDto boardDto = new BoardDto();
				boardDto.setBnum(rs.getString("bnum"));
				boardDto.setBtitle(rs.getString("btitle"));
				boardDto.setBcontent(rs.getString("bcontent"));
				boardDto.setMemberid(rs.getString("memberid"));
				boardDto.setBdate(rs.getString("bdate"));
				
				boardList.add(boardDto);
			}
						
			
			for(BoardDto bdto : boardList) {
				out.println(bdto.getBnum() + " / "); 
				out.println(bdto.getBtitle() + " / ");
				out.println(bdto.getBcontent() + " / ");
				out.println(bdto.getMemberid() + " / ");
				out.println(bdto.getBdate() + "<br>");
			}
			
		} catch (Exception e) {
			out.println("DB 에러 발생! 게시판 가져오기 실패!");
			e.printStackTrace(); //에러 내용 출력
		} finally { //에러의 발생여부와 상관 없이 Connection 닫기 실행 
			try {
				if(rs != null) {
					rs.close();
				}				
				if(stmt != null) { //stmt가 null 이 아니면 닫기(conn 닫기 보다 먼저 실행)
					stmt.close();
				}				
				if(conn != null) { //Connection이 null 이 아닐 때만 닫기
					conn.close();
				}
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		request.setAttribute("boardList", boardList);		
		RequestDispatcher dispatcher = request.getRequestDispatcher("boardList.jsp");
		dispatcher.forward(request, response);
	
	%>
</body>
</html>