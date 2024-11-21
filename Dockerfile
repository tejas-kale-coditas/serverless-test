# FROM public.ecr.aws/lambda/python:3.10

# WORKDIR /app

# ARG DEBIAN_FRONTEND=noninteractive

# RUN yum update -y
# RUN yum update -y python3 curl libcom_err ncurses expat libblkid libuuid libmount
# RUN yum install ffmpeg libsm6 libxext6 python3-pip git -y

# RUN pip3 install fastapi --target "${LAMBDA_TASK_ROOT}"
# RUN pip3 install mangum --target "${LAMBDA_TASK_ROOT}"

# COPY lambda.py ${LAMBDA_TASK_ROOT}/lambda.py

# CMD [ "lambda.handler" ]

## UPDATED DOCKERFILE

# Use a lightweight Python base image
FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Install Poetry
RUN pip install --no-cache-dir poetry

# Copy project files
COPY pyproject.toml poetry.lock ./

# Install dependencies without dev packages
RUN poetry install --no-dev --no-interaction --no-ansi

# Copy application files
COPY lambda.py .

# Expose the default Lambda runtime port (8080 is commonly used by SAM/LocalStack)
EXPOSE 8080

# Set the command to start the application
CMD ["poetry", "run", "uvicorn", "lambda:app", "--host", "0.0.0.0", "--port", "8080"]
