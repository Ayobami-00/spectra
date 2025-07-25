// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.27.0
// source: waitlist.sql

package db

import (
	"context"

	"github.com/google/uuid"
)

const addToWaitlist = `-- name: AddToWaitlist :exec
INSERT INTO waitlist (id, email, plan_type) VALUES ($1, $2, $3)
`

type AddToWaitlistParams struct {
	ID       uuid.UUID `json:"id"`
	Email    string    `json:"email"`
	PlanType string    `json:"plan_type"`
}

func (q *Queries) AddToWaitlist(ctx context.Context, arg AddToWaitlistParams) error {
	_, err := q.db.Exec(ctx, addToWaitlist, arg.ID, arg.Email, arg.PlanType)
	return err
}

const getAllWaitlist = `-- name: GetAllWaitlist :many
SELECT id, email, plan_type, created_at FROM waitlist
`

func (q *Queries) GetAllWaitlist(ctx context.Context) ([]Waitlist, error) {
	rows, err := q.db.Query(ctx, getAllWaitlist)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	items := []Waitlist{}
	for rows.Next() {
		var i Waitlist
		if err := rows.Scan(
			&i.ID,
			&i.Email,
			&i.PlanType,
			&i.CreatedAt,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
