# TODO List - Backend API

Backend REST API for the TODO list management system.

## Features

- Task management with priorities and deadlines
- Category organization
- Multi-platform synchronization
- Calendar view integration
- Task sharing and collaboration
- Notifications and reminders
- Search functionality
- Task completion tracking

## Technology Stack

- **Runtime**: Node.js
- **Language**: TypeScript
- **Framework**: Express.js
- **Database**: Microsoft SQL Server
- **Architecture**: REST API with multi-tenancy support

## Project Structure

```
src/
├── api/                    # API controllers
│   └── v1/                 # API version 1
│       ├── external/       # Public endpoints
│       └── internal/       # Authenticated endpoints
├── routes/                 # Route definitions
├── middleware/             # Express middleware
├── services/               # Business logic
├── utils/                  # Utility functions
├── constants/              # Application constants
├── instances/              # Service instances
├── config/                 # Configuration
└── server.ts               # Application entry point
```

## Getting Started

### Prerequisites

- Node.js 18+ installed
- SQL Server instance available
- npm or yarn package manager

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your database credentials and configuration

4. Run database migrations (when available)

### Development

Start the development server:
```bash
npm run dev
```

The API will be available at `http://localhost:3000/api/v1`

### Production Build

Build the application:
```bash
npm run build
```

Start the production server:
```bash
npm start
```

## API Documentation

### Base URL

- Development: `http://localhost:3000/api/v1`
- Production: `https://api.yourdomain.com/api/v1`

### Endpoints

#### Health Check

```
GET /health
```

Returns API health status and version information.

### Authentication

Authentication endpoints will be added as features are implemented.

### Task Management

Task management endpoints will be added as features are implemented.

## Environment Variables

See `.env.example` for all available configuration options.

## Contributing

Features are implemented following the project's architecture standards:

- RESTful API design principles
- Multi-tenancy support
- Comprehensive error handling
- TypeScript strict mode
- TSDoc documentation
- Unit and integration testing

## License

ISC