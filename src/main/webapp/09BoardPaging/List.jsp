<%@page import="utils.BoardPage"%>
<%@page import="model1.board.BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model1.board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//DAO객체 생성을 통해 DB에 연결한다.
BoardDAO dao = new BoardDAO(application);

/* 검색어가 있는 경우 클라이언트가 선택한 필드명과 검색어를 저장할
Map컬렉션을 생성한다 */
Map<String, Object> param = new HashMap<String, Object>();

/* 검색폼에서 입력한 필드명을 파라미터로 받아온다. 해당 <form>
태그의 전송방식은 get, action 속성은 없는 상태이므로 현재 페이지로
폼값이 전송된다. */
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
if(searchWord != null){
	/* 클라이언트가 입력한 검색어가 있는경우에만 Map 컬렉션에
	컬럼명과 검색어를 추가한다. 해당 값은 DB처리를 위한 Model객체로
	전달된다. */
	param.put("searchField", searchField);
	param.put("searchWord", searchWord);
}
//Map컬렉션을 인수로 게시물의 갯수를 카운트한다.
int totalCount = dao.selectCount(param);


/* #paging관련 코드 추가 start# */

/* web.xml에 설정한 컨텍스트 초기화 파라미터를 읽어온다.
초기화 파라미터는 String으로 저장되므로 산술연산을 위해 int형으로
변환해야한다. */
int pageSize = Integer.parseInt(application.getInitParameter("POSTS_PER_PAGE"));
int blockPage = Integer.parseInt(application.getInitParameter("PAGES_PER_BLOCK"));
/*
전체 페이지수를 계산한다.
(전체게시물의 갯수 / 페이지당 출력할 게시물 갯수) => 결과값의 올림처리
가령 게시물의 갯수가 51개라면 나눴을대 결과가 5.1이 된다. 이때 무조건
올림처리하여 6페이지로 설정하게된다.
만약 totalCount를 double형으로 변환하지 않으면 정수 결과가 나오게 
되므로 5페이지가 된다. 이 부분을 주의해야한다.
*/
int totalPage = (int)Math.ceil((double)totalCount / pageSize);

/*
목록에 처음 진입했을때는 페이지 관련 파라미터가 없는 상태이므로 무조건
1page로 지정한다. 만약 파라미터 pageNum이 있다면 request내장객체를 통해
받아온 후 페이지번호로 지정한다.
List.jsp -> 이와 같이 파라미터가 없는 상태일때는 null
List.jsp?pageNum= -> 이와 같이 파라미터는 있는데 값이 없을때는 빈값으로
	체크된다. 따라서 아래 if문은 2개의 조건으로 구성해야한다.
*/
int pageNum = 1;
String pageTemp = request.getParameter("pageNum");
if(pageTemp != null && !pageTemp.equals(""))
	pageNum = Integer.parseInt(pageTemp);

/*
게시물의 구간을 계산한다.
각 페이지의 시작번호와 종료번호를 현재페이지번호와 페이지사이즈를 통해
계산한 후 DAO로 전달하기 위해 Map 컬렉션에 추가한다.
*/
int start = (pageNum -1) * pageSize + 1;
int end = pageNum * pageSize;
param.put("start", start);
param.put("end", end);


/* #paging관련 코드 추가 end# */


//목록에 출력할 게시물을 인출하여 반환받는다.
List<BoardDTO>boardLists = dao.selectListPage(param);
//DB 자원 해제
dao.close();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원제 게시판</title>
</head>
<body>
    <jsp:include page="../Common/Link.jsp" />  

    <h2>목록 보기(List) - 현재 페이지 : <%= pageNum %>(전체 : <%= totalPage %>)</h2>
    <!-- 검색폼 -->
    <form method="get">  
    <table border="1" width="90%">
    <tr>
        <td align="center">
            <select name="searchField"> 
                <option value="title">제목</option> 
                <option value="content">내용</option>
            </select>
            <input type="text" name="searchWord" />
            <input type="submit" value="검색하기" />
        </td>
    </tr>   
    </table>
    </form>
    <table border="1" width="90%">
        <tr>
            <th width="10%">번호</th>
            <th width="50%">제목</th>
            <th width="15%">작성자</th>
            <th width="10%">조회수</th>
            <th width="15%">작성일</th>
        </tr>
<%
//컬렉션에 입력된 데이터가 없는지 확인한다.
if(boardLists.isEmpty()){ 
%>
        <tr>
            <td colspan="5" align="center">
                등록된 게시물이 없습니다^^*
            </td>
        </tr>
<%
}
else{
	//게시물이 있을 때
	int virualNum = 0;
	int countNum = 0;
	for(BoardDTO dto : boardLists){
		//virualNumber = totalCount--; //전체 게시물 수에서 시작해서 1씩 감소
		virualNum = totalCount - (((pageNum - 1) * pageSize ) + countNum++);
%>
        <tr align="center">
            <td><%= virualNum %></td>  
            <td align="left"> 
                <a href = "View.jsp?num=<%= dto.getNum() %>"><%= dto.getTitle() %></a>
            </td>
            <td align="center"><%= dto.getId() %></td>           
            <td align="center"><%= dto.getVisitcount() %></td>   
            <td align="center"><%= dto.getPostdate() %></td>    
        </tr>
<%
	}
}
%>
    </table>
   <!-- 목록 하단에 [글쓰기] 버튼 -->
    <table border="1" width="90%">
        <tr align="center">
        	<!-- 페이징 처리 -->
        	<td>
        		<%=BoardPage.pagingImg(totalCount, pageSize, 
        				blockPage, pageNum, request.getRequestURI()) %>
        	</td>
            <td><button type="button" onclick="location.href='Write.jsp';">글쓰기
                </button></td>
        </tr>
    </table>
</body>
</html>