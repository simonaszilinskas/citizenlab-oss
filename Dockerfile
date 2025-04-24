FROM ruby:3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    postgresql-client \
    npm

# Set working directory
WORKDIR /app

# Copy the entire application
COPY . ./

# Make sure entrypoint script is executable
RUN chmod +x ./back/entrypoint.sh

# Install npm dependencies for MJML (required by the app)
RUN npm install -g mjml

# Install gems
RUN cd back && bundle install

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Expose the port
EXPOSE 3000

# Script to wait for database and then start Rails
CMD ["bash", "-c", "cd back && \
    bundle exec rake db:migrate && \
    bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"]
