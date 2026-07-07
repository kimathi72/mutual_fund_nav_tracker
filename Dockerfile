FROM ruby:3.2.5

ARG UID=1000
ARG GID=1000

ENV LANG=C.UTF-8 \
    TZ=UTC \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    git \
    curl \
    nodejs \
    npm \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Create a user matching the host user's UID/GID
RUN groupadd -g ${GID} appgroup && \
    useradd -m -u ${UID} -g appgroup -s /bin/bash appuser

WORKDIR /app

# Install gems first for better layer caching
COPY Gemfile Gemfile.lock ./

RUN bundle install

# Copy application
COPY . .

# Ensure the application and bundle directories are writable
RUN mkdir -p tmp/pids log && \
    chown -R appuser:appgroup /app /usr/local/bundle

USER appuser

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]