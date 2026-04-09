# AutoPrint

## Overview

AutoPrint is a simple .NET Core utility to help keep your inkjet printer's print heads from getting clogged.

AutoPrint will print to the default printer.

## Requirements

### Windows

This should run on a stock Windows install.

### macOS

`libgdiplus` from the Mono project is required. Install using `brew install mono-libgdiplus`.

### Linux

`libgdiplus` from the Mono project is required. Install on most distros with `sudo apt-get install libgdiplus`.

## Basic Usage

Checkout, build & run using standard .NET Core commands:

- `git clone https://github.com/willson556/autoprint.git`
- `cd autoprint`
- `dotnet run`

Schedule using Cron, Systemd, Windows Task Scheduler. Place the paper back into the printer between each scheduled run until it's full.

## Docker

The provided docker image bundles CUPS and cron. Replace the provided URI with your printer's IPP (or some other CUPS-compatible) URI.

### Environment Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `PRINTER_URI` | Yes | — | Your printer's IPP (or CUPS-compatible) URI |
| `TZ` | No | `UTC` | Timezone for the cron schedule |
| `PRINT_INTERVAL` | No | `2` | Days between prints (e.g. `1` = daily, `7` = weekly) |
| `PRINT_TIME` | No | `08:00` | Time to print in 24h `HH:MM` format |

### Docker Compose

```yaml
services:
  autoprint:
    container_name: autoprint
    image: sc-frederick/autoprint
    restart: unless-stopped
    environment:
      - TZ=America/New_York
      - PRINTER_URI=https://192.168.1.138:631/ipp/print
      - PRINT_INTERVAL=2
      - PRINT_TIME=08:00
```

### Docker Run

```sh
docker run -d \
           --name autoprint \
           -e TZ=America/New_York \
           -e PRINTER_URI=https://192.168.1.138:631/ipp/print \
           -e PRINT_INTERVAL=2 \
           -e PRINT_TIME=08:00 \
           sc-frederick/autoprint
```

## References

- https://www.codeproject.com/Articles/32239/Keep-Your-InkJet-Print-Head-Clean
- https://github.com/hyettdotme/dotnetcron
