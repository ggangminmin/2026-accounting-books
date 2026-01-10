# 🚀 2026 회계 관리 V2 설치 가이드

## ⚠️ 중요: 400 에러 해결 방법

현재 지출 저장 시 **400 Bad Request** 에러가 발생하는 이유는 **Supabase 데이터베이스에 새로운 컬럼이 없기 때문**입니다.

V2 버전에서는 다음 필드들이 추가되었습니다:
- `account` (TEXT): 출처 (일반 예산/회비/찬조금)
- `receipts` (TEXT[]): 영수증 파일명 배열 (최대 5개)

## 📋 단계별 해결 방법

### 1단계: Supabase 접속
1. [https://supabase.com](https://supabase.com) 접속
2. 프로젝트 선택
3. 좌측 메뉴에서 **SQL Editor** 클릭

### 2단계: 마이그레이션 SQL 실행

프로젝트 폴더에 있는 `migration.sql` 파일을 열어서 **전체 내용을 복사**한 후, Supabase SQL Editor에 붙여넣고 **RUN** 버튼을 클릭하세요.

또는 아래 SQL을 직접 복사해서 실행하세요:

```sql
-- 2026 회계 관리 V2 마이그레이션 스크립트

-- 1. 기존 테이블에 새 컬럼 추가
ALTER TABLE expenses
ADD COLUMN IF NOT EXISTS account TEXT DEFAULT '일반 예산',
ADD COLUMN IF NOT EXISTS receipts TEXT[] DEFAULT '{}';

-- 2. 설정 테이블 확인 (없으면 생성)
CREATE TABLE IF NOT EXISTS settings (
  id SERIAL PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,
  value INTEGER NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 초기 데이터 삽입
INSERT INTO settings (key, value) VALUES
  ('donations', 11133),
  ('membership_fee', 496000)
ON CONFLICT (key) DO NOTHING;

-- 4. RLS 활성화
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- 5. 정책 설정
DROP POLICY IF EXISTS "Enable all access for all users" ON expenses;
DROP POLICY IF EXISTS "Enable all access for all users" ON settings;

CREATE POLICY "Enable all access for all users" ON expenses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all access for all users" ON settings FOR ALL USING (true) WITH CHECK (true);
```

### 3단계: Storage 버킷 확인

1. 좌측 메뉴에서 **Storage** 클릭
2. `receipts` 버킷이 있는지 확인
3. 없으면 **New bucket** 클릭
   - Name: `receipts`
   - Public bucket: **✅ ON** (중요!)
4. 저장

### 4단계: 브라우저 캐시 삭제

서비스 워커 캐시 문제를 해결하기 위해:

1. Chrome 개발자 도구 열기 (F12)
2. **Application** 탭 클릭
3. 좌측 **Storage** → **Clear site data** 클릭
4. 또는 **Service Workers** → **Unregister** 클릭

### 5단계: 페이지 새로고침

1. 브라우저에서 **Ctrl + Shift + R** (강력 새로고침)
2. 또는 캐시 삭제 후 일반 새로고침 (F5)

---

## ✅ 동작 확인

다음 기능들이 정상 작동하는지 확인하세요:

### 1. 지출 추가
- [ ] "추가" 버튼 클릭
- [ ] 출처 선택 (일반 예산/회비/찬조금)
- [ ] 영수증 최대 5장 첨부
- [ ] 저장 시 콘솔에 "✅ 지출 저장 완료" 출력
- [ ] 대시보드에 즉시 반영

### 2. 지출 수정
- [ ] 연필 아이콘 클릭
- [ ] 콘솔에 예산 복원 로그 확인
- [ ] 출처 변경 가능
- [ ] 저장 시 새 출처에서 차감

### 3. 회비/찬조금 명단
- [ ] "명단" 탭 클릭
- [ ] 회비 납부 추가
- [ ] 찬조금 추가
- [ ] 대시보드 잔액에 실시간 반영

---

## 🐛 여전히 에러가 발생하나요?

### 콘솔 확인
F12를 눌러 Console 탭을 확인하세요. 이제 더 자세한 에러 메시지가 표시됩니다:

```
📤 지출 데이터 전송 시도: { id: 123..., account: "회비", ... }
❌ Supabase 에러 상세: { message: "...", code: "..." }
```

### 일반적인 문제들

1. **"column does not exist" 에러**
   - → migration.sql을 다시 실행하세요

2. **"permission denied" 에러**
   - → RLS 정책이 제대로 설정되었는지 확인

3. **영수증 업로드 실패**
   - → Storage 버킷이 Public인지 확인

4. **Service Worker 에러**
   - → Application 탭에서 Service Worker 등록 해제
   - → 캐시 전체 삭제

---

## 📞 추가 도움이 필요하신가요?

1. F12 → Console 탭의 **전체 에러 로그** 복사
2. Network 탭에서 실패한 요청의 **Response** 확인
3. 위 정보와 함께 문의해주세요!

---

## 🎉 설치 완료!

모든 단계를 완료하셨다면 이제 V2의 새로운 기능들을 사용하실 수 있습니다:

- ✅ 출처별 예산 관리 (일반/회비/찬조금)
- ✅ 영수증 다중 첨부 (최대 5장)
- ✅ 지출 수정 시 자동 예산 복원
- ✅ 회비/찬조금 명단 관리
- ✅ 천 단위 콤마 포맷팅

즐거운 회계 관리 되세요! 💰
