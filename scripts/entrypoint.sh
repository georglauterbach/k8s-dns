#! /bin/bash

# version      0.2.1
# executed by  entrypoint in k8s-dns container
# task         performs early container initialization
#              and starts `named`

# -----------------------------------------------
# ----  Shell Setup  ----------------------------
# -----------------------------------------------

set -eEu -o pipefail
shopt -s inherit_errexit

# -----------------------------------------------
# ----  VARIABLE SETUP  -------------------------
# -----------------------------------------------

declare -a NAMED_OPTIONS
NAMED_OPTIONS=('-4' '-f' '-u' "${USER:-named}")
NAMED_MAIN_CONFIGURATION_FILE=${NAMED_MAIN_CONFIGURATION_FILE:-/etc/bind/named.conf}
USER_PATCHES_FILE=${USER_PATCHES_FILE:-/user-patches.sh}

# -----------------------------------------------
# ----  EXECUTION OF USER CONFIGURATION  --------
# -----------------------------------------------

if [[ -f ${USER_PATCHES_FILE} ]]
then
  # shellcheck source=/dev/null
  source "${USER_PATCHES_FILE}"
  
  if [[ $(type -t user-patches-main) == 'function' ]]
  then
    user-patches-main
  fi
fi

# -----------------------------------------------
# ----  FINAL CHECKS AND EXECUTION  -------------
# -----------------------------------------------

named-checkconf "${NAMED_MAIN_CONFIGURATION_FILE}"
NAMED_OPTIONS+=('-c' "${NAMED_MAIN_CONFIGURATION_FILE}")

exec /usr/sbin/named "${NAMED_OPTIONS[@]}"
