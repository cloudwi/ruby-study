# Rails Blog with Auth0 & OpenAI

Rails 8 블로그 애플리케이션 with Auth0 인증 및 OpenAI 요약 기능

## 기능

- ✅ Article CRUD (생성, 읽기, 수정, 삭제)
- ✅ Comment 시스템
- ✅ Auth0 소셜 로그인
- ✅ OpenAI를 통한 AI 요약 (선택적)
- ✅ Tailwind CSS 스타일링
- ✅ Sentry 에러 모니터링

## 환경 설정

### 1. 환경변수 설정

`.env` 파일을 생성하고 다음 내용을 추가하세요:

```bash
# Auth0 (필수)
AUTH0_DOMAIN=your-domain.us.auth0.com
AUTH0_CLIENT_ID=your_client_id
AUTH0_CLIENT_SECRET=your_client_secret

# OpenAI (선택)
ENABLE_OPENAI=false  # true로 설정하면 AI 요약 기능 활성화
OPENAI_API_KEY=sk-your-openai-api-key

# Sentry (선택)
SENTRY_DSN=your-sentry-dsn
```

### 2. OpenAI 기능 사용 시 주의사항

⚠️ **OpenAI API는 유료 서비스입니다**

- 무료 크레딧이 소진되면 `insufficient_quota` 에러 발생
- 기본적으로 비활성화되어 있음 (`ENABLE_OPENAI=false`)
- 활성화하려면:
  1. OpenAI 계정에서 결제 정보 설정
  2. API 키 발급
  3. `.env`에서 `ENABLE_OPENAI=true` 설정

**비용 절감 팁:**
- 현재 `gpt-4o-mini` 모델 사용 (가장 저렴)
- 필요할 때만 `ENABLE_OPENAI=true`로 설정
- Railway 배포 시에는 기본적으로 비활성화 권장

### 3. 설치 및 실행

```bash
# 의존성 설치
bundle install

# 데이터베이스 설정
bin/rails db:create db:migrate

# 개발 서버 실행
bin/rails server
```

## Railway 배포

자세한 배포 가이드는 [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md) 참조

**중요:** Railway 배포 시 OpenAI 기능을 비활성화하려면 `ENABLE_OPENAI` 환경변수를 설정하지 않거나 `false`로 설정하세요.

## 기술 스택

- Rails 8.1.1
- Ruby 3.4.7
- SQLite (개발), PostgreSQL (프로덕션)
- Tailwind CSS 4.4
- Auth0 (OmniAuth)
- OpenAI API (선택적)
- Sentry (에러 모니터링)

## 라이센스

MIT
