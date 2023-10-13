# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION as base

# Rails app lives here
WORKDIR /compass

# Set environment
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Label the image
LABEL name="compass" version="1.0.0"

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config postgresql-client

# Install application gems
COPY Gemfile /compass/Gemfile
COPY Gemfile.lock /compass/Gemfile.lock
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . /compass

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /compass /compass

# Cannot build without this, but I'm not sure why is it happens
RUN gem install rails -v "7.1.0"

# Run and own only the runtime files as a non-root user for security and sest Entrypoint
RUN useradd voyager --create-home --shell /bin/bash && \
    chown -R voyager:voyager db log storage tmp && \
    chmod +x /compass/entrypoint.sh
USER voyager:voyager
ENTRYPOINT ["/compass/entrypoint.sh"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
