import urllib.request
import urllib.parse
import json
import ssl
import base64

email = "fitnova.deployer2026@gmail.com"
password = "FitnovaDeploy2026!"

auth_str = f"{email}:{password}"
b64_auth = base64.b64encode(auth_str.encode()).decode()

req = urllib.request.Request("https://surge.sh/token", method="POST")
req.add_header("Authorization", f"Basic {b64_auth}")

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

try:
    with urllib.request.urlopen(req, context=ctx) as resp:
        token = resp.read().decode().strip()
        print("SURGE TOKEN ACQUIRED SUCCESS!")
        print("Token:", token)
except Exception as e:
    print("Error getting token:", e)
