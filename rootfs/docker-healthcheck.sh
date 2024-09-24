#!/bin/bash
# Perform HEALTHCHECK and attempt to reselect source if none available
if chronyc activity | grep '0 sources online'; then
	exit 1
fi
if chronyc -n tracking | grep 'Not synchronised'; then
	exit 2
fi
exit 0
