FROM ruby:3.2.0

ARG TELEGRAM_TOKEN

# Install dependencies
RUN apt-get update && apt-get install -y build-essential

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install the gems
RUN bundle install

# Copy the rest of the code
COPY . .

ENV TELEGRAM_TOKEN=${TELEGRAM_TOKEN}

# Run the script
CMD ["bundle", "exec", "ruby", "main.rb"]
