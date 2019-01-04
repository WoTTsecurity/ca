import sys
import json

try:
    payload = json.load(sys.stdin)
except:
    print('Unable to load payload. Something went wrong.')
    sys.exit(1)


if payload.get('success') is False:
    print('Failed to sign certificate.')
    sys.exit(1)

if payload.get('cert'):
    print('Found cert. Writing to tmp.crt')
    with open('tmp.crt', 'w') as f:
        f.write(payload['cert'])

if payload.get('key'):
    print('Found key. Writing to tmp.key')
    with open('tmp.key', 'w') as f:
        f.write(payload['key'])
