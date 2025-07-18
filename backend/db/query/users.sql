-- name: CreateUser :one
INSERT INTO users (
  id,
  email,
  password,
  username,
  is_email_verified
) VALUES (
  $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetUser :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: GetUserByEmail :one
SELECT * FROM users
WHERE email = $1 LIMIT 1;

-- name: GetUserByUsername :one
SELECT * FROM users
WHERE username = $1 LIMIT 1;

-- name: GetUserByID :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: ListUsers :many
SELECT * FROM users
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateUser :one
UPDATE users
SET 
  email = COALESCE(sqlc.narg('email'), email),
  username = COALESCE(sqlc.narg('username'), username),
  is_email_verified = COALESCE(sqlc.narg('is_email_verified'), is_email_verified),
  updated_at = now()
WHERE id = sqlc.arg('id')
RETURNING *;

-- name: UpdateUserPassword :exec
UPDATE users
SET 
  password = $2,
  updated_at = now()
WHERE id = $1; 