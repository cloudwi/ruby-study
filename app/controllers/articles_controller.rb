class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def publish
    article = Article.find(params[:id])
    if article.update(published_at: Time.current)
      redirect_to articles_path, notice: "게시글이 발행되었습니다."
    else
      redirect_to articles_path, alert: "발행에 실패했습니다. 다시 시도해 주세요."
    end
  end
end
