# `Phoenix` Backend

Welcome to the `Phoenix` backend server!


# Pre-requisites 📝

To run this backend, 
you need to install:
- [`Elixir`](https://elixir-lang.org/install.html)
- [`Phoenix Framework`](https://hexdocs.pm/phoenix/installation.html)

Click on each link to find out 
how to install both of these
so you can run this backend locally!

# Run it! 🏃‍♂️

If this is your first time using it,
follow the next two steps.

  * Run `mix setup` to install and setup dependencies.
  * Start Phoenix endpoint with `mix phx.server`.

Your backend should be up and running
on `localhost:4000`!

# Deploying 📦

We can easily deploy our Phoenix 
to [`Fly.io`](https://fly.io/)
by following their guide.

https://fly.io/docs/elixir/getting-started/

Assuming you have `flyctl` CLI installed,
inside this folder,
you can now run the following command.

```sh
flyctl launch
```

The terminal should yield the following output.

```sh
An existing fly.toml file was found for app flutter-phoenix-channels-backend
? Would you like to copy its configuration to the new app? (y/N) 
```

Type `Y` and press `Enter`.
This will install all the dependencies
and prepare the application for deployment.

After a few moments, 
`flyctl` will detect the application is a `Phoenix` app
and will ask you to choose an app name.

```sh
Detected a Phoenix app
? Choose an app name (leave blank to generate one): 
```

This will be the name of the deployed application
on `fly.io` and will affect the URL in which it will be deployed.

If you want to restrict 
*only the frontend app* to be able to connect to our Phoenix server,
you can do so in the `config/prod.exs` file.
In this file, you can change the `:app` config like so.

```elixir
config :app, AppWeb.Endpoint,
 server: true,
 cache_static_manifest: "priv/static/cache_manifest.json",
 check_origin: [
   "https://flutter-phoenix-channels-frontend.fly.dev", # must be the same URL domain of the frontend app.
 ]
```

You can also disable this behaviour 
by setting `check_origin` to `false`.
You can learn more about this in the Phoenix's docs.

https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#module-runtime-configuration

For now, we are going to be 
using `flutter-phoenix-channels-frontend` as the app name.
Type it into the terminal.

After this, 
it will ask you to select the organization 
the application will be deployed into.

```sh
? Select Organization: <select your org>
```

After this, 
the terminal will ask you to choose a region for deployment.
Choose the one closest to you for better latency results.

```sh
? Choose a region for deployment: <region to select>
```

After selecting the region,
you will be prompted the following question.

```sh
? Would you like to set up a Postgresql database now? (y/N) 
```

Type `N`, as we don't need a Postgresql database.

After this, the terminal will ask you
if you want to setup a Redis database.

```sh
? Would you like to set up an Upstash Redis database now? (y/N) 
```

Similarly, type `N`, since we don't need it.
The terminal should yield the following output now.


```sh
Preparing system for Elixir builds
Installing application dependencies
Running Docker release generator
Wrote config file fly.toml
? Would you like to deploy now? (y/N) 
```

If you wish to deploy the application now,
type `y` and press `Enter`.

This will build the image
and deploy the application to `fly.io`.
This might take some minutes, so hang on tight! 👍

After the process is complete,
the terminal should state:

```sh

 1 desired, 1 placed, 1 healthy, 0 unhealthy [health checks: 1 total, 1 passing]
--> v0 deployed successfully
```

That means we've correctly deployed it! 🎉

If you want to check the deployed app,
visit `fly.io`,
log into your account 
and search for it.
Or alternatively, type `fly open`
and a browser window should open with the deployed app!

## Re-deploying

Everytime you make a change 
and want to redeploy the application,
just run `fly deploy`.
Since we've already done the initial configuration needed,
`fly deploy` will just re-build the app
and deploy it to the app that's already deployed.