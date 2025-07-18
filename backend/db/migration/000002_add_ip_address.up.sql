ALTER TABLE "chat_sessions" 
ADD COLUMN "ip_address" varchar NULL;

-- Backfill existing rows with a placeholder value
UPDATE "chat_sessions" 
SET "ip_address" = '0.0.0.0' 
WHERE "ip_address" IS NULL;

-- Now that data is backfilled, set the NOT NULL constraint
ALTER TABLE "chat_sessions"
ALTER COLUMN "ip_address" SET NOT NULL; 