#!/bin/bash

# Path to the chef-client executable
CHEF_CLIENT="/usr/bin/chef-client"

# Path to the Chef recipe
CHEF_RECIPE="/chef-repo/cookbooks/firstcookbook/recipes/default.rb"

# Log file to capture chef-client output
LOG_FILE="/var/log/chef_cron.log"

# Run chef-client with the specified recipe
$CHEF_CLIENT -z $CHEF_RECIPE >> $LOG_FILE 2>&1
