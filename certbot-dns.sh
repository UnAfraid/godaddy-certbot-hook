#!/bin/bash
DOMAIN="${1}"
SCRIPT_FILE=$(readlink -f "${0}")
SCRIPT_DIR=$(dirname "${SCRIPT_FILE}")
ENV_FILE="${SCRIPT_DIR}/.env"
HOOK_SCRIPT="${SCRIPT_DIR}/certbot-godaddy-hook.sh"
if [ ! -f "${ENV_FILE}" ]; then
    echo "Env file ${ENV_FILE} doesn't exists!"
    exit 1
fi

if [ ! -f "${HOOK_SCRIPT}" ]; then 
    echo "Hook ${HOOK_SCRIPT} doesn't exists!"
    exit 1
fi

if [ ! -x "${HOOK_SCRIPT}" ]; then 
    echo "Hook ${HOOK_SCRIPT} is not executable!"
    exit 1
fi

source "${ENV_FILE}"

echo "Requesting certificate for ${DOMAIN}.."
if [ -z "${DOMAIN}" ]; then
    echo "Usage ./${0} example.domain.com"
    exit 1
fi

if [ -z "${EMAIL_ADDRESS}" ]; then 
    echo 'Empty $EMAIL_ADDRESS provided'
    echo 'Please edit ${ENV_FILE} and fill in EMAIL_ADDRESS variable!'
    exit 1
fi


if [ -z "${ACME_SERVER}" ]; then 
    echo 'Empty $ACME_SERVER provided'
	echo 'Please edit ${ENV_FILE} and fill in ACME_SERVER variable!'
    exit 1
fi

certbot certonly --agree-tos --manual --preferred-challenge=dns --manual-auth-hook="${HOOK_SCRIPT}" --email "${EMAIL_ADDRESS}" --manual-public-ip-logging-ok -d "${DOMAIN}" --server "${ACME_SERVER}"
