# lita-phraseapp

A lita plugin for interacting with phraseapp.com, a translation management app.

## Installation

Add this gem to your lita installation by including the following line in your Gemfile:

    gem "lita-phraseapp"

## Configuration

An API key is required to interact with the phraseapp API. To set it, add the following line
to your lita\_config.rb:

    config.handlers.phraseapp.api_key = "your-key"

## Externally triggered events

This handler can phraseapp events and trigger a variety of activities as appropriate. To
get started, use the phraseapp web interface to configure a webhook that POSTs events to:

    http://your-lita-bot.com/phraseapp

### Locale Stats

To print a summary of locale stats to a channel each time a file is uploaded to a project,
edit your lita\_config.rb to include the following line.

    config.handlers.phraseapp_stats.channel_name = "channel-name"

## Chat commands

This handler provides no additional chat commands. Yet.

## TODO

Possible ideas for new features, either via chat commands or externally triggered events:

* more specs
