# Go project
MODULE := github.com/yourorg/project
SERVICE_NAME := project
BUILD_DIR := bin
PROTO_DIR := api/proto

# Proto
PROTOC := protoc
PROTO_FILES := $(wildcard $(PROTO_DIR)/*.proto)
GENERATED_GO := $(PROTO_FILES:.proto=.pb.go)

# Code generation
CODegen := $(shell which codegen 2>/dev/null || echo "./scripts/codegen.sh")
WIRE := wire
GOJSON := gojson

# Colors
GREEN := $(shell tput setaf 2 2>/dev/null || echo "")
YELLOW := $(shell tput setaf 3 2>/dev/null || echo "")
RESET := $(shell tput sgr 0 2>/dev/null || echo "")

.PHONY: all build test clean proto api wire repo generate install

# Default target
all: install build

# Install dependencies
install:
	@echo "$(GREEN)Installing Go dependencies...$(RESET)"
	go mod download
	@echo "$(GREEN)Installing proto tools...$(RESET)"
	which protoc > /dev/null || (echo "$(YELLOW)protoc not found. Install from https://github.com/protocolbuffers/protobuf/releases$(RESET)" && exit 1)
	which protoc-gen-connect-go > /dev/null || go install github.com/connectrpc/connect-go/cmd/protoc-gen-connect-go@latest
	which protoc-gen-go > /dev/null || go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	which wire > /dev/null || go install github.com/google/wire/cmd/wire@latest

# Generate proto files
proto: $(GENERATED_GO)
	@echo "$(GREEN)Proto files generated$(RESET)"

%.pb.go: $(PROTO_DIR)/%.proto
	@echo "$(GREEN)Generating $@ from $<$(RESET)"
	$(PROTOC) --go_out=. --connect_go_out=. --go_opt=paths=source_relative --connect_go_opt=paths=source_relative $<

# Generate repository code
repo:
	@echo "$(GREEN)Generating repository code...$(RESET)"
	@if [ -f $(CODegen) ]; then \
		$(CODegen) generate; \
	else \
		echo "$(YELLOW)codegen tool not found. Using manual repository implementation.$(RESET)"; \
	fi

# Generate wire dependency injection
wire:
	@echo "$(GREEN)Generating wire DI code...$(RESET)"
	cd cmd/service && $(WIRE) -o wire_gen.go

# Generate all (proto, repo, wire)
generate: proto repo wire
	@echo "$(GREEN)All code generation complete$(RESET)"

# Build the service
build: $(BUILD_DIR)/$(SERVICE_NAME)

$(BUILD_DIR)/$(SERVICE_NAME): $(GENERATED_GO) cmd/service/main.go
	@echo "$(GREEN)Building $(SERVICE_NAME)...$(RESET)"
	go build -o $@ ./cmd/service

# Run the service
run: build
	@echo "$(GREEN)Running $(SERVICE_NAME)...$(RESET)"
	./$(BUILD_DIR)/$(SERVICE_NAME)

# Run tests
test:
	@echo "$(GREEN)Running tests...$(RESET)"
	go test -v ./...

# Run tests with coverage
test-coverage:
	@echo "$(GREEN)Running tests with coverage...$(RESET)"
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

# Clean build artifacts
clean:
	@echo "$(GREEN)Cleaning...$(RESET)"
	rm -rf $(BUILD_DIR)
	rm -f $(PROTO_DIR)/*.pb.go $(PROTO_DIR)/*_connect*.go
	rm -f cmd/service/wire_gen.go
	rm -f coverage.out coverage.html

# Run linter
lint:
	@echo "$(GREEN)Running linter...$(RESET)"
	which golangci-lint > /dev/null && golangci-lint run || echo "$(YELLOW)golangci-lint not installed$(RESET)"

# Development command - runs everything
dev: generate build run
