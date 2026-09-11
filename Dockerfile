FROM ruby:3.3.4

RUN DD_API_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
  DD_SITE="us5.datadoghq.com" \
  DD_INSTALL_ONLY=true \
  bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)" 

COPY ./datadog.yaml /etc/datadog-agent/datadog.yaml

# Install OS dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  postgresql-client \
  default-mysql-client \
  nodejs \
  vim \
  && rm -rf /var/lib/apt/lists/*

    
WORKDIR /app

# Install gems first (caches bundle layer)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy app code
COPY . .

EXPOSE 3000