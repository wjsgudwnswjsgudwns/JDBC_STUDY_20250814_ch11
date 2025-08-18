<%@page import="java.sql.PreparedStatement"%>
<%@page import="member.MemberDto"%>
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
<title>회원 정보 수정</title>
</head>
<body>

	<%
	
		request.setCharacterEncoding("UTF-8");
		
		String mid = request.getParameter("mid"); // 아이디
		String mpw = request.getParameter("mpw"); // 비밀번호
		String mname = request.getParameter("mname"); // 이름
		String memail = request.getParameter("memail"); // 이메일
		// DB에 삽입할 준비 완료
		
		//DB에 커넥션 준비
		String driverName = "com.mysql.jdbc.Driver"; // MySQL JDBC 드라이버 이름
		String url = "jdbc:mysql://localhost:3306/jspdb"; // MySQL이 설치된 서버의 주소(ip)와 연결할 DB(스키마) 이름
		// String url = "jdbc:mysql://172.30.1.55:3306";
		String username ="root";
		String password = "12345";
		
		//SQL문
		String sql = "UPDATE members SET memberpw=?, membername=?, memberemail=? WHERE memberid = ?";
		
		Connection conn = null; // 커넥션 인터페이스를 선언 후 null로 초기화
		// Statement stmt = null; // SQL문을 관리해주는 객체를 선언해주는 인터페이스로 stmt 선언 (SQL문을 실행해주는 객체)
		PreparedStatement pstmt = null; // SQL문을 관리해주는 객체를 선언해주는 인터페이스로 stmt 선언 (SQL문을 실행해주는 객체)
		
		try {
			Class.forName(driverName); // MySQL 드라이버 클래스 불러오기
			
			conn = DriverManager.getConnection(url, username, password); // 커넥션이 메모리에 생성(DB와 연결 커넥션 conn 생성)
			
			pstmt = conn.prepareStatement(sql); // stmt 인스턴스화
			
			pstmt.setString(1, mpw);
			pstmt.setString(2, mname);
			pstmt.setString(3, memail);
			pstmt.setString(4, mid);
			
			int sqlResult = pstmt.executeUpdate(); // SQL문을 DB에서 실행 -> 성공시 1 반환, 실패시 1이 아닌 값을 반환
			
		} catch (Exception e){
			out.println("DB 에러 발생.");
			e.printStackTrace();
		} finally { // 에러 발생여부와 상관없이 Connection 닫기 실행
			try {
				if(pstmt != null) { // stmt가 null이 아니면 닫기. conn 닫기보다 먼저 실행 되어야만 함
					pstmt.close();
				}
				if (conn != null) { // Connection이 null이 아닐때만 닫기 실행
					conn.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		
		//SQL문 만들기
		String sql2 = "SELECT * FROM members WHERE memberid='" + mid + "'";
		//String sql = "SELECT * FROM members where memberid='tiger99'";
			
				
		Connection conn2 = null; //커넥션 인터페이스로 선언 후 null로 초기값 설정
		Statement stmt2 = null; //sql문을 관리해주는 객체를 선언해주는 인터페이스로 stmt 선언
		ResultSet rs2 = null; //select문 실행 시 DB에서 반환해주는 레코드 결과를 받아주는 자료타입 rs 선언
		MemberDto memberDto2 = new MemberDto(); //dto 객체 선언
		
		try {
			Class.forName(driverName); //MySQL 드라이버 클래스 불러오기			
			conn2 = DriverManager.getConnection(url, username, password);
			//커넥션이 메모리 생성(DB와 연결 커넥션 conn 생성)
			stmt2 = conn2.createStatement(); //stmt 객체 생성
			
			
			//int sqlResult = stmt.executeUpdate(sql);
			rs2 = stmt2.executeQuery(sql2); 
			//select문 실행->결과가 DB로부터 반환->그 결과(레코드(행))을 받아 주는 ResultSet 타입 객체로 받아야 함			
			
			//String sid = null;
			
			if(rs2.next()) { //참이면 레코드가 1개 이상 존재->아이디가 존재
				 do { //rs에서 레코드를 추출하는 방법
					String sid = rs2.getString("memberid");
					String spw = rs2.getString("memberpw");
					String sname = rs2.getString("membername");
					String semail = rs2.getString("memberemail");
					String sdate = rs2.getString("memberdate");
					
					memberDto2.setMemberid(sid);
					memberDto2.setMemberpw(spw);
					memberDto2.setMembername(sname);
					memberDto2.setMemberemail(semail);
					memberDto2.setMemberdate(sdate);
											
				} while(rs2.next());
			} else { //거짓이면 레코드가 0개->아이디 존재하지 않음
				response.sendRedirect("memberModify.jsp"); //수정할 멤버 아이디 입력 페이지로 강제 이동
			}
			//if(sid == null) {
				//out.println("** 존재하지 않는 회원입니다 **");
			//}
			
		} catch (Exception e) {
			out.println("DB 에러 발생! 회원 조회 실패!");
			e.printStackTrace(); //에러 내용 출력
		} finally { //에러의 발생여부와 상관 없이 Connection 닫기 실행 
			try {
				if(rs2 != null) {
					rs2.close();
				}				
				if(stmt2 != null) { //stmt가 null 이 아니면 닫기(conn 닫기 보다 먼저 실행)
					stmt2.close();
				}				
				if(conn2 != null) { //Connection이 null 이 아닐 때만 닫기
					conn.close();
				}
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		request.setAttribute("memberDto", memberDto2); 
		//조회된 회원정보가 들어있는 memberDto를 request 객체에 set
		
	
	%>
	<h2>수정된 회원 정보</h2>
	<hr>	
	아이디 : ${memberDto.memberid }<br><br>
	비밀번호 : ${memberDto.memberpw }<br><br>
	이름 : ${memberDto.membername }<br><br>
	이메일 : ${memberDto.memberemail }<br><br>
</body>
</html>