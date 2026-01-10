# 🆘 긴급 수정 가이드

## 현재 발생한 에러들

### ❌ 1. Supabase 400 에러
```
Failed to load resource: the server responded with a status of 400
```
**원인:** 데이터베이스에 `account`와 `receipts` 컬럼이 없음

### ❌ 2. Service Worker 에러
```
Uncaught (in promise) TypeError: Failed to execute 'put' on 'Cache'
Request scheme 'chrome-extension' is unsupported
```
**원인:** Service Worker가 POST 요청과 chrome-extension을 캐싱하려고 시도

---

## ⚡ 즉시 해결 방법

### 1️⃣ Supabase SQL 실행 (필수!)

1. https://supabase.com/dashboard 접속
2. 프로젝트 선택
3. 좌측 메뉴 **SQL Editor** 클릭
4. 다음 SQL 복사 → 붙여넣기 → **RUN** 클릭:

```sql
-- V2 필수 컬럼 추가
ALTER TABLE expenses
ADD COLUMN IF NOT EXISTS account TEXT DEFAULT '일반 예산',
ADD COLUMN IF NOT EXISTS receipts TEXT[] DEFAULT '{}';

-- 구버전 컬럼 제거 (선택사항)
ALTER TABLE expenses
DROP COLUMN IF EXISTS receipt_id;

-- settings 테이블 확인
CREATE TABLE IF NOT EXISTS settings (
  id SERIAL PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,
  value INTEGER NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 초기값 설정
INSERT INTO settings (key, value) VALUES
  ('donations', 11133),
  ('membership_fee', 496000)
ON CONFLICT (key) DO NOTHING;
```

5. ✅ "Success. No rows returned" 메시지 확인

### 2️⃣ Chrome 캐시 완전 삭제

**방법 1: 개발자 도구에서**
1. `F12` 눌러서 개발자 도구 열기
2. `Application` 탭 클릭
3. 좌측 **Service Workers** 클릭
4. 모든 Service Worker 옆에 **Unregister** 클릭
5. 좌측 **Storage** 클릭
6. **Clear site data** 버튼 클릭

**방법 2: 브라우저 설정에서**
1. Chrome 설정 열기
2. "개인정보 및 보안" → "인터넷 사용 기록 삭제"
3. "캐시된 이미지 및 파일" 체크
4. "데이터 삭제" 클릭

### 3️⃣ 강력 새로고침

```
Ctrl + Shift + R (Windows)
```
또는
```
Cmd + Shift + R (Mac)
```

### 4️⃣ 테스트

1. 개발자 도구 Console 탭 확인
2. "지출 추가" 클릭
3. 콘솔에서 다음 메시지 확인:

```
✅ 기대되는 로그:
📤 지출 데이터 전송 시도: { id: ..., account: "일반 예산", ... }
✅ 지출 저장 완료: 1736...
```

```
❌ 여전히 에러가 나면:
❌ Supabase 에러 상세: { message: "...", code: "...", hint: "..." }
```

---

## 🔍 에러별 해결책

### "column account does not exist"
→ Supabase SQL을 다시 실행하세요 (1️⃣ 단계)

### "Failed to execute 'put' on 'Cache'"
→ Service Worker를 Unregister 하세요 (2️⃣ 단계)

### "400 Bad Request"
→ 1️⃣ + 2️⃣ + 3️⃣ 모두 실행

### "permission denied"
→ Supabase에서 RLS 정책 확인:
```sql
DROP POLICY IF EXISTS "Enable all access for all users" ON expenses;
CREATE POLICY "Enable all access for all users" ON expenses
FOR ALL USING (true) WITH CHECK (true);
```

---

## 📸 스크린샷으로 확인

### Supabase SQL 성공 화면
```
Success. No rows returned
```

### Chrome Service Worker 제거 확인
```
Application → Service Workers → (비어있음)
```

### 정상 작동 콘솔
```
✅ Supabase 데이터 로드 완료
📤 지출 데이터 전송 시도: ...
✅ 지출 저장 완료: ...
```

---

## 💡 여전히 안 되나요?

다음 정보를 캡처해서 공유해주세요:

1. **Supabase SQL 실행 결과** (Success 또는 Error 메시지)
2. **Console 탭의 전체 에러 로그**
3. **Network 탭** → 실패한 요청 클릭 → Response 탭

---

## ✅ 성공 체크리스트

- [ ] Supabase SQL 실행 완료
- [ ] Service Worker Unregister 완료
- [ ] 캐시 삭제 완료
- [ ] 강력 새로고침 완료
- [ ] 콘솔에 "✅ 지출 저장 완료" 출력
- [ ] 지출이 대시보드에 표시됨
- [ ] 회비/찬조금 카드가 보임
- [ ] 명단 탭이 정상 작동

모두 체크되면 성공! 🎉
