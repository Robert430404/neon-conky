# Neon Conky Config

This is a conky configuration that gives you access to recent news, weather, and basic
system stats.

![Screenshot Of Config](./screenshot.png)

# Getting Started

To get started clone this repository to `~/.conky` and follow the rest of this README.

## Dependencies

This config depends on the following programs:

- jq
- awk
- conky
- sed
- bash
- curl
- date

Make sure these are installed for your distribution.

### Debian/Ubuntu Example

```BASH
sudo apt install jq gawk conky sed bash curl date
```

## Additional Configuration

Once you have the system dependencies installed you need to setup your `config.sh`.
Copy `config.example.sh` to `config.sh` and adjust the variables to your liking.

To get your news API key, you should go to [newsapi.org](https://newsapi.org/) and
register for an account. From there generate your API key and place it in `config.sh`.

To get your weather API key, you should go to
[openweathermap.org](https://openweathermap.org/) and register for an account. From
there generate your API key and place it in `config.sh`.

After you've setup the config, copy the `.conkyrc` file from this repo to your home
directory and restart conky.

```BASH
##
# This command backs up your old conky rc, installs the new one, and restarts conky.
##
mv ~/.conkyrc ~/.conkyrc.old \
  && cp ./.conkyrc ~/.conkyrc \
  && killall conky \
  && conky
```
