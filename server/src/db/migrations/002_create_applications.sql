-- Defines the fixed set of valid application statuses.
-- Inserting anything outside this list will fail at the database level.
CREATE TYPE application_status AS ENUM (
  'applied',
  'interview',
  'offer',
  'rejected',
  'withdrawn'
);

CREATE TABLE applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  company_name TEXT NOT NULL,
  role_title TEXT NOT NULL,
  status application_status NOT NULL DEFAULT 'applied',
  job_url TEXT,
  notes TEXT,
  applied_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Reusable trigger function: whenever a row is updated,
-- this stamps updated_at with the current time automatically.
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attaches that function to applications, firing before every UPDATE
CREATE TRIGGER trigger_set_updated_at
BEFORE UPDATE ON applications
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();