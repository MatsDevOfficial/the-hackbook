#!/usr/bin/env bash

# Exit on error
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean

# Voor nu prima om zo te laten; later kun je dit eventueel
# naar een pre-deploy hook op Render verplaatsen.
bin/rails db:migrate