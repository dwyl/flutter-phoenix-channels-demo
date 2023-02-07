# flutter-phoenix-channels-demo
A quick demo app showcasing communication between a Flutter Native App and a Phoenix Backend.

<div align="center">

#  `Flutter` + `Phoenix` Demo

A quick demo showcasing 
the communication between
a Flutter app
and a Phoenix-based backend
**through websockets**.

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dwyl/flutter-phoenix-channels-demo/ci.yml?label=build&style=flat-square&branch=main)
[![HitCount](https://hits.dwyl.com/dwyl/flutter-phoenix-channels-demo.svg?style=flat-square&show=unique)](http://hits.dwyl.com/dwyl/flutter-phoenix-channels-demo)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/flutter-phoenix-channels-demo/issues)


</div>

<br />

# Why? 🤷‍

This SPIKE project is meant for *us*
or anyone that is interested
in connecting a Flutter application
with a backend written in Elixir
and Phoenix.

We want to evaluate the implementation
details of how this process is
with *websockets connections*
between the two parties.

# What? 💭

[`Flutter`](https://flutter.dev/)
is an open-source framework created by Google 
for creating multi-platform, 
high-performance applications from a single codebase. 
It makes it easier for you to build user interfaces 
that works both on web and mobile devices.
To learn more about `Flutter`,
we recommend you checking
[`dwyl/learn-flutter`](https://github.com/dwyl/learn-flutter)

[`Phoenix`](https://www.phoenixframework.org/)
is a web framework for the 
[`Elixir`](https://elixir-lang.org/)
programming language, 
perfect for soft-realtime communication 
with external clients through websockets.
To learn more about Phoenix and Elixir,
we suggest visiting
[`dwyl/learn-phoenix-framework`](https://github.com/dwyl/learn-phoenix-framework)
and
[`dwyl/learn-elixir`](https://github.com/dwyl/learn-elixir)

We will create a simple Flutter app
that will connect to a Phoenix-based backend server
and check who is currently online.

# Who? 👤

This quick demo is aimed at people in the @dwyl team
who need to understand how to communicate 
between `Flutter` apps and `Phoenix`-based servers.

# _How_? 👩‍💻

## Prerequisites? 📝

This demo assumes 
you have some basic knowledge of `Flutter`
and `Phoenix`.

We try to explain everything 
in a beginner-friendly way
but we also want to focus
on the implementation details
of communication between the app
and the `Phoenix` server.

Therefore, 
we recommend giving `learn` repositories
above a read before diving into this demo.

Throughout this tutorial,
you will be basically developing
both the **frontend** and the **backend**.
We *recommend* having separate terminal windows
(or Visual Studio windows)
for each one, 
as you will be running 
the `Phoenix` backend on one
and the `Flutter` client app
on the other.

## I want to run this project! 🏃‍♂️

You might have noticed we have two folders:
- [`app`](./app/), 
pertaining to the `Flutter` application.
- [`backend`](./backend/),
pertaining to the `Phoenix` server
that the client `Flutter` app will connect to.

We recommend you opening *two* 
different terminal windows
(one for each folder)
and follow the instructions
inside each one to run this project
and see it in action!

## 0. Creating basic `Flutter` app

In this section, 
we will be creating 
both the **client** (`Flutter`)
and the **backend** (`Phoenix`).

### 0.1 Creating new `Flutter` app

In the directory of your project,
create a new directory called `app`.
This is where the `Flutter` app will reside in.

```sh
mkdir app
cd app
```

We are going to start this from scratch.
To create a new `Flutter` project
with Visual Studio,
please follow the instructions
in 
https://github.com/dwyl/learn-flutter#0-setting-up-a-new-project.

After creating all the files
and running `flutter pub get`
to fetch all the dependencies,
we are ready to run the app
to test it.

Again, if you check the link above
to start up an emulator 
and run the application.

If you want to run the app
on a real device,
check 
https://github.com/dwyl/flutter-stopwatch-tutorial/tree/33907b1b01760dd49db85fa97fb84ce4562252ae#running-on-a-real-device
to get started.

You should now have a 
simple working counter app.

![starter_app](https://user-images.githubusercontent.com/17494745/200814531-31579684-e6ec-4da4-a504-642eb31fedb9.png)

### 0.2 Creating new `Phoenix` server

Let's now create a brand new `Phoenix`
server so our `Flutter` app can connect.
In the project root, 
create a new folder called `backend`
and enter it.

So:

```sh
cd ..
mkdir backend
cd backend
```

In here, 
run the following command 
to bootstrap a new `Phoenix` project.

```sh
mix phx.new . --app app --no-ecto --no-html --no-gettext --no-dashboard --no-mailer
```

> We are creating a `Phoenix` server
> without any views, dashboards, mail services
> or databases.
> We want a simple, lightweight server
> to create 
> [channels](https://hexdocs.pm/phoenix/channels.html)
> where users will join and leave.

After executing this command,
when prompted to install the dependencies,
enter `Y` to download and install them.

After installing,
simply run `mix phx.server`,
and you should see your server running!

## 1. Creating a room in `Phoenix`

Let's start by creating a 
channel/room for users to join
in the backend.

For this, 
inside the `backend` directory,
where your `Phoenix` project resides,
stop the server (in case you are running it)
and run:

```elixir
mix phx.gen.channel Room
```

Your terminal should yield the following output.

```sh
* creating lib/app_web/channels/room_channel.ex
* creating test/app_web/channels/room_channel_test.exs
* creating test/support/channel_case.ex

The default socket handler - AppWeb.UserSocket - was not found.
Do you want to create it? [Yn]
```

Type `Y` and press `Enter`.
This will create a **user socket handler** for us.
The terminal should now state:

```sh
* creating lib/app_web/channels/user_socket.ex
* creating assets/js/user_socket.js

Add the socket handler to your `lib/app_web/endpoint.ex`, for example:

    socket "/socket", AppWeb.UserSocket,
      websocket: true,
      longpoll: false

For the front-end integration, you need to import the `user_socket.js`
in your `assets/js/app.js` file:

    import "./user_socket.js"
```

Let's follow the first instructions
and add the snippet of code to `endpoint.ex`.
Open `lib/app_web/endpoint.ex` and add:

```elixir
    socket "/socket", AppWeb.UserSocket,
      websocket: true,
      longpoll: false
```

And we're done! 🎉
We've successfully created a 
channel/room that users can join in.
We will be able to do whatever we want
and handle different events
inside `lib/app_web/channels/room_channel.ex`
that we've just now created. 

## 2. Setting up `Flutter` page

Let's go back to `Flutter`.

As it stands, 
we don't want a *counter app*.
We want a simple page
allowing the user to connect
to the room 
and see who's also online.

We want the user to type a username,
connect 
and see the current users.

Let's create a screen for this.
Inside `lib/main.dart`,
locate `_MyHomePageState` class
change it so it looks like the following.

```dart
class _MyHomePageState extends State<MyHomePage> {
  bool connected = false;
  String _username = "";

  onButtonPress() {
    if (_username.isNotEmpty) {
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        child: TextFormField(
                      onChanged: (value) => setState(() {
                        _username = value;
                      }),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your username',
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: ElevatedButton(
                        onPressed: _username.isEmpty ? null : onButtonPress,
                        child: const Text('Connect'),
                      ),
                    )
                  ],
                )),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: connected
                  ? const Text(
                      'Connected',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(238, 56, 231, 94)),
                    )
                  : const Text(
                      'Disconnected',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(239, 255, 48, 48)),
                    )),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: const Center(child: Text('Entry A')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry B')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[100],
                  child: const Center(child: Text('Entry C')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

Additionally, 
locate the `MyApp` class
and change the title, like so.

```dart
      home: const MyHomePage(title: 'Who\'s online?'),
```

We've created a simple page
with a `ListView`
that will show the list of users 
connected.
For now, 
we are just adding `Container`s
with sample data.

The button to connect
should be disabled
if the username is empty.

Connection status is shown 
with a `Textfield` 
informing the user if he/she is connected or not.

Both the `username` and `connection` status
are part of the state of the page,
which will dynamically change
according to the user actions
(changing the username
and connection to the Phoenix
channel, respectively).

When the button is pressed,
the `onButtonPress()` callback function
is called.
For now, it doesn't do anything.
But will later connect to the Phoenix server.

The app should have the following layout.

![basic_layout](https://user-images.githubusercontent.com/17494745/217049291-d5ccbe95-16e9-4f83-b2fe-c930b6cee9a8.png)

## 3. Tracking users in `Phoenix` server

As it stands, `Phoenix`
doesn't really have a way of knowing 
*which* and *how many* users/processes
are connected to the channel.

Tracking these processes is necessary
to know *who is online*
so we can display the username to the user in `Flutter`.

Luckily for us, `Phoenix`
has a module called 
[**`Presence`**](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
that makes is easy to track processes and channels.

This behaviour module makes it possible
to handle differences of "join" and "leave" events
*in real-time*.

Let's add `Presence` to our `Phoenix` server.
Create a file called `presence.ex`
in `lib/app_web`
and paste the following code.

```elixir
defmodule AppWeb.Presence do
  use Phoenix.Presence,
    otp_app: :app,
    pubsub_server: App.PubSub
end
```

We are defining a presence module
within our application
and providing the `:otp_app`
with the `:app` configuration
that is defined in `mix.exs`,
as well as `pubsub_server`,
which exists by default in `Phoenix` applications.

Next, let's add a new 
[**supervisor**](https://elixir-lang.org/getting-started/mix-otp/supervisor-and-application.html#our-first-supervisor)
to the the supervision tree
in `lib/app/application.ex`.

> :note: It **must** be added *after*
> the `PubSub` child and *before* the endpoint.

```elixir
    children = [
    # Start the Telemetry supervisor
    AppWeb.Telemetry,
    # Start the PubSub system
    {Phoenix.PubSub, name: App.PubSub},
    # Start the Endpoint (http/https)
    AppWeb.Presence,
    AppWeb.Endpoint
    # Start a worker by calling: App.Worker.start_link(arg)
    # {App.Worker, arg}
  ]
```

And that's it!
We've just *configured* `Presence`.
Now it's time to *use it*!

### 3.1 Tracking users 

For each process 
we are going to be tracking with `Presence`, 
we want to add **metadata** 
to show in the `Flutter` client.

One of these is the **`user_id`**.
For this, we will use 
[`UUID`](https://hexdocs.pm/uuid/readme.html)
to generate unique 
[UUIDs](https://en.wikipedia.org/wiki/Universally_unique_identifier).

To install it,
add the following line 
in the `deps` section in `mix.exs`.

```elixir
{:uuid, "~> 1.1" }
```

And run `mix deps.get` to fetch the dependencies.

After installing this,
change `lib/app_web/channels/room_channel.ex`
to the following code.

```elixir
defmodule AppWeb.RoomChannel do
  use AppWeb, :channel
  alias AppWeb.Presence

  @impl true
  def join("room:lobby", payload, socket) do
    username = Map.get(payload, "username", "")
    user_id = UUID.uuid1()

    send(self(), :after_join)
    {:ok, assign(socket, %{username: username, user_id: user_id})}
  end

  @impl true
  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      username: socket.assigns.username,
      online_at: inspect(System.system_time(:millisecond))
    })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end
```

Let's break it down. 🧱

Inside the `join/3` function
(that is called whenever a user joins the channel),
we get the username of the user
that is passed through the parameters
and generate an UUID for the user.
We assign *both of these to the socket assigns*.

Inside this function,
the user is deferred to `:after_join`,
which is handled in 
`handle_info(:after_join, socket)`.

In this function,
we *track the process* by calling
`Presence.track/3`,
where we add metadata (username and time it was online)
to the process with the UUID we created prior.

We then *push* this 
presence information
to the client
as a `"presence_state"` event.

This metadata will be shown
in the `Flutter` client app.

And that's it! 👏
The only thing that's left 
is to connect the `Flutter` app
to our `Phoenix` server
and communicate with it!

## 4. Connect `Flutter` to `Phoenix`
