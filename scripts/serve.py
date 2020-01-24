#!/usr/bin/python3
import os
import sys
from http.server import HTTPServer, CGIHTTPRequestHandler

if os.fork():
    sys.exit()

dir = sys.argv[1]
port = sys.argv[2]
host_name = "localhost"
os.chdir(dir)
httpd = HTTPServer((host_name, int(port)), CGIHTTPRequestHandler)
print("Serving " + dir + " on http://localhost:" + port)
print("Forking to background; you will need to kill this process to stop the server")
httpd.serve_forever()
