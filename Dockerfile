 # Use an official Python runtime as a parent image
FROM python:3.11

# Prevent Python from writing pyc files to disk
ENV PYTHONDONTWRITEBYTECODE 1
# Prevent Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED 1

# Set the working directory to /app
WORKDIR /app

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends

# Copy only the necessary files for Poetry installation
COPY pyproject.toml ./

# Install Poetry and project dependencies
RUN pip install --no-cache-dir poetry \
    && poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-dev

# Copy the rest of the application code into the container
COPY . .

CMD ["poetry", "run", "uvicorn", "main:app", "--log-level", "info", "--host", "0.0.0.0", "--port", "9000"]