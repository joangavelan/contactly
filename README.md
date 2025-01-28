# Contactly

This is a demo Contacts Application built with the Phoenix Framework, featuring OAuth2 authentication via Google, full CRUD operations, pagination, search functionality, and CSV import/export capabilities.

## Features

- **OAuth2 Authentication**: Utilizes the Assent library for Google authentication.
- **CRUD Operations**: Create, read, update, and delete contacts.
- **Pagination**: Efficiently navigates through contact lists.
- **Search**: Quickly find contacts using the search feature.
- **CSV Import/Export**: Import and export contacts via CSV files.

## Prerequisites

Before setting up the application, ensure you have the following installed:

- **Elixir**: Version 1.14 or later. [Installation Guide](https://elixir-lang.org/install.html)
- **Erlang**: Version 24 or later. [Installation Guide](https://elixir-lang.org/install.html)
- **PostgreSQL**: Ensure it's installed and running. [Installation Guide](https://www.postgresql.org/download/)

## Setup Instructions

### Clone the Repository

```bash
git clone https://github.com/joangavelan/contactly.git
cd contactly
```

### Install Dependencies

Fetch and install the necessary dependencies:

```bash
mix deps.get
```

### Configure Environment Variables

The application requires specific environment variables for Google OAuth2 authentication. Create a file named `.env` in the project root and add the following variables:

```bash
export GOOGLE_CLIENT_ID=your_google_client_id
export GOOGLE_CLIENT_SECRET=your_google_client_secret
export GOOGLE_REDIRECT_URI=http://localhost:4000/auth/google/callback
```

Replace your_google_client_id and your_google_client_secret with your actual Google OAuth2 credentials. The GOOGLE_REDIRECT_URI should match the redirect URI configured in your Google Developer Console.

### Database Configuration

Configure your database settings in `config/dev.exs`. Ensure the `username`, `password`, `hostname`, and `database` fields match your PostgreSQL setup:

```elixir
config :contactly, Contactly.Repo,
  username: "your_db_username",
  password: "your_db_password",
  hostname: "localhost",
  database: "contactly_dev",
```

### Create and Migrate the Database

Set up the database by running:

```bash
mix ecto.create
mix ecto.migrate
```

### Start the Server

Start the Phoenix server while loading the `.env` file using the following command:

```bash
source .env && mix phx.server
```

The `source .env` command ensures your environment variables are loaded, and `mix phx.server` starts the application. The app will be accessible at [http://localhost:4000](http://localhost:4000).

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request with your improvements or feedback.

---
