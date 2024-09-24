#!/bin/bash
# Perform HEALTHCHECK and attempt to reselect source if none available
if chronyc activity | grep '0 sources online'; then
  if [ "${AUTORESELECT:-false}" = true ]; then
    chronyc reselect
  fi
  exit 1
fi
exit 0
