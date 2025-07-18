CREATE TABLE "waitlist" (
  "id" uuid PRIMARY KEY,
  "email" varchar NOT NULL,
  "plan_type" varchar(20) NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

-- Add index for email lookups
CREATE INDEX ON "waitlist" ("email");
