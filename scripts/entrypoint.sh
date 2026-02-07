#! /bin/sh

set -e -u

NAMED_MAIN_CONFIGURATION_FILE=${NAMED_MAIN_CONFIGURATION_FILE:-/etc/bind/named.conf}
readonly USER_PATCHES_FILE="${USER_PATCHES_FILE:-/user-patches.sh}"

if [ -f "${USER_PATCHES_FILE}" ]; then
  # shellcheck source=/dev/null
  . "${USER_PATCHES_FILE}"

  if [ "$(type user_patches_main)" = 'user_patches_main is a function' ]; then
    user-patches-main
  fi
fi

named-checkconf "${NAMED_MAIN_CONFIGURATION_FILE}"
exec /usr/sbin/named -f -u "${USER:-named}" -c "${NAMED_MAIN_CONFIGURATION_FILE}" "${@}"
