FROM ruby:3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    postgresql-client

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY back/Gemfile back/Gemfile.lock ./back/
RUN cd back && bundle install

# Copy the rest of the application
COPY back ./back/

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Railway specific variables
ENV PORT=3000

# Expose the port
EXPOSE 3000

# Set the entrypoint
ENTRYPOINT ["./back/entrypoint.sh"]

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
