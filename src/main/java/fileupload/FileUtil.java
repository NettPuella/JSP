package fileupload;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

//파일 업로드와 관련된 기능을 메서드로 정의한 유틸리티 클래스
public class FileUtil {

	//파일 업도르 처리(매개변수1:request내장객체, 매개변수2:디렉토리)
	public static String uploadFile(HttpServletRequest req,
			String sDirectory)
			throws ServletException, IOException{
		
		/* 파일 첨부를 위한 <input>태그의 name속성값을 이용해서 Part객체를
		생성한다. 해당 객체를 통해 파일을 서버에 저장할 수 있다. */
		Part part = req.getPart("ofile");
		
		/* Part 객체에서 하래 헤더값을 읽어오면 전송된 파일의 원본명을
		알 수 있다. (콘솔에서 확인할것) */
		String partHeader = part.getHeader("content-disposition");
		System.out.println("partHeader=" + partHeader);
		
		/* "filename" 를 구분자로 헤더값을 split()하면 String타입의 배열로
		반환된다. */
		String[] phArr = partHeader.split("filename=");
		/* 앞에서 split()한 결과 중 인덱스 1은 파일명이 된다. 여기서 더블쿼테이션을
		제거하면 순수한 파일명만 남는다. replace()를 통해 제거한다. 이때
		더블쿼테이션을 제거할 문자열로 사용하기 위해 이스케이프시퀀스를
		붙여줘야한다. */
		String originalFileName = phArr[1].trim().replace("\"", "");
		
		/* 전송된 파일이 있는 경우라면 디렉토리에 파일을 저장한다. 이때
		write()메서드를 사용한다. 
		File.separator : 운영체제(OS)마다 경로를 표시하는 기호가 다르므로
						해당 OS에 맞는것을 자동으로 기술해준다. */
		if(!originalFileName.isEmpty()) {
			part.write(sDirectory + File.separator + originalFileName);
		}
		//원본 파일명을 반환한다.
		return originalFileName;
	}
	//서버에 저장된 파일명을 변경한다(단순한 문자열처리)
	public static String renameFile(String sDirectory, String fileName) {
		/* 파일명에서 확장자를 잘라내기 위해 뒤에서 부터 .이 있는 위치를
		찾는다. 파일명에는 2개 이상의 .을 사용할 수 있기 때문이다. */
		String ext = fileName.substring(fileName.lastIndexOf("."));
		/* 날짜와 시간을 이용해서 파일명으로 사용할 문자열을 생성한다.
		"년월일_시분초123"과 같은 형태가 된다. */
		String now = new SimpleDateFormat("yyyyMMdd_HmsS")
				.format(new Date());
		//파일명과 확장자를 결합한다.
		String newFileName = now + ext;
		
		//원본파일명과 새로운 파일명을 통해 File객체를 생성한다.
		File olFile = new File(sDirectory + File.separator + fileName);
		File newFile = new File(sDirectory + File.separator + newFileName);
		//파일명을 변경한다.
		olFile.renameTo(newFile);
		
		//변경된 파일명을 반환한다.
		return newFileName;
	}
	
	//첨부파일 삭제
	public static void deleteFile(HttpServletRequest req, 
			String directory, String filename) {
		//파일이 저장된 디렉토리의 물리적 경로를 가져온다.
		String sDirectory = req.getServletContext().getRealPath(directory);
		//저장된 파일의 경로를 통해 File 객체를 성성
		File file = new File(sDirectory + File.separator +filename);
		//해당 경로에 파일이 있으면 삭제한다.
		if(file.exists()) {
			file.delete();
		}
	}
		
}
















