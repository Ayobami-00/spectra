
-- name: AddToWaitlist :exec
INSERT INTO waitlist (id, email, plan_type) VALUES ($1, $2, $3); 

-- name: GetAllWaitlist :many
SELECT * FROM waitlist;