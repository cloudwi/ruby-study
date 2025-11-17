# Railway 배포 가이드

## 필수 환경변수 설정

Railway 대시보드에서 다음 환경변수들을 설정하세요:

### 1. Rails 환경변수

```bash
# 필수: SECRET_KEY_BASE
SECRET_KEY_BASE=d04f1fd38826781e8b58b1818ca4b3d563937e63d2446d20f2eb163a07d16a34f97db299fe718597fc33835dcf428bb730ee5909a9ac563d5b798ca1b1fa28dd

# 선택: RAILS_MASTER_KEY (config/master.key 파일 내용)
# credentials 파일을 사용하는 경우에만 필요
RAILS_MASTER_KEY=<config/master.key 파일 내용>
```

### 2. Auth0 환경변수 (필수)

```bash
AUTH0_DOMAIN=<Auth0 도메인 (예: dev-xxxxx.us.auth0.com)>
AUTH0_CLIENT_ID=<Auth0 Client ID>
AUTH0_CLIENT_SECRET=<Auth0 Client Secret>
```

### 3. OpenAI 환경변수 (선택 - AI 요약 기능 사용 시)

```bash
OPENAI_API_KEY=sk-your-openai-api-key
```

### 4. Sentry 환경변수 (선택)

```bash
SENTRY_DSN=https://f573ec547d71c09defb67758c7931bec@o4510362292781056.ingest.us.sentry.io/4510377298493440
```

### 5. Database 환경변수

Railway PostgreSQL을 추가하면 자동으로 설정됩니다:
```bash
DATABASE_URL=<자동 생성됨>
```

## Auth0 설정

Auth0 대시보드 (https://manage.auth0.com)에서 다음 설정을 추가하세요:

### Application Settings

1. **Allowed Callback URLs:**
   ```
   https://ruby-study-production.up.railway.app/auth/auth0/callback
   ```

2. **Allowed Logout URLs:**
   ```
   https://ruby-study-production.up.railway.app
   ```

3. **Allowed Web Origins:**
   ```
   https://ruby-study-production.up.railway.app
   ```

## 배포 단계

1. Railway에서 New Project 생성
2. GitHub 저장소 연결
3. 위의 환경변수들 추가
4. PostgreSQL 서비스 추가 (선택)
5. Deploy 버튼 클릭

## 문제 해결

### "Missing secret_key_base" 오류
- Railway 환경변수에 `SECRET_KEY_BASE` 추가

### Auth0 로그인 실패
- Auth0 대시보드에서 Callback URLs 확인
- Railway 환경변수에서 AUTH0_* 변수들 확인

### Database 연결 오류
- Railway에서 PostgreSQL 서비스 추가
- DATABASE_URL이 자동으로 설정되었는지 확인

## 로컬 테스트

배포 전에 production 환경을 로컬에서 테스트:

```bash
SECRET_KEY_BASE=d04f1fd38826781e8b58b1818ca4b3d563937e63d2446d20f2eb163a07d16a34f97db299fe718597fc33835dcf428bb730ee5909a9ac563d5b798ca1b1fa28dd \
AUTH0_DOMAIN=<your-domain> \
AUTH0_CLIENT_ID=<your-client-id> \
AUTH0_CLIENT_SECRET=<your-client-secret> \
RAILS_ENV=production \
bin/rails assets:precompile

SECRET_KEY_BASE=d04f1fd38826781e8b58b1818ca4b3d563937e63d2446d20f2eb163a07d16a34f97db299fe718597fc33835dcf428bb730ee5909a9ac563d5b798ca1b1fa28dd \
RAILS_ENV=production \
bin/rails server
```
