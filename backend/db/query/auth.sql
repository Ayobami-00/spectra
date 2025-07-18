-- name: CreateEmailVerification :one
INSERT INTO email_verifications (
    email,
    secret_code,
    is_used,
    expired_at
) VALUES (
    $1, $2, $3, $4
)
ON CONFLICT (email, secret_code) DO UPDATE
SET expired_at = EXCLUDED.expired_at
RETURNING *;

-- name: VerifyEmail :one
UPDATE email_verifications
SET is_used = true
WHERE email = $1 
AND secret_code = $2
AND is_used = false
AND expired_at > now()
RETURNING *;