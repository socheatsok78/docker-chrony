#!/bin/bash
if chronyc activity | grep '0 sources online'; then
  exit 1
fi
exit 0
