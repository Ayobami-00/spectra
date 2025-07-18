-- name: CreateChatSession :one
INSERT INTO chat_sessions (
  id,
  user_id,
  title,
  created_at,
  updated_at,
  last_message_at,
  ip_address,
  is_public 
) VALUES (
  $1, $2, $3, $4, $4, $4, $5, $6
) RETURNING *;

-- name: GetChatSession :one
SELECT * FROM chat_sessions
WHERE id = $1 AND user_id = $2 AND is_archived = false
LIMIT 1;

-- name: GetPublicChatSession :one
SELECT * FROM chat_sessions
WHERE id = $1 AND is_public = true
LIMIT 1;

-- name: ListUserChatSessions :many
SELECT * FROM chat_sessions
WHERE user_id = $1 AND is_archived = false
ORDER BY last_message_at DESC;

-- name: ListUserChatSessionsByIP :many
SELECT * FROM chat_sessions
WHERE ip_address = $1 AND is_archived = false
ORDER BY last_message_at DESC;

-- get all public sessions
-- name: ListPublicChatSessions :many
SELECT * FROM chat_sessions
WHERE is_public = true
ORDER BY last_message_at DESC;

-- name: UpdateChatSessionTitle :one
UPDATE chat_sessions
SET 
  title = $1,
  updated_at = now()
WHERE id = $2 AND user_id = $3
RETURNING *;

-- name: UpdateLastMessageTime :one
UPDATE chat_sessions
SET 
  last_message_at = now(),
  updated_at = now()
WHERE id = $1 AND user_id = $2
RETURNING *;

-- name: ArchiveChatSession :one
UPDATE chat_sessions
SET 
  is_archived = true,
  updated_at = now()
WHERE id = $1 AND user_id = $2
RETURNING *;

-- name: CountUserChatSessions :one
SELECT COUNT(*) FROM chat_sessions
WHERE user_id = $1 AND is_archived = false;

