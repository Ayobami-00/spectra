# Spectra

[**View Demo**](https://drive.google.com/file/d/1Hz7wnh9GNcnVZ3yeBZV4jOxeRr8N_jI7/view?usp=sharing)

 ![Spectra Companion Mode](https://drive.google.com/uc?export=view&id=1A_NXQt1Ug5LmY0dB3x95AgQKkifybEU2)

**Chat, Connect, and Create with your very helpful AI companion.**

Spectra is an intelligent assistant designed to help you perform tasks and more. You can chat with the AI to get help with your work, like preparing for an exam by creating flashcards and quizzes. Enable companion mode for real-time video/audio support. Export your work as a PDF, Doc, or share it with others.

Technically, Spectra is a full-stack application featuring a Flutter-based frontend, a Go backend, and a Python-based AI assistant. The entire application is containerized using Docker and managed with Docker Compose for seamless development and deployment.

## Architecture Overview

The project follows a microservices architecture:

-   **Frontend:** A modern, responsive web application built with Flutter. It is served by an Nginx web server, which also acts as a reverse proxy to the backend and assistant services.
-   **Backend:** A robust API built with Go. It handles business logic, data processing, and communication with the database and other services.
-   **Assistant:** A conversational AI agent responsible for providing intelligent assistance within the application.
-   **Database:** PostgreSQL is used for persistent data storage.
-   **Cache:** Redis is used for caching and session management.

## Tech Stack

| Component         | Technology/Framework                               |
| ----------------- | -------------------------------------------------- |
| **Frontend**      | Flutter, Dart, Nginx                               |
| **Backend**       | Go                                                 |
| **Assistant**     | Python (specific framework, e.g., Rasa, not specified) |
| **Database**      | PostgreSQL                                         |
| **Cache**         | Redis                                              |
| **Containerization**| Docker, Docker Compose                             |

## Getting Started

Follow these instructions to get the project up and running on your local machine.

### Prerequisites

-   [Docker](https://docs.docker.com/get-docker/)
-   [Docker Compose](https://docs.docker.com/compose/install/)

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone <your-repository-url>
    cd spectra
    ```

2.  **Configure Environment Variables:**
    Navigate to the `deploy/docker` directory and create a `.env` file by copying the example:
    ```sh
    cd deploy/docker
    cp .env.example .env
    ```
    Open the new `.env` file and populate it with your specific credentials and configuration values for the database, APIs, and other services.

### Running the Application

From the `deploy/docker` directory, run the following command to build and start all the services in detached mode:

```sh
docker-compose up --build -d
```

This command will:
-   Build the Docker images for the frontend, backend, and assistant services.
-   Start all the containers defined in `docker-compose.yml`.
-   Inject the environment variables from the `.env` file at build-time for the frontend and at runtime for the other services.

Once all services are running, you can access the application at:

-   **Frontend:** [http://localhost:8000](http://localhost:8000)

## Services

The `docker-compose.yml` file orchestrates the following services:

| Service           | Description                                       | Ports Exposed (host:container) |
| ----------------- | ------------------------------------------------- | ------------------------------ |
| `frontend`        | Nginx server for the Flutter web app              | `8000:80`                      |
| `backend`         | Go API server                                     | `8080:8080`                    |
| `assistant_agent` | Python AI assistant service                       | `5005:5005`                    |
| `postgres`        | PostgreSQL database                               | `5432:5432`                    |
| `redis`           | Redis in-memory data store                        | `6379:6379`                    |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.