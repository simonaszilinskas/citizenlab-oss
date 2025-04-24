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

# Install npm dependencies for MJML
RUN npm install -g mjml

# Install gems
RUN cd back && bundle install

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true
ENV MEMCACHED_HOST=localhost
ENV MEMCACHED_PORT=11211
ENV CACHE_STORE=memory_store
ENV ACTION_MAILER_DELIVERY_METHOD=smtp
ENV DEFAULT_FROM_EMAIL=noreply@example.com

# Create a startup script to handle environment setup
RUN echo '#!/bin/bash\n\
cd /app/back\n\
# Generate secret key if not provided\n\
if [ -z "$SECRET_KEY_BASE" ]; then\n\
  export SECRET_KEY_BASE=$(bundle exec rake secret)\n\
fi\n\
# Run database migrations\n\
bundle exec rake db:migrate\n\
# Start the server\n\
bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}\n\
' > /app/start.sh && chmod +x /app/start.sh

# Expose the port
EXPOSE 3000

# Run the startup script
CMD ["/app/start.sh"]
