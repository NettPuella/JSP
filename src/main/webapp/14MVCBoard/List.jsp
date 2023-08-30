<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일 첨부형 게시판</title>
<style>a{text-decoration:none;}</style>
</head>
<body>
    <h2>파일 첨부형 게시판 - 목록 보기(List)</h2>

    <!-- 검색 폼 -->
    <form method="get">  
    <table border="1" width="90%">
    <tr>
        <td align="center">
            <select name="searchField">
                <option value="title">제목</option>
                <option value="content">내용</option>
                <option value="name">작성자</option>
            </select>
            <input type="text" name="searchWord" />
            <input type="submit" value="검색하기" />
        </td>
    </tr>
    </table>
    </form>

    <!-- 목록 테이블 -->
    <table border="1" width="90%">
        <tr>
            <th width="10%">번호</th>
            <th width="*">제목</th>
            <th width="15%">작성자</th>
            <th width="10%">조회수</th>
            <th width="15%">작성일</th>
            <th width="8%">첨부</th>
        </tr>
<!-- 게시물이 없을 때 -->
<c:choose>
	<c:when test="${ empty boardLists }">
		<tr>
			<td colspan="6" align="center">
				등록된 게시물이 없습니다.^^*
			</td>
		</tr>
	</c:when>
	<c:otherwise>
		<c:forEach items="${ boardLists }" var="row" varStatus="loop">
		<tr align="center">
			<td>
				${map.totalCount - (((map.pageNum-1) * map.pageSize)
					+ loop.index)}
			</td>
			<td align="left">
				<a href="../mvcboard/view.do?idx=${ row.idx }"></a>
					${ row.title }</a>
			</td>
			<td>${ row.name }</td>
			<td>${ row.visitcount }</td>
			<td>${ row.postdate }</td>
			
			<td>
			<c:if test="${ not empty row.ofile }">
				<a href="../mvcboard/down load.do?ofile=${ row.ofile }
					&sfile=${ row.sfile }&idex=${ row.idx }">[Down]</a>
			</c:if>
			</td>
		</tr>
		</c:forEach>
	</c:otherwise>
</c:choose>
        <tr>
            <td colspan="6" align="center">
                등록된 게시물이 없습니다^^*
            </td>
        </tr>
<!-- 출력할 게시물이 있을때 -->           
        <tr align="center">
            <td>100</td>
            <td align="left">
                제목
            </td> 
            <td>이름</td>
            <td>99</td>
            <td>작성일</td>
            <td>
                [Down]
            </td>
        </tr>
    </table>
   
    <table border="1" width="90%">
        <tr align="center">
            <td>
                페이지번호출력
            </td>
            <td width="100"><button type="button"
                onclick="location.href='../mvcboard/write.do';">글쓰기</button></td>
        </tr>
    </table>
</body>
</html>

