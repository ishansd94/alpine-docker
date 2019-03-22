#!/bin/sh

: ${SECRETS_DIR:=/run/secrets}

print_msg() {
    echo -e  "\033[1m$1\033[0m\n"
}


print_debug_msg()
{
    if [ ! -z "$SECRETS_TO_ENV_DEBUG" ]; then
        print_msg "$@"
    fi
}

expand_secret() {
    var="$1"
    eval val=\$$var
    if secret_name=$(expr match "$val" "{{SECRET:\([^}]\+\)}}$"); then
        secret="${SECRETS_DIR}/${secret_name}"
        print_debug_msg "Secret file for $var: $secret"
        if [ -f "$secret" ]; then
            val=$(cat "${secret}")
            export "$var"="$val"
            print_debug_msg "Expanded variable: $var=$val"
        else
            print_debug_msg "Secret file does not exist! $secret"
        fi
    fi
}

expand_secrets() {

    print_debug_msg "SECRETS_DIR : ${SECRETS_DIR}"

    for env_var in $(printenv | cut -f1 -d"=")
    do
        expand_secret "${env_var}"
    done

    if [ ! -z "$SECRETS_TO_ENV_DEBUG" ]; then
       print_msg "Expanded secrets"
       printenv
    fi
}

expand_secrets
