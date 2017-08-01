PROJ ?= test
MDNS_HOSTNAME ?= nginx
DOMAIN ?= $(MDNS_HOSTNAME).local

COMP ?= docker-compose -p $(PROJ)
CUT ?= cut
DOCKER ?= docker
GREP ?= grep
JQ ?= jq
PING ?= ping
SED ?= sed

define get_ip
$(shell $(DOCKER) inspect \
	$(shell $(DOCKER) ps | $(GREP) $(PROJ) | $(CUT) -d' ' -f1) \
	| $(JQ) '.[].NetworkSettings.Networks.bridge.IPAddress' \
	| $(SED) 's/"//g')
endef

all:
	# mDNS/DNS-SD Docker prototype
	#
	# start        Start the docker container
	# test         Test the mDNS lookup
	# stop         Stop the docker container
	#
	# shell        Start an interactive shell session for testing
	#
	# clean        Clean the built docker image
	#
	# --
	#
	# Environment variables:
	#
	#   MDNS_HOSTNAME   You can change the hostname with this.
	#                   The .local suffix will automatically added.
	#                   Default: nginx -- Use like this:
	#
	#                     MDNS_HOSTNAME=test make start
	#                     MDNS_HOSTNAME=test make test

start: stop clean
	# Start the nginx container (port 80 listening)
	@$(COMP) up --build web

stop:
	# Stop the nginx container
	@$(COMP) kill

shell:
	# Start an interactive shell session for tests
	@$(COMP) run web bash

clean:
	# Clean the nginx image
	@$(COMP) rm -f

test:
	# Test the IP/mDNS setup
	#
	# > Container ip: $(call get_ip)
	#
	# DNS resolution test ($(DOMAIN)):
	@$(PING) -c4 $(DOMAIN)
	#
	# Test was successful. Yay.
