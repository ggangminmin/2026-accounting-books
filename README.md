# 2026 회계 관리 v2 💰

> 찬양팀 회계를 위한 React 기반 PWA (Progressive Web App)

[![Vercel](https://img.shields.io/badge/Deployed%20on-Vercel-black?style=flat&logo=vercel)](https://vercel.com)
[![Supabase](https://img.shields.io/badge/Database-Supabase-3ECF8E?style=flat&logo=supabase)](https://supabase.com)
[![React](https://img.shields.io/badge/React-18-61DAFB?style=flat&logo=react)](https://react.dev)

PC와 모바일에서 실시간으로 동기화되는 회계 관리 웹앱입니다.

## ✨ 주요 기능

### 📊 지출 관리
- ➕ **지출 추가** - 날짜, 금액, 카테고리, 메모, 출처 선택
- ✏️ **지출 수정** - 기존 지출 내역 수정 (예산 자동 복원/차감)
- 🗑️ **지출 삭제** - 불필요한 항목 삭제
- 📸 **영수증 첨부** - 최대 5장 업로드 (1200px, 80% 품질)
- 💳 **출처 추적** - 일반 예산, 회비, 찬조금 중 선택

### 💰 예산 관리 (V2)
- **일반 예산** - 운영 예산 관리 (초기: 3,200,000원)
- **회비** - 회원 납부 관리 (초기: 496,000원)
  - ✏️ **수정/삭제** - 회비 내역 수정 및 삭제 가능
  - 💰 **자동 잔액 계산** - 수정/삭제 시 잔액 자동 업데이트
- **찬조금** - 기부금 관리 (초기: 11,133원)
  - ✏️ **수정/삭제** - 찬조금 내역 수정 및 삭제 가능
  - 💰 **자동 잔액 계산** - 수정/삭제 시 잔액 자동 업데이트
- **독립적 잔액** - 각 항목별 개별 추적
- **실시간 동기화** - Supabase 자동 저장

### 📈 통계 및 분석
- 월별 지출 현황
- 카테고리별 지출 분석
- 총 예산/총 지출/남은 예산 실시간 표시
- 항목별 잔액 카드 (초기값 표시)

### 🔄 데이터 동기화
- ☁️ Supabase 클라우드 저장
- 📱 PC/모바일 자동 동기화
- 💾 JSON 백업/복원 기능

## 🛠 기술 스택

### Frontend
- **React 18** - UI 라이브러리
- **Babel Standalone** - JSX 변환
- **Vanilla CSS** - 스타일링

### Backend
- **Supabase PostgreSQL** - 데이터베이스
- **Supabase Storage** - 영수증 이미지 저장

### Deployment
- **Vercel** - 호스팅 및 자동 배포
- **PWA** - Service Worker, Manifest

## 🚀 빠른 시작

### 1. 저장소 클론

```bash
git clone https://github.com/ggangminmin/2026-accounting-books.git
cd 2026-accounting-books
```

### 2. 로컬 서버 실행

```bash
python -m http.server 8000
```

브라우저에서 `http://localhost:8000` 접속

### 3. Supabase 설정 (필수)

**⚠️ V2.1.0 중요**: 회비/찬조금 명단이 Supabase에 저장됩니다. `migration.sql` 실행 필수!

1. [Supabase](https://supabase.com)에서 프로젝트 생성
2. SQL Editor에서 **`migration.sql` 파일 전체 내용 복사하여 실행**:

```sql
-- 지출 내역 테이블
CREATE TABLE expenses (
  id BIGINT PRIMARY KEY,
  date DATE NOT NULL,
  amount INTEGER NOT NULL,
  category TEXT NOT NULL,
  memo TEXT,
  receipt_id BIGINT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 설정 테이블
CREATE TABLE settings (
  id SERIAL PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,
  value INTEGER NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 초기 데이터
INSERT INTO settings (key, value) VALUES
  ('donations', 0),
  ('membership_fee', 0);

-- RLS 활성화
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- 정책 설정
CREATE POLICY "Enable all access for all users" ON expenses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all access for all users" ON settings FOR ALL USING (true) WITH CHECK (true);
```

3. Storage 버킷 생성:
   - 버킷 이름: `receipts`
   - Public: ✅ ON

4. `index.html`에서 Supabase URL과 Key 업데이트:

```javascript
const SUPABASE_URL = 'your-project-url';
const SUPABASE_ANON_KEY = 'your-anon-key';
```

## 📱 PWA 설치

### iOS (Safari)
1. 사이트 접속
2. 공유 버튼 → "홈 화면에 추가"
3. 홈 화면 아이콘 클릭 → 앱 실행

### Android (Chrome)
1. 사이트 접속
2. 메뉴 (⋮) → "홈 화면에 추가"
3. 설치 완료

## 🎨 주요 화면

### 대시보드
- 총 예산/총 지출/남은 예산 카드
- 항목별 잔액 카드 (일반 예산, 회비, 찬조금)
- 초기 금액 표시 기능
- 월별 지출 현황 요약

### 월별 보기
- 월별 지출 내역
- 카테고리별 통계
- 영수증 보기/수정/삭제

## 🔧 주요 기능 설명

### 금액 쉼표 포맷팅
입력 시 자동으로 쉼표가 추가됩니다.
```
입력: 50000 → 표시: 50,000
입력: 3200000 → 표시: 3,200,000
```

### 영수증 고화질 저장
- 최대 크기: 1200px
- JPEG 품질: 80%
- Supabase Storage에 저장

### 실시간 동기화
- PC에서 입력 → 모바일에서 즉시 확인
- 모바일에서 수정 → PC에서 실시간 반영

## 📂 프로젝트 구조

```
2026-accounting-books/
├── index.html          # 메인 애플리케이션
├── manifest.json       # PWA 매니페스트
├── service-worker.js   # Service Worker
├── icon-192.png        # 앱 아이콘 (192x192)
├── icon-512.png        # 앱 아이콘 (512x512)
├── icon.svg            # 벡터 아이콘
└── README.md           # 문서
```

## 🐛 트러블슈팅

### 데이터가 동기화되지 않아요
1. Supabase 설정 확인
2. 브라우저 콘솔에서 에러 확인
3. RLS 정책 확인

### 영수증 이미지가 업로드되지 않아요
1. Storage 버킷이 Public인지 확인
2. Storage 정책 확인
3. 네트워크 탭에서 에러 확인

### 로컬에서 CORS 에러가 발생해요
로컬 환경에서는 일부 기능이 제한될 수 있습니다. Vercel에 배포하면 정상 작동합니다.

## 🚀 배포

### Vercel 배포

1. [Vercel](https://vercel.com) 계정 생성
2. GitHub 저장소 연동
3. 프로젝트 import
4. 자동 배포 완료!

## 📝 라이선스

MIT License

## 👨‍💻 개발자

**ggangminmin**
- GitHub: [@ggangminmin](https://github.com/ggangminmin)

## 🤝 기여

이슈와 PR은 언제나 환영합니다!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 문의

프로젝트에 대한 질문이나 제안사항이 있으시면 [Issues](https://github.com/ggangminmin/2026-accounting-books/issues)에 남겨주세요!

---

⭐ 이 프로젝트가 도움이 되었다면 Star를 눌러주세요!
