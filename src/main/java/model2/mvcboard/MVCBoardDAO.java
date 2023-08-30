package model2.mvcboard;

import java.util.List;
import java.util.Map;
import java.util.Vector;

import common.DBConnPool;
import common.JDBConnect;
import jakarta.servlet.ServletContext;
import model1.board.BoardDTO;

//커넥션풀을 통한 DB연결을 위해 클래스 상속
public class MVCBoarDAO extends DBConnPool{
	
	//기본생성자 (정의하지 않아도 자동으로 삽입된다.)
	public MVCBoarDAO() {
		super();
	}
	/* 게시물의 갯수를 카운트한다. 검색어가 있는 경우 where절을
	추가하여 조건에 맞는 게시물을 카운트한다. */
	public int selectCount(Map<String, Object> map) {
			
			
			int totalCount = 0;
			String query = "SELECT COUNT(*) FROM mvcboard";
			if(map.get("searchWord") != null) {
				query += " WHERE " + map.get("searchField") + " "
						+ " LIKE '%" + map.get("searchWord") + "%'";
			}
			
			try {
				//인파라미터가 없는 정적쿼리문이므로 statement인터페이스 생성
				stmt = con.createStatement();
				/* count(*)는 항상 결과값이 있다. 조건에 맞는게 없으면 0, 아니면
				1 이상의 값을 반환한다. */
				rs = stmt.executeQuery(query);
				
				rs.next();
				
				totalCount = rs.getInt(1);
			} 
			catch (Exception e) {
				System.out.println("게시물 카운트 중 예외 발생");
				e.printStackTrace();
			}
			return totalCount;
		}
		//목록에 출력할 게시물을 얻어오기 위한 메서드
		public List<MVCBoardDTO> selectList(Map<String, Object>map){
			
			//mvcboard테이블을 대상으로 하므로 타입매개변수 확인 필요함.
			List<MVCBoardDTO> bbs = new Vector<MVCBoardDTO>();
			
			/* 페이징 처리를 위한 서브쿼리문. 특정 페이지에 해당하는 rownum의
			구간으로 */
			String query = "SELECT * FROM ("
						+ " SELECT Tb.*, ROWNUM rNum FROM ("
						+ "  SELECT * FROM mvcboard";
						
			if(map.get("searchWord") != null) {
				query += " WHERE " + map.get("searchField") + " "
						+ "LIKE'%" + map.get("searchWord") + "%' ";
			}
			query += " ORDER BY idx DESC "
					+ " )Tb"
					+ " ) "
					+ "WHERE rNum BETWEEN ? AND?";
			
			try {
				/* 인파라미터가 있는 동적쿼리문이므로 prepared객체 생성 및
				인파라미터 설정 */
				psmt = con.prepareStatement(query);
				psmt.setString(1, map.get("start").toString());
				psmt.setString(1, map.get("start").toString());
				rs = psmt.executeQuery();
				
				while(rs.next()) {
					
					MVCBoardDTO dto = new MVCBoardDTO();
					
					dto.setIdx(rs.getString(1));
					dto.setName(rs.getString(2));
					dto.setTitle(rs.getString(3));
					dto.setContent(rs.getString(4));
					dto.setPostdate(rs.getDate(5));
					dto.setOfile(rs.getString(6));
					dto.setSfile(rs.getString(7));
					dto.setDowncount(rs.getInt(8));
					dto.setPass(rs.getString(9));
					dto.setVisitcount(rs.getInt(10));
					
					board.add(dto);
				}
			} 
			catch (Exception e) {
				System.out.println("게시물 조회 중 예외 발생");
				e.printStackTrace();
			}
			
			return board;
		}
		