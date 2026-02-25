package errors

import (
	"errors"
	"fmt"
)

// Common error types
var (
	ErrNotFound          = errors.New("not found")
	ErrAlreadyExists     = errors.New("already exists")
	ErrInvalidInput      = errors.New("invalid input")
	ErrUnauthorized      = errors.New("unauthorized")
	ErrInternal          = errors.New("internal error")
)

// AppError represents an application error
type AppError struct {
	Code    string
	Message string
	Err     error
}

func (e *AppError) Error() string {
	if e.Err != nil {
		return fmt.Sprintf("%s: %s (%v)", e.Code, e.Message, e.Err)
	}
	return fmt.Sprintf("%s: %s", e.Code, e.Message)
}

func (e *AppError) Unwrap() error {
	return e.Err
}

// NewAppError creates a new AppError
func NewAppError(code, message string, err error) *AppError {
	return &AppError{
		Code:    code,
		Message: message,
		Err:     err,
	}
}

// NotFound creates a not found error
func NotFound(resource string) *AppError {
	return NewAppError("NOT_FOUND", fmt.Sprintf("%s not found", resource), ErrNotFound)
}

// InvalidInput creates an invalid input error
func InvalidInput(message string) *AppError {
	return NewAppError("INVALID_INPUT", message, ErrInvalidInput)
}

// Internal creates an internal error
func Internal(err error) *AppError {
	return NewAppError("INTERNAL", "An internal error occurred", err)
}
