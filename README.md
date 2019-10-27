# Tee Eff Elle

A small robot that tells you when the bus is coming. It runs on a [Raspberry
Pi Zero](https://www.raspberrypi.org/products/raspberry-pi-zero/) and a [Scroll pHat
HD](https://shop.pimoroni.com/products/scroll-phat-hd?variant=38472781450)

## Demo

![](./images/tee_eff_elle.gif)

## Getting Started

You will need to export these env variables:

```
export TFL_APP_ID="secret"
export TFL_APP_KEY="secret"
export NERVES_NETWORK_SSID="secret"
export NERVES_NETWORK_PSK="secret"
```

You can register for an API account at https://api.tfl.gov.uk

Then you can tell the Robot which bus stop you care about and how long does
it take you to get there. Open `config/config.exs` and set `bus_line`,
`bus_stop` and `walking_time_in_minutes` in this section:

```elixir
config :tee_eff_elle,
  target: Mix.target(),
  config: %{
    bus_line: "390",
    bus_stop: "490000008W",
    walking_time_in_minutes: 10,
    tfl_app_id: System.get_env("TFL_APP_ID"),
    tfl_app_key: System.get_env("TFL_APP_KEY")
  }
```

It's time to build your Nerves app:

- `export MIX_TARGET=rpi0`
- Install dependencies with `mix deps.get`
- Create firmware with `mix firmware`
- Burn to an SD card with `mix firmware.burn`

Then you can connect a USB cable to the port marked as "USB" and run:

`ping nerves.local`

Until your Pi starts responding. Then you can connect to it with:

`ssh nerves.local`
