-- name: CreateChatMessage :one
INSERT INTO chat_messages (
  id,
  session_id,
  role,
  content,
  created_at
) VALUES (
  $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetChatMessage :one
SELECT m.* FROM chat_messages m
JOIN chat_sessions s ON m.session_id = s.id
WHERE m.id = $1 AND s.user_id = $2
LIMIT 1;

-- name: GetPublicChatMessage :one
SELECT m.* FROM chat_messages m
JOIN chat_sessions s ON m.session_id = s.id
WHERE m.id = $1 AND s.is_public = true
LIMIT 1;

-- name: ListSessionMessages :many
SELECT m.* FROM chat_messages m
JOIN chat_sessions s ON m.session_id = s.id
WHERE m.session_id = $1 AND s.user_id = $2
ORDER BY m.created_at ASC;

-- name: ListPublicSessionMessages :many
SELECT m.* FROM chat_messages m
JOIN chat_sessions s ON m.session_id = s.id
WHERE m.session_id = $1 AND s.is_public = true
ORDER BY m.created_at DESC;

-- name: GetLastSessionMessage :one
SELECT m.* FROM chat_messages m
JOIN chat_sessions s ON m.session_id = s.id
WHERE m.session_id = $1 AND s.user_id = $2
ORDER BY m.created_at DESC
LIMIT 1;

-- name: GetLastPublicSessionMessage :one
SELECT m.* FROM chat_messages m
JOIN chat_sessions s ON m.session_id = s.id
WHERE m.session_id = $1 AND s.is_public = true
ORDER BY m.created_at DESC
LIMIT 1;

-- name: CountSessionMessages :one
SELECT COUNT(*) FROM chat_messages m
JOIN chat_sessions s ON m.session_id = s.id
WHERE m.session_id = $1 AND s.user_id = $2;

-- name: CountPublicSessionMessages :one
SELECT COUNT(*) FROM chat_messages m
JOIN chat_sessions s ON m.session_id = s.id
WHERE m.session_id = $1 AND s.is_public = true;

-- name: DeleteSessionMessages :exec
DELETE FROM chat_messages m
USING chat_sessions s
WHERE m.session_id = $1 
AND s.id = m.session_id 
AND s.user_id = $2;    

-- name: DeletePublicSessionMessages :exec
DELETE FROM chat_messages m
USING chat_sessions s
WHERE m.session_id = $1 
AND s.id = m.session_id 
AND s.is_public = true;
