import json
from typing import Any, Dict, Optional
import requests


class ApiHelper:
    def __init__(
        self,
        headers: Optional[Dict] = None,
        token: Optional[str] = None,
    ):

        if headers:

            self.headers = headers

        else:
            self.headers = {
                "Accept": "application/json",
                "token": f"Bearer {token}",
                "Content-Type": "application/json",
            }

    def get(self, url: str):

        try:

            response = requests.get(url=url, headers=self.headers)

            if response.status_code == 200:
                return response.status_code, json.loads(response.text)
            else:
                return response.status_code, {}

        except:

            return 500, {}

    def post(self, url: str, data: Any):

        try:

            if isinstance(data, dict):

                response = requests.post(
                    url=url, headers=self.headers, data=json.dumps(data)
                )
            else:
                response = requests.post(
                    url=url, headers=self.headers, data=data
                )

            if response.status_code == 200 or response.status_code == 201:
                return response.status_code, json.loads(response.text)
            else:
                return 500, {}

        except:
            return 500, {}

    def delete(self, url: str):

        try:

            response = requests.delete(url=url, headers=self.headers)

            if response.status_code == 200:
                return True
            else:
                return False

        except:
            return 500, {}

    def patch(self, url: str, data: Optional[dict] = {}):

        try:

            response = requests.patch(
                url=url, headers=self.headers, data=json.dumps(data)
            )


            if response.status_code == 200 or response.status_code == 201:

                return response.status_code, json.loads(response.text)
            else:
                return 500, {}

        except:
            return 500, {}

    def put(self, url: str, data: Optional[dict] = {}):

        try:

            response = requests.put(
                url=url, headers=self.headers, data=json.dumps(data)
            )

            if response.status_code == 200 or response.status_code == 201:

                return response.status_code, json.loads(response.text)
            else:
                return 500, {}

        except:
            return 500, {}
