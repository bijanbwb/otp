# Mastery

OTP demo application from
[Designing Elixir Systems](https://pragprog.com/book/jgotp/designing-elixir-systems-with-otp).

## Project Structure

Primary data structures are located in `lib/mastery/core`:

- Quiz
- Template
- Question
- Response

## OTP

See the `lib/mastery/boundary` folder for process machinery.

- QuizManager
- QuizSession (one per user) (`DynamicSupervisor`)

See `lib/mastery/application.ex` for supervision settings.

## Persistence

Quiz responses are persistable with `mastery_persistence` using Ecto. This is
pulled into `mix.exs` with a relative path.

## Tests

For persistence tests, we'll need to create and migrate the database first.

```shell
$ cd mastery_persistence
$ MIX_ENV=test mix ecto.create
$ MIX_ENV=test mix ecto.migrate
$ mix test
```
