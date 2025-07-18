import base64
import json


def decode_base_64_to_json(base64_string: str):

    base64_bytes = base64_string.encode("ascii")
    string_bytes = base64.b64decode(base64_bytes)
    output_string = string_bytes.decode("ascii")
    output_json = json.loads(output_string)

    return output_json
