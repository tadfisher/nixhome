#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.requests nix

import json
import requests
import os
import sys
from urllib.parse import quote

shellVersion = sys.argv[1] if len(sys.argv) >= 2 else sys.exit('Usage: %s shell-version (e.g. %s 3.34)' % (sys.argv[0], sys.argv[0]))

domain = 'https://extensions.gnome.org'

response = requests.get(f'{domain}/static/extensions.json')

out = {}

versions = set(['.'.join(shellVersion.split('.')[:2]), shellVersion])

extensions = filter(lambda e: (v in e['shell_version_map'] for v in versions), response.json()['extensions'])


def getShellVersion(e):
    for v in versions:
        if v in e['shell_version_map']:
            return e['shell_version_map'][v]
    return None


def getUrl(domain, name, tag, uuid):
    r = requests.head(
        f'{domain}/download-extension/{quote(uuid)}.shell-extension.zip',
        params={'version_tag': tag}
    )
    return f'{domain}{r.headers["location"]}'


for e in extensions:
    versionMeta = getShellVersion(e)
    if (versionMeta is None): continue
    link = e['link']
    name = link.split('/')[-2]
    version = versionMeta['version']
    tag = versionMeta['pk']
    uuid = e['uuid']
    url = getUrl(domain, name, tag, uuid)

    out[name] = {
        'pname': name,
        'version': version,
        'uuid': uuid,
        'src': {
            'url': url,
            'sha256': os.popen(f'nix-prefetch-url --unpack {url}').read().strip()
        },
        'meta': {
            'homepage': f'{domain}{link}',
            'description': e['description'].split('\n')[0],
            'longDescription': e['description']
        }
    }

with open('extensions.json', 'w') as f:
    json.dump(out, f, indent=2, ensure_ascii=False)

# shellVersion=$1

# curl 'https://extensions.gnome.org/extension-query/?n_per_page=-1&shell_version='$shellVersion \
#     | jq --arg shellVersion $shellVersion '.extensions | .[] | {uuid: .uuid, name: .name, link: .link, description: .description, tag: .shell_version_map[$shellVersion].pk, version: .shell_version_map[$shellVersion].version}' \
#     > extensions.json

# cat extensions.json \
#     | jq '@uri "https://extensions.gnome.org/download-extension/\(.uuid).shell-extension.zip?version_tag=\(.tag)"' \
#     | nix-prefetch-url 
