# Changelog

## v0.2.0 (unreleased)

### Breaking changes

- Requires Elixir ~> 1.17.
- Removed the `:test` value for the `:environment` config. Point the library at
  a local server with the new `:vendors_base_url` / `:checkout_base_url`
  config keys instead.
- `:environment` now defaults to `:production` when unset.
- Requests fail fast with a `{:error, %Paddle.Error{code: :missing_configuration}}`
  when `:vendor_id` / `:vendor_auth_code` are not configured.

### Changes

- HTTP requests are now made with [Req](https://hexdocs.pm/req) (replacing
  Peppermint, which pinned `castore ~> 0.1`).
- All API functions accept a trailing `opts` keyword list for per-call
  configuration overrides: `:vendor_id`, `:vendor_auth_code`, `:environment`,
  `:vendors_base_url`, `:checkout_base_url`, and `:req_options` (merged into
  the underlying `Req` request).
- CI runs on Elixir 1.17/1.18 with OTP 26/27; dependabot enabled.

## v0.1.1

- Fix `__struct__/0` deprecation warning.
- Properly convert "array list" fields to arrays in `Paddle.PayLink`.
