class ArticlesController < ApplicationController
  include Secured

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    @user = session[:userinfo]

    # OpenAI로 글 요약 생성
    begin
      content = "#{@article.body}\n위 글을 요약해주세요."
      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: content }],
          temperature: 0.7
        }
      )

      @openai_response = response.dig("choices", 0, "message", "content")
    rescue StandardError => e
      Rails.logger.error "OpenAI API Error: #{e.message}"
      @openai_response = nil
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  private
  def article_params
    params.require(:article).permit(:title, :body, :status)
  end
end
