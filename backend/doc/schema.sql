CREATE TABLE "users" (
  "id" uuid PRIMARY KEY,
  "email" varchar NOT NULL UNIQUE,
  "password" varchar NOT NULL,
  "username" varchar NOT NULL UNIQUE,
  "is_email_verified" bool NOT NULL DEFAULT false,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "deleted_at" timestamptz
);

CREATE TABLE "auth_sessions" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "refresh_token" varchar UNIQUE NOT NULL,
  "user_agent" varchar NOT NULL,
  "client_ip" varchar NOT NULL,
  "is_blocked" bool NOT NULL DEFAULT false,
  "expires_at" timestamptz NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "email_verifications" (
  "id" bigserial PRIMARY KEY,
  "email" varchar NOT NULL,
  "secret_code" varchar NOT NULL,
  "is_used" bool NOT NULL DEFAULT false,
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "expired_at" timestamptz NOT NULL DEFAULT (now() + interval '15 minutes'),
  UNIQUE ("email", "secret_code")
);

CREATE TABLE "chat_sessions" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid NOT NULL,
  "title" varchar(255),
  "created_at" timestamptz NOT NULL DEFAULT (now()),
  "updated_at" timestamptz NOT NULL DEFAULT (now()),
  "last_message_at" timestamptz NOT NULL DEFAULT (now()),
  "is_archived" boolean NOT NULL DEFAULT false,
  "is_public" boolean NOT NULL DEFAULT false
);

CREATE TABLE "chat_messages" (
  "id" uuid PRIMARY KEY,
  "session_id" uuid NOT NULL,
  "role" varchar(20) NOT NULL, -- 'user', 'assistant', 'system'
  "content" text NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE INDEX ON "users" ("email");
CREATE INDEX ON "auth_sessions" ("user_id");
CREATE INDEX ON "chat_sessions" ("user_id");
CREATE INDEX ON "chat_sessions" ("last_message_at");
CREATE INDEX ON "chat_messages" ("session_id");

ALTER TABLE "auth_sessions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE SET NULL;
ALTER TABLE "chat_messages" ADD FOREIGN KEY ("session_id") REFERENCES "chat_sessions" ("id") ON DELETE CASCADE;

ALTER TABLE "chat_messages" ADD CONSTRAINT "check_message_role" 
    CHECK (role IN ('user', 'assistant', 'system'));
