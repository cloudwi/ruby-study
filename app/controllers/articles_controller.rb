class ArticlesController < ApplicationController
  include Secured

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    @user = session[:userinfo]

    # OpenAI로 글 요약 생성 (ENABLE_OPENAI 환경변수로 제어)
    if ENV["ENABLE_OPENAI"] == "true" && ENV["OPENAI_API_KEY"].present?
      begin
        content = "#{@article.body}\n\n위 글을 3-4문장으로 간단히 요약해주세요."
        client = OpenAI::Client.new
        response = client.chat(
          parameters: {
            model: "gpt-4o-mini", # 더 저렴한 모델 사용
            messages: [{ role: "user", content: content }],
            temperature: 0.7
          }
        )

        @openai_response = response&.dig("choices", 0, "message", "content")
      rescue StandardError => e
        Rails.logger.error "OpenAI API Error: #{e.message}"
        @openai_response = nil
      end
    else
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
