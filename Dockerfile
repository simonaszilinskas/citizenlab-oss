FROM ruby:3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    postgresql-client

# Set working directory
WORKDIR /app

# Copy the entire application first so engines/free is available
COPY . ./

# Make sure entrypoint script is executable
RUN chmod +x ./back/entrypoint.sh

# Then run bundle install
RUN cd back && bundle install

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Railway specific variables
ENV PORT=3000

# Expose the port
EXPOSE 3000

# Start the Rails server directly instead of using entrypoint script
CMD ["bash", "-c", "cd back && bundle exec rails server -b 0.0.0.0 -p $PORT"]
