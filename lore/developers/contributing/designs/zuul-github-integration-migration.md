---
name: zuul github integration migration
layout: default
---

# Zuul Github Integration Migration

## Problem Statement

We need to migrate our Zuul instal to using the github integration engine to authenticate with and interact with the Github API. This will cause disruption to our consumers, and will need to be planned out and communicated.

## Overview

Zuul (with our patches) can interact with Github either through a human's API key, or as a bot via an [Integration](https://developer.github.com/early-access/integrations/). We started our deployment using an API key, which requires every consumer to grant our user (anne-bonny) rights within their project. An Integration allows consumers to simply "install" our integration for the projects they wish to use with us, and our integration will be granted the appropriate rights. This is a far smoother experience for consumers.

Unfortunately, the transition from API key to Integration is not easily automatable. We've decided to make the switch and guide our consumers through removing access for the [anne-bonny](https://github.com/anne-bonny) and replacing it with an install of our Integration. This document is meant to outline the process and timeline for accomplishing the cut over.

### Timeline

Add text here for a timeline

### Zuul restart

A restart of zuul is necessary to load the configuration to use the Integration, as well as to pick up some recent code changes.

Add text here about performing the restart.

### Integration Installation

All of our consumers (list?) will need to install the integration. Need some docs here on how to perform that installation.

### Webhook and permission removal

This step can be done after the integration is installed for a given consumer. It is not strictly necessary, but it is strongly encouraged.

Remove the anny-bonny account permissions
Delete the webhook configuration
