# 📦 GraphQL Rails App Setup

This project sets up a Rails application with GraphQL, PostgreSQL, Docker, and basic models (`User`, `Post`, `Comment`) to build a foundation for a blog or social app.

---

## 🛠 Prerequisites

- Ruby and Rails
- Docker & Docker Compose
- PostgreSQL
- Node & Yarn (optional for frontend)

---

## 🚀 Setup Instructions

### 1. **Create a new Rails app with PostgreSQL (no default test framework)**

```bash
rails new graphql_app --database=postgresql -T
cd graphql_app
```

### 2. **Add environment management and faker for seeding**

```bash
bundle add dotenv-rails
bundle add faker --group development
```

Create required config files:

```bash
touch .env
touch docker-compose.yml
```

### 3. **Database setup**

Prepare your DB:

```bash
rails db:prepare
```

Spin up PostgreSQL via Docker:

```bash
docker compose up -d
```

Then prepare the DB again (in case container wasn’t ready before):

```bash
rails db:prepare
```

### 4. **Add GraphQL support**

```bash
bundle add graphql
rails g graphql:install
```

This will generate:
- `GraphqlController`
- Base schema files
- GraphiQL IDE (optional for development)

---

## 🧱 Models

### 5. **Generate models**

```bash
rails g model user name email
rails g model post user:references title content
rails g model comment post:references user:references body
```

Run migrations:

```bash
rails db:migrate
```

Seed data (edit `db/seeds.rb` as needed):

```bash
rails db:seed
```

### 6. **GraphQL Object Types**

```bash
rails g graphql:object user
rails g graphql:object post
rails g graphql:object comment
```

These define how the models are exposed in your GraphQL API.

---

## 🔐 Authentication (Basic)

Add a password to users (optional for auth):

```bash
rails g migration AddPasswordToUsers password_digest
rails db:migrate
```

This allows using `has_secure_password` in the `User` model.

---

## 🧪 Manual Testing

You can launch the console:

```bash
rails c
```

Or start the server:

```bash
rails s
```

Then test queries like:

```graphql
query {
  users {
    name
    email
  }
}
```

Using:
```bash
curl -X POST http://localhost:3000/graphql   -H "Content-Type: application/json"   -d '{ "query": "{ users { name email } }" }'
```

---

## 🐳 Docker Compose (Optional Example)

Edit your `docker-compose.yml` like this:

```yaml
version: "3.8"
services:
  db:
    image: postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - db_data:/var/lib/postgresql/data
volumes:
  db_data:
```

Set credentials in `.env`:

```env
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
POSTGRES_HOST=db
```

---

## ✅ Summary of Commands

```bash
rails new graphql_app --database=postgresql -T
cd graphql_app
bundle add dotenv-rails
bundle add faker --group development
touch .env docker-compose.yml
rails db:prepare
docker compose up -d
rails db:prepare
bundle add graphql
rails g graphql:install
rails g model user name email
rails g model post user:references title content
rails g model comment post:references user:references body
rails db:migrate
rails db:seed
rails c
rails g graphql:object user
rails g graphql:object post
rails g graphql:object comment
rails g migration AddPasswordToUsers password_digest
rails db:migrate
rails s
```
---

## 📬 GraphiQL Query Examples

You can use the GraphiQL IDE at `/graphiql` (in development) or send requests to `/graphql` endpoint.

### 🔹 Fetch all users with post count

```graphql
query {
  users {
    email
    name
    postCount
  }
}
```

### 🔹 Fetch a single user by ID

```graphql
query {
  user(id: 1) {
    name
    email
  }
}
```

### 🔹 Create a new user

```graphql
mutation { 
  createUser(input: {
    name: "Test accunt",
    email: "test.account123@yopmail.com",
    password: "testpassword123"
  }) {
    user {
      id
      email
    }
  }
}
```

### 🔹 Login and get auth token

```graphql
mutation {
  login(input: {
    email: "test.account123@yopmail.com",
    password: "testpassword123"
  }) {
    token
  }
}
```