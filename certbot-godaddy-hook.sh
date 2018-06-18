#!/bin/bash
SCRIPT_FILE=$(readlink -f "${0}")
SCRIPT_DIR=$(dirname "${SCRIPT_FILE}")
ENV_FILE="${SCRIPT_DIR}/.env"
if [ ! -f "${ENV_FILE}" ]; then
    echo "Couldn't find ${ENV_FILE}"
    exit 1
fi

source "${ENV_FILE}"

if [ -z "$GODADDY_KEY" ]; then
        echo 'Empty $GODADDY_KEY provided'
		echo 'Please edit ${ENV_FILE} and fill in GODADDY_KEY variable!'
        exit 1
fi

if [ -z "$GODADDY_SECRET" ]; then
        echo 'Empty $GODADDY_SECRET provided'
		echo 'Please edit ${ENV_FILE} and fill in GODADDY_SECRET variable!'
        exit 1
fi

if [ -z "$CERTBOT_DOMAIN" ]; then
        echo 'Empty $CERTBOT_DOMAIN provided'
        exit 1
fi

if [ -z "$CERTBOT_VALIDATION" ]; then
        echo 'Empty $CERTBOT_VALIDATION provided'
        exit 1
fi

DOMAIN=$(echo $CERTBOT_DOMAIN | rev | cut -d'.' -f -2 | rev)
SUB_DOMAIN=$(echo $CERTBOT_DOMAIN | rev | cut -d'.' -f 3- | rev)
HOST='_acme-challenge'
if [ ! -z "$SUB_DOMAIN" ]; then
        HOST="${HOST}.${SUB_DOMAIN}"
fi

JSON='
[
  {
    "name": "'${HOST}'",
    "data": "'${CERTBOT_VALIDATION}'",
    "ttl": 600
  }
]'

echo "Domain: ${CERTBOT_DOMAIN}"
echo "Validation: ${CERTBOT_VALIDATION}"

if [ "$DEBUG" = "true" ]; then
        echo "Cut Domain: ${DOMAIN}"
        echo "Cut Subdomain: ${SUB_DOMAIN}"
        echo "Host: ${HOST}"
        echo "Sending to GoDaddy DNS server..."
        echo "Generated json: ${JSON}"
fi

echo "Updating DNS zone record.."
curl -s -XPUT "https://api.godaddy.com/v1/domains/${DOMAIN}/records/TXT/${HOST}" -H "Authorization: sso-key ${GODADDY_KEY}:${GODADDY_SECRET}" -H "Content-Type: application/json" --data "${JSON}"

echo "Validating data.."
curl -s "https://api.godaddy.com/v1/domains/${DOMAIN}/records/TXT/${HOST}" -H "Authorization: sso-key ${GODADDY_KEY}:${GODADDY_SECRET}"

echo 'Waiting 30 seconds...'
sleep 30
echo 'Record should be set, returning to Certbot'

