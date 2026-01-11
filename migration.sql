-- 2026 회계 관리 V2 마이그레이션 스크립트
-- Supabase SQL Editor에서 실행하세요

-- 1. 기존 테이블에 새 컬럼 추가 (기존 테이블이 있는 경우)
ALTER TABLE expenses
ADD COLUMN IF NOT EXISTS account TEXT DEFAULT '일반 예산',
ADD COLUMN IF NOT EXISTS receipts TEXT[] DEFAULT '{}';

-- 2. 또는 테이블을 새로 생성 (처음 설정하는 경우)
-- CREATE TABLE IF NOT EXISTS expenses (
--   id BIGINT PRIMARY KEY,
--   date DATE NOT NULL,
--   amount INTEGER NOT NULL,
--   category TEXT NOT NULL,
--   memo TEXT,
--   account TEXT DEFAULT '일반 예산',
--   receipts TEXT[] DEFAULT '{}',
--   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
--   updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
-- );

-- 3. 설정 테이블 (기존에 없으면 생성)
CREATE TABLE IF NOT EXISTS settings (
  id SERIAL PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,
  value INTEGER NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 회비 납부 명단 테이블
CREATE TABLE IF NOT EXISTS membership (
  id BIGINT PRIMARY KEY,
  date DATE NOT NULL,
  name TEXT NOT NULL,
  amount INTEGER NOT NULL,
  memo TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. 찬조금 명단 테이블
CREATE TABLE IF NOT EXISTS donations_list (
  id BIGINT PRIMARY KEY,
  date DATE NOT NULL,
  name TEXT NOT NULL,
  amount INTEGER NOT NULL,
  memo TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. 초기 데이터 삽입 (중복 무시)
INSERT INTO settings (key, value) VALUES
  ('general_budget', 3200000),
  ('donations', 11133),
  ('membership_fee', 496000)
ON CONFLICT (key) DO NOTHING;

-- 7. RLS 활성화
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE membership ENABLE ROW LEVEL SECURITY;
ALTER TABLE donations_list ENABLE ROW LEVEL SECURITY;

-- 8. 정책 설정 (기존 정책이 있으면 삭제 후 재생성)
DROP POLICY IF EXISTS "Enable all access for all users" ON expenses;
DROP POLICY IF EXISTS "Enable all access for all users" ON settings;
DROP POLICY IF EXISTS "Enable all access for all users" ON membership;
DROP POLICY IF EXISTS "Enable all access for all users" ON donations_list;

CREATE POLICY "Enable all access for all users" ON expenses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all access for all users" ON settings FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all access for all users" ON membership FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all access for all users" ON donations_list FOR ALL USING (true) WITH CHECK (true);

-- 완료!
-- 이제 앱에서 account와 receipts 필드를 사용할 수 있습니다.
