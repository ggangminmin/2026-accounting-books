# 2026 회계 관리 V2 - TODO 및 프로젝트 상태

## ✅ 완료된 작업

### 1. V2 핵심 기능 구현
- [x] 대시보드 카드 레이아웃 변경
  - [x] 남은 예산 카드 제거
  - [x] 회비 카드 추가 (0원 시작)
  - [x] 찬조금 카드 추가 (0원 시작)
  - [x] 일반 예산 고정 (3,200,000원)
  - [x] 회비/찬조금 독립 계정 관리
- [x] 숫자 포맷팅 시스템
  - [x] 모든 금액에 천 단위 콤마 적용
  - [x] 입력 필드 실시간 포맷팅
  - [x] 만 단위 → 전체 금액 표시로 변경
- [x] 지출 추가 기능 강화
  - [x] 출처(account) 필드 추가 (일반 예산/회비/찬조금)
  - [x] 영수증 업로드 1장 → 5장으로 확장
  - [x] 영수증 미리보기 그리드 레이아웃
  - [x] 개별 영수증 삭제 버튼
- [x] 계정별 지출 차감 로직
  - [x] 일반 예산 지출 시 일반 예산에서 차감
  - [x] 회비 지출 시 회비 잔액에서 차감
  - [x] 찬조금 지출 시 찬조금 잔액에서 차감
  - [x] 실시간 잔액 계산 (수입 - 지출)

### 2. 명단 관리 기능
- [x] 회비 납부 명단
  - [x] 납부자 추가/삭제/수정
  - [x] 회비 수입 자동 계산
  - [x] 컴팩트 카드 UI (한 줄 표시)
  - [x] 날짜/이름/금액/메모 통합 표시
  - [x] Supabase 저장
- [x] 찬조금 명단
  - [x] 기부자 추가/삭제/수정
  - [x] 찬조금 수입 자동 계산
  - [x] 컴팩트 카드 UI (한 줄 표시)
  - [x] 날짜/이름/금액/메모 통합 표시
  - [x] Supabase 저장

### 3. 기술적 개선
- [x] Supabase 데이터베이스 마이그레이션
  - [x] `account` 컬럼 추가 (TEXT)
  - [x] `receipts` 컬럼 추가 (TEXT[])
  - [x] `membership` 테이블 생성
  - [x] `donations_list` 테이블 생성
  - [x] `settings` 테이블 생성
  - [x] RLS 정책 설정
- [x] 데이터 로드 우선순위 변경
  - [x] Supabase 우선 로드
  - [x] localStorage 백업용으로 변경
- [x] 에러 처리 강화
  - [x] 상세한 Supabase 에러 로깅
  - [x] 사용자 친화적 에러 메시지
  - [x] 콘솔 디버깅 로그 추가

### 4. 문서화
- [x] migration.sql 작성
- [x] SETUP_GUIDE.md 작성
- [x] QUICK_FIX.md 작성
- [x] start-server.bat 스크립트
- [x] README.md 업데이트

## 🔄 진행 중인 작업

### 배포 준비
- [x] 모든 기능 테스트 완료
- [x] 대시보드 카드 레이아웃 최종 확인
- [x] 명단 UI 컴팩트 디자인 적용
- [ ] Vercel 배포
- [ ] 운영 환경 테스트

## 📋 예상 이슈 및 해결 방법

### 1. Supabase 400 에러
**증상**: 지출 저장 시 400 Bad Request
**원인**: 데이터베이스에 `account`, `receipts` 컬럼 없음
**해결책**:
```sql
-- migration.sql 실행
ALTER TABLE expenses
ADD COLUMN IF NOT EXISTS account TEXT DEFAULT '일반 예산',
ADD COLUMN IF NOT EXISTS receipts TEXT[] DEFAULT '{}';
```
**확인 방법**: Supabase → SQL Editor → migration.sql 전체 실행 → "Success. No rows returned" 확인

### 2. Service Worker 캐시 에러
**증상**: `Failed to execute 'put' on 'Cache'`
**원인**: POST 요청과 chrome-extension URL 캐싱 시도
**해결책**:
1. Chrome 개발자 도구 (F12) 열기
2. Application 탭 → Service Workers → Unregister
3. Storage → Clear site data
4. 강력 새로고침 (Ctrl + Shift + R)

### 3. 예산 복원 미작동
**증상**: 지출 수정 시 기존 출처 예산이 복원되지 않음
**원인**: Supabase 동기화 누락
**해결책**: index.html에서 이미 수정 완료
- `startEditExpense()`: 예산 복원 + Supabase 업데이트
- `cancelEditExpense()`: 예산 재차감 + Supabase 업데이트
- `handleEditSubmit()`: 새 출처에서 차감 + Supabase 업데이트

## 🎯 향후 개선 가능 항목

### 기능 추가 (선택사항)
- [ ] 월별 예산 목표 설정
- [ ] 카테고리별 지출 한도 설정
- [ ] 영수증 OCR 자동 금액 인식
- [ ] PDF/Excel 내보내기 기능
- [ ] 다크 모드 지원
- [ ] 지출 검색 및 필터링 강화

### 성능 최적화 (선택사항)
- [ ] 이미지 Lazy Loading
- [ ] React 컴포넌트 메모이제이션
- [ ] 가상 스크롤링 (지출 목록이 많을 때)
- [ ] Service Worker 캐시 전략 고도화

### UX/UI 개선 (선택사항)
- [ ] 애니메이션 효과 추가
- [ ] 스켈레톤 로딩 화면
- [ ] 토스트 알림 시스템
- [ ] 모바일 반응형 디자인 강화

## 🐛 알려진 제한사항

1. **영수증 파일 크기**: 개별 파일 5MB 제한 (Supabase Storage 기본값)
2. **Service Worker 캐시**: 첫 로드 시 네트워크 연결 필요
3. **브라우저 호환성**: Chrome/Edge/Safari 최신 버전 권장
4. **동시 편집**: 여러 탭에서 동시 수정 시 데이터 충돌 가능

## 📞 문제 발생 시 체크리스트

### 지출 추가/수정이 안 될 때
1. [ ] F12 → Console 탭에서 에러 확인
2. [ ] Network 탭에서 실패한 요청의 Response 확인
3. [ ] Supabase에서 migration.sql 실행 여부 확인
4. [ ] Service Worker Unregister 후 재시도
5. [ ] 강력 새로고침 (Ctrl + Shift + R)

### 영수증 업로드 실패 시
1. [ ] Supabase → Storage → receipts 버킷이 Public인지 확인
2. [ ] 파일 크기 5MB 이하인지 확인
3. [ ] 파일 형식이 이미지인지 확인 (JPG, PNG, GIF 등)
4. [ ] 브라우저 콘솔에서 구체적 에러 메시지 확인

### 카드 잔액이 이상할 때
1. [ ] Supabase → settings 테이블 값 확인
2. [ ] 콘솔에서 "✅ 설정 업데이트 완료" 로그 확인
3. [ ] 명단 탭에서 납부/기부 내역 확인
4. [ ] 필요시 settings 테이블 값 수동 조정

## 🎉 성공 확인 방법

모든 기능이 정상 작동하면 다음과 같이 확인할 수 있습니다:

### 대시보드
- ✅ 총 예산, 총 지출 카드 표시
- ✅ 일반 예산 (320만원), 회비 (0원), 찬조금 (0원) 카드 표시
- ✅ 모든 금액에 천 단위 콤마 적용
- ✅ 월별 지출 현황 표시

### 지출 추가/수정
- ✅ 출처 선택 가능 (일반 예산/회비/찬조금)
- ✅ 영수증 최대 5장 첨부 가능
- ✅ 영수증 썸네일 그리드 표시
- ✅ 저장 시 콘솔에 "✅ 지출 저장 완료" 표시
- ✅ 출처별 자동 차감 (일반예산/회비/찬조금)

### 명단 관리
- ✅ 회비 납부자 추가/수정/삭제
- ✅ 찬조금 기부자 추가/수정/삭제
- ✅ 컴팩트 카드 UI (한 줄 표시)
- ✅ 대시보드 카드 실시간 업데이트

### 콘솔 로그 (정상 작동 시)
```
✅ Supabase 데이터 로드 완료
📤 지출 데이터 전송 시도: {...}
✅ 지출 저장 완료: 1736...
🔄 수정 시작 - 예산 복원: {...}
✅ 회비 복원: 450000 → 500000
💾 수정 저장 - 새 출처에서 차감: {...}
✅ 찬조금에서 차감: 11133 → 1133
```

## 📚 참고 파일

- **index.html**: 메인 애플리케이션 (2000+ 줄)
- **service-worker.js**: PWA 캐싱 로직
- **manifest.json**: PWA 설정
- **migration.sql**: 데이터베이스 스키마 마이그레이션
- **SETUP_GUIDE.md**: 상세 설치 가이드
- **QUICK_FIX.md**: 긴급 문제 해결 가이드
- **start-server.bat**: 로컬 서버 시작 스크립트

---

**마지막 업데이트**: 2026-01-18
**버전**: V2.2.0
**상태**: 안정 (Stable)
**최신 변경사항**:
- 남은 예산 카드 제거
- 회비/찬조금 독립 계정 관리
- 명단 컴팩트 UI 적용
- 출처별 지출 차감 로직 개선
