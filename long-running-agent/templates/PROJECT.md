# Project Documentation

## Technology Stack

### Frontend
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **UI Components**: Skill-based UI (@skill-ui-nextjs/core)
- **API Client**: Connect RPC (@connectrpc/connect-react)
- **State Management**: React Hooks + Context

### Backend
- **Language**: Go 1.22+
- **Architecture**: DDD + Clean Architecture
- **RPC**: Connect RPC
- **Dependency Injection**: Wire
- **Repository Code Generation**: xyzbit/codegen

## Project Structure

```
project/
├── frontend/                 # Next.js Frontend
│   ├── app/                  # Pages and layouts (no business logic)
│   ├── components/           # Reusable UI components
│   ├── features/             # Business modules
│   ├── lib/                  # Infrastructure code
│   └── styles/               # Global styles
│
└── backend/                  # Go Backend
    ├── cmd/                  # Entry points
    ├── internal/             # Private application code
    │   ├── shared/           # Shared utilities
    │   ├── modules/          # Domain modules
    │   └── bff/              # BFF layer
    ├── api/                  # Proto files
    ├── configs/              # Configuration files
    ├── scripts/              # Build/utility scripts
    └── tests/                # Test utilities
```

## Architecture

### Layer Order
```
interfaces → application → domain
```

### Domain Layer (Core)
- **Entities**: Business objects with identity
- **Value Objects**: Immutable objects without identity
- **Aggregates**: Cluster of related entities
- **Repository Interfaces**: Data access contracts
- **Domain Services**: Business logic

### Application Layer
- **Use Cases**: Orchestrate business operations
- **Commands**: Write operations
- **Queries**: Read operations
- **DTOs**: Data transfer objects

### Infrastructure Layer
- Repository implementations
- Database code
- External service clients

### Interfaces Layer
- RPC handlers
- Protocol mapping
- Validation

### BFF Layer
- Aggregates backend services
- Adapts API for frontend
- Reduces frontend complexity

## Development Commands

### Backend
```bash
cd backend

# Install dependencies and tools
make install

# Generate code (proto, repositories, wire)
make generate

# Build the service
make build

# Run the service
make run

# Run tests
make test

# Run with coverage
make test-coverage

# Development mode (generate + build + run)
make dev

# Clean build artifacts
make clean
```

### Frontend
```bash
cd frontend

# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build

# Run linter
npm run lint

# Type check
npm run type-check
```

## Communication Flow

```
┌─────────────┐    Connect RPC    ┌─────────────┐
│  Frontend   │ ←───────────────── │     BFF     │
│  (Next.js)  │                    │  (Go)       │
└─────────────┘                    └──────┬──────┘
                                           │
                                    ┌──────▼──────┐
                                    │   Domain    │
                                    │  Services   │
                                    └─────────────┘
```

## Feature Development

Each new feature must include:

### Backend
- `domain/` - Entities, repositories, domain services
- `application/` - Use cases, commands, queries, DTOs
- `infrastructure/` - Repository implementations
- `interfaces/` - RPC handlers

### Frontend
- `features/<feature>/` - Feature module
  - `components/` - Feature-specific components
  - `hooks/` - Custom React hooks
  - `api.ts` - API client for the feature

## Naming Conventions

### Modules
- Use singular nouns: `payment`, `account`, `catalog`

### Files
- Lower snake_case: `user_service.go`, `create_user.go`
- Test files: `*_test.go`

## Best Practices

1. **No business logic in interfaces or infrastructure layers**
2. **Use cases must be in the application layer**
3. **Domain must be pure (no external dependencies)**
4. **Frontend only talks to BFF**
5. **Use TDD - write tests first**
6. **Keep functions small and focused**

## Code Generation

### Proto Files
Location: `api/proto/*.proto`

Generate with:
```bash
make proto
```

### Repositories
Uses xyzbit/codegen for automatic CRUD generation.

### Dependency Injection
Uses Google Wire for compile-time DI.

## Environment Variables

### Frontend
Create `.env.local`:
```env
NEXT_PUBLIC_API_URL=http://localhost:8080
```

### Backend
Create `configs/.env`:
```env
PORT=8080
DATABASE_URL=postgres://localhost:5432/project
LOG_LEVEL=debug
```
