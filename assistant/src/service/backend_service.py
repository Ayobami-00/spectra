import requests
from typing import Dict, Optional
from src.core.config import settings
from src.core.error import AuthenticationError, APIError


class BackendService:
    def __init__(self):
        self.base_url = settings.BACKEND_API_URL
        self.access_token = None

    def authenticate(self) -> None:
        """Authenticate with backend using superadmin credentials. Creates default user if login fails."""
        try:
            # Attempt normal login first
            response = requests.post(
                f"{self.base_url}/auth/login",
                json={
                    "email": settings.BACKEND_ADMIN_EMAIL,
                    "password": settings.BACKEND_ADMIN_PASSWORD,
                },
            )
            response.raise_for_status()
            self.access_token = response.json()["access_token"]

            self.super_admin_id = response.json().get("user").get("id")

        except Exception as initial_error:
            try:
                # Attempt to create default user
                create_response = requests.post(
                    f"{self.base_url}/users",
                    headers={"Content-Type": "application/json"},
                    json={
                        "email": settings.BACKEND_ADMIN_EMAIL,
                        "password": settings.BACKEND_ADMIN_PASSWORD,
                        "username": settings.BACKEND_ADMIN_EMAIL.split("@")[
                            0
                        ],  # Use email prefix as username
                    },
                )
                create_response.raise_for_status()

                # Try logging in again
                response = requests.post(
                    f"{self.base_url}/auth/login",
                    json={
                        "email": settings.BACKEND_ADMIN_EMAIL,
                        "password": settings.BACKEND_ADMIN_PASSWORD,
                    },
                )
                response.raise_for_status()
                self.access_token = response.json()["access_token"]
                self.super_admin_id = response.json().get("user").get("id")
            except Exception as e:
                raise AuthenticationError(
                    f"Failed to authenticate and create default user: {str(e)}. Original error: {str(initial_error)}"
                )

    def get_session_messages(self, session_id: str, is_public: bool = False) -> Dict:
        """Get messages for a specific session"""
        # self.authenticate()

        try:
            if is_public:
                url = f"{self.base_url}/public/sessions/{session_id}/messages"
            else:
                url = f"{self.base_url}/sessions/{session_id}/messages"

            response = requests.get(
                url,
                headers={
                    "Authorization": f"Bearer {self.access_token}",
                    "Content-Type": "application/json",
                },
            )
            response.raise_for_status()
            return response.json()
        except Exception as e:
            raise APIError(f"Failed to get session messages: {str(e)}")

    def store_message(
        self, session_id: str, role: str, content: str, is_public: bool = False
    ) -> Dict:
        """Store a message for a specific session"""
        # self.authenticate()

        try:
            if is_public:
                url = f"{self.base_url}/public/sessions/{session_id}/messages"
            else:
                url = f"{self.base_url}/sessions/{session_id}/messages"

            response = requests.post(
                url,
                headers={
                    "Authorization": f"Bearer {self.access_token}",
                    "Content-Type": "application/json",
                },
                json={"content": content, "role": role},
            )
            response.raise_for_status()
            return response.json()
        except Exception as e:
            raise APIError(f"Failed to store message: {str(e)}")
