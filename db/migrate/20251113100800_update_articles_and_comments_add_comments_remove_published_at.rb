class UpdateArticlesAndCommentsAddCommentsRemovePublishedAt < ActiveRecord::Migration[8.1]
  def change
    # 1) articles.published_at 컬럼 제거
    if column_exists?(:articles, :published_at)
      remove_column :articles, :published_at, :datetime
    end

    # 2) 컬럼 주석 추가 (articles)
    change_column_comment :articles, :title, "게시글 제목"
    change_column_comment :articles, :body, "게시글 본문"
    change_column_comment :articles, :status, "공개 상태 값 (public, private, archived)"
    change_column_comment :articles, :created_at, "레코드 생성 시각"
    change_column_comment :articles, :updated_at, "레코드 수정 시각"

    # 선택: 테이블 주석
    if respond_to?(:change_table_comment)
      change_table_comment :articles, "게시글을 저장하는 테이블"
    end

    # 3) 컬럼 주석 추가 (comments)
    change_column_comment :comments, :article_id, "연관된 Article의 ID"
    change_column_comment :comments, :commenter, "댓글 작성자 이름"
    change_column_comment :comments, :body, "댓글 내용"
    change_column_comment :comments, :status, "공개 상태 값 (public, private, archived)"
    change_column_comment :comments, :created_at, "레코드 생성 시각"
    change_column_comment :comments, :updated_at, "레코드 수정 시각"

    # 선택: 테이블 주석
    if respond_to?(:change_table_comment)
      change_table_comment :comments, "게시글에 달린 댓글을 저장하는 테이블"
    end
  end
end
