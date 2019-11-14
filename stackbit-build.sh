#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5dcde2e76f7612001b29308a/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5dcde2e76f7612001b29308a 
fi
curl -s -X POST https://api.stackbit.com/project/5dcde2e76f7612001b29308a/webhook/build/ssgbuild > /dev/null
cd exampleSite && hugo --gc --baseURL "/" --themesDir ../.. && cd ..
./inject-netlify-identity-widget.js exampleSite/public
curl -s -X POST https://api.stackbit.com/project/5dcde2e76f7612001b29308a/webhook/build/publish > /dev/null
