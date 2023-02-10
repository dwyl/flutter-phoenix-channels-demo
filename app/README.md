# `Flutter` application

Welcome to the `Flutter` client app!

This app will *connect*
to a `Phoenix` server.
You need to run it first
in the [`./backend`](../backend/)
folder.

# Pre-requisites 📝

To run Flutter,
whether it's on a real device
or on an emulator,
you need to have the 
**`Flutter SDK`** installed, 
along with `XCode`
and `Android Studio`.

This process can take some time.
Therefore, we've already created a guide for you
to help you get through it
and start "fluttering" 🦋
ASAP!

https://github.com/dwyl/learn-flutter#install-%EF%B8%8F


# Run it! 🏃‍♂️

If you want to run 
this project on an emulator,
follow the steps found in
https://github.com/dwyl/learn-flutter#0-setting-up-a-new-project.

If you are keen on running this
on your own device,
please visit
https://github.com/dwyl/flutter-stopwatch-tutorial/tree/33907b1b01760dd49db85fa97fb84ce4562252ae#giving-it-a-whirl-.

If you've followed the steps correctly
for your own device or emulator,
you should have the `Flutter` app
properly running!


# Deploying 📦

To deploy this app for any platform
and connect to a `Phoenix` server
that is not running on `localhost`,
you can change the `SERVER_URL`
and `CHANNEL_NAME` env variables
when creating the
[bundle](https://docs.flutter.dev/deployment/web)
by defining them
in the `--dart-define` argument.

```sh
flutter build web --dart-define=SERVER_URL=ws://localhost:4000/socket/websocket --dart-define=CHANNEL_NAME=room:lobby  
```

When running this command,
a `build` folder will be created
with the release bundle
that can be used to be deployed
in your preferred provider.

Change the `SERVER_URL` 
env variable
according to the URL
the `Phoenix` server is deployed in.

> **Note** Remember,
> the `Flutter` app will connect
> to a websocket channel.
> `Fly.io` will deploy with `HTTPS` certificate,
> so `SERVER_URL`
> should be something like
> `wss://flutter-phoenix-channels-backend.fly.dev/socket/websocket`.
> Notice we are using `wss` instead of `ws`.
> `wss` is to `https` what `ws` is to `http`.
> It's a more secure communication protocol.

To deploy this `PWA` to `fly.io`,
follow the instructions
in [`backend/README.md`](../backend/README.md)
to use the `flyctl` CLI.