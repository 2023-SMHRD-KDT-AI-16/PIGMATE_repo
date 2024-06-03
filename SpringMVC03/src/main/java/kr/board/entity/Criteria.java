package kr.board.entity;

public class Criteria {
	
	private int page; //현재 페이지 번호
	
	private int perPageNum; // 한 페이지 당 보여줄 게시글 수
	
	// 특정 페이지의 게시글 시작번호
	public int getPageStart() {
		return (this.page - 1)*perPageNum;
	}
	
	// 기본 생성자 (처음 게시판 목록 들어 왔을 때)
	public Criteria() {
		this.page = 1;
		this.perPageNum = 10; // 한 페이지당 10개의 게시글 표시
	}

	public int getPage(){
		return page;
	}
	
	// 페이지가 음수값 되지 않도록 설정. 음수가 되면 1페이지로 이동
	public void setPage(int page) {
		if(page <= 0) {
			this.page = 1;
		}else {
			this.page = page;
		}
	}
	
	public int getPerPageNum(){
		return perPageNum;
	}
	
	// 페이지 당 보여줄 게시글 수 변화 없도록 세팅
	public void setPageNum(int pageCount) {
		int cnt = this.perPageNum;
		if(pageCount != cnt) {
			this.perPageNum = cnt;
		}else {
			this.perPageNum = pageCount;
		}
	}
}
