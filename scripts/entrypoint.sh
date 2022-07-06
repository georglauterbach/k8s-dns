#! /bin/bash

set -eEu -o pipefail

declare -a NAMED_OPTIONS
NAMED_OPTIONS+=('-4')
NAMED_OPTIONS+=('-f')
NAMED_OPTIONS+=('-u')
NAMED_OPTIONS+=('bind')
NAMED_OPTIONS+=('-c')
NAMED_OPTIONS+=('/etc/bind/named.conf')

if [[ -f /user-patches.sh ]]
then
  # shellcheck source=/dev/null
  source /user-patches.sh
  
  if [[ $(type -t user-patches-main) == 'function' ]]
  then
    user-patches-main
  fi
fi

named-checkconf /etc/bind/named.conf
exec /usr/sbin/named "${NAMED_OPTIONS[@]}"
