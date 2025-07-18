-- Drop check constraints first
ALTER TABLE "chat_messages" DROP CONSTRAINT IF EXISTS "check_message_role";

-- Drop foreign key constraints with correct cascade/set null behavior
ALTER TABLE "chat_messages" DROP CONSTRAINT IF EXISTS "chat_messages_session_id_fkey";
ALTER TABLE "auth_sessions" DROP CONSTRAINT IF EXISTS "auth_sessions_user_id_fkey";

-- Drop indexes
DROP INDEX IF EXISTS "users_email_idx";
DROP INDEX IF EXISTS "auth_sessions_user_id_idx";
DROP INDEX IF EXISTS "chat_sessions_user_id_idx";
DROP INDEX IF EXISTS "chat_sessions_last_message_at_idx";
DROP INDEX IF EXISTS "chat_messages_session_id_idx";

-- Drop tables in reverse order of dependencies
DROP TABLE IF EXISTS "chat_messages";
DROP TABLE IF EXISTS "chat_sessions";
DROP TABLE IF EXISTS "email_verifications";
DROP TABLE IF EXISTS "auth_sessions";
DROP TABLE IF EXISTS "users";
