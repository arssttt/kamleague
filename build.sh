#!/usr/bin/env bash
# exit on error
set -o errexit

# Initial setup
mix local.hex --force && mix local.rebar --force
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
npm install --prefix ./assets
npm run deploy --prefix ./assets
MIX_ENV=prod mix phx.digest

# Build the release and overwrite the existing release directory
MIX_ENV=prod mix release --overwrite