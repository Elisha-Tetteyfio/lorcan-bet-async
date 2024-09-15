# Lorcan

## Installation & Setup
### -- Cloning the project
* Clone the repo by running the command `git clone https://github.com/Elisha-Tetteyfio/lorcan-bet-async.git`
- Run `mix deps.get` to get dependencies for the project

### -- Database connection
- Create a `.env` file in the root of the project and set your database credentials in it, according to the values required in the `config/config.exs`
- Run `mix ecto.migrate` to set up the database connection.
- If you do not already have the database created, run `mix ecto.create` to create the database before you run the migration.

### - Start the project
- Run `mix run --no-halt` to get the project up.
- Enjoy

## Built with
- Elixir
- Poison and Cowboy
- PostgreSql

# Side note
The background job to check for pending orders for this project has been set to 1 minute (60secs).
Feel free to change the value at`/lib/lorcan/order_producer.ex`, line 7.

