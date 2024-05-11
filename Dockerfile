 # Use an official Python runtime as a parent image
FROM python:3.11.4-slim-bookworm

# Prevent Python from writing pyc files to disk
ENV PYTHONDONTWRITEBYTECODE 1
# Prevent Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED 1

# Set the working directory to /app
WORKDIR /app

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3-cffi \
        python3-brotli \
        libpango-1.0-0 \
        libpangoft2-1.0-0 \
        && rm -rf /var/lib/apt/lists/*

# Copy only the necessary files for Poetry installation
COPY pyproject.toml ./

# Install Poetry and project dependencies
RUN pip install --no-cache-dir poetry \
    && poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-dev \
    # Install the dotenv plugin for Poetry for loading environment variables
    && poetry self add poetry-dotenv-plugin

# Copy the rest of the application code into the container
COPY . .

CMD ["poetry", "run", "uvicorn", "main:app", "--log-level", "info", "--host", "0.0.0.0", "--port", "9000"]