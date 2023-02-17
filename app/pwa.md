<div align="center">

# Enhancing our `PWA` 👩‍💻 

This is a small document
that will guide you 
to enhance the `Flutter` app,
making it a *better* `PWA` for selected platforms,
and provide the person using it
with a better experience!

</div>

- [Enhancing our `PWA` 👩‍💻](#enhancing-our-pwa-)
- [Checking the current `PWA` of the app](#checking-the-current-pwa-of-the-app)
- [Changing the icon](#changing-the-icon)
- [Setting the name of the app](#setting-the-name-of-the-app)
- [Let's see the final result! ✨](#lets-see-the-final-result-)

# Checking the current `PWA` of the app

After you've deployed your application to the web,
you will be able to download it as a `PWA`.

If you want to check this out,
you can check the deployed app in
https://flutter-phoenix-channels-frontend.fly.dev/.

To install the `PWA`,
you need to click on the icon 
in the URL bar, 
as detailed below.

<img width="1042" alt="install_pwa" src="https://user-images.githubusercontent.com/194400/219610450-17f3ed51-8587-4126-84e3-7b7f497246e5.png">

If you click on `Install`,
you will notice that
(assuming you're using Google Chrome),
the app will be installed 
as a `"Chrome App"`.

<img width="811" alt="chrome_app" src="https://user-images.githubusercontent.com/194400/219611308-552a8ac7-c232-48d1-947f-350d49bf7649.png">

And now the app is accessible
as it was a *native application*.
It has its own window.

<img width="755" alt="pwa_fullscreen" src="https://user-images.githubusercontent.com/194400/219610649-46a154d8-9506-43b8-95b2-37a4cca6d8fd.png">

And can be accessed as it was a normal app
in your computer.

<img width="876" alt="normal_app" src="https://user-images.githubusercontent.com/194400/219611210-23568c9d-8eda-47c5-86d5-01c4fd3b78a0.png">


*However*,
it's using `Flutter`'s default configurations.
It doesn't have a custom image,
its own app name and it's missing some information.
**This is what we are going to be addressing in this guide**.

Let's do it together! 🤝


# Changing the icon

Changing the icon of your Flutter app
can be a *cumbersome process*,
as we would need to *manually* change the favicon
for each platform.

This is not scalable.
Hence why we are going to be using the
[`flutter_launcher_icons`](https://github.com/fluttercommunity/flutter_launcher_icons/)
package to make this process **much easier**.

For this, we need to do some setup.
In the `pubspec.yaml` file,
add the following line 
in the `dev_dependencies` section,
to install `flutter_launcher_icons`.

```yml
dev_dependencies:
  flutter_launcher_icons: "^0.11.0"
```

In the same file,
add the following code at the end of it.


```yml
flutter_icons:
  image_path: "assets/icon/icon.png"
  android: true
  ios: true
  web:
    generate: true
  windows:
    generate: true
  macos:
    generate: true
```

We are setting the 
*path* to the icon image
we want to be used 
in the different platforms.

We are able to define many aspects
of the icon,
including the `background_color`,
the `theme_color`,
its size,
and customize it according to each platform.

You can find a more comprehensive list 
of possible configurations in 
https://github.com/fluttercommunity/flutter_launcher_icons/#mag-attributes.

You might have noticed we have used
the path `assets/icon/icon.png`.
We need to create it 
and add the `icon.png` file 
so this tool can generate the icons
for each platform properly.

After creating the directory,
you can use the image
in [`assets/icon/icon.png`](assets/icon/icon.png),
if you want to.

After this,
simply run the following command.

```sh
flutter pub run flutter_launcher_icons
```

The terminal will output 
this information:

```sh
ase) lucho@Luiss-MBP app % flutter pub run flutter_launcher_icons
  ════════════════════════════════════════════
     FLUTTER LAUNCHER ICONS (v0.11.0)                               
  ════════════════════════════════════════════
  
• Creating default icons Android
• Adding a new Android launcher icon

WARNING: Icons with alpha channel are not allowed in the Apple App Store.
Set "remove_alpha_ios: true" to remove it.

• Overwriting default iOS launcher icon with new icon
Creating Icons for Web...
Creating Icons for Windows...
Creating Icons for MacOS...

✓ Successfully generated launcher icons
```

Awesome! 🎨

We've now created icons for all the chosen platforms!
And quite fast, might I add! 😉


# Setting the name of the app

In the 
[Checking the current `PWA` of the app](#checking-the-current-pwa-of-the-app)
section of this document,
you might have noticed that,
when installing the PWA,
the person sees the `Flutter` logo
and `"app"` in the pop-up window.

We should change this to something more meaningful.
`PWA`s, how they're installed and how they look when installing,
abide by the rules stated in a file called 
[`manifest.json`](https://web.dev/add-manifest/).
This file has a list of attributes
that can be tweaked.

You can find this file in
`web/manifest.json`.
Open it and change the following attributes,
leaving the others intact:

- `name`, which is the primary identifier of the `PWA` extension.
It will be displayed in the **install dialog**,
**extension management UI**
and in the **Chrome Web Store**.
- `short_name`, which is a short version of the `name`.
It's entirely optional but it will show when 
there's insufficient space to display the `name`.
- `description`, which is a simple explanation of what the app does.

```json
{
    "name": "Flutter & Phoenix Channels",
    "short_name": "flutter_n_phoenix",
    "start_url": ".",
    "display": "standalone",
    "background_color": "#FFFFFF",
    "theme_color": "#FFFFFF",
    "description": "A simple application where you can connect to a Phoenix server through websockets.",
    "orientation": "portrait-primary",
    "prefer_related_applications": false,
    "icons": [
        {
            "src": "icons/Icon-192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-512.png",
            "sizes": "512x512",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-maskable-192.png",
            "sizes": "192x192",
            "type": "image/png",
            "purpose": "maskable"
        },
        {
            "src": "icons/Icon-maskable-512.png",
            "sizes": "512x512",
            "type": "image/png",
            "purpose": "maskable"
        }
    ]
}
```

While we're at it,
we can make the title of the tab in Chrome
more meaningful, as well.

Instead of it being titled `"Flutter Demo"`,
let's change it to `"Flutter & Phoenix Channels"`.

To do this,
simply open `lib/main.dart`,
locate the `MaterialApp`,
in the `build()` function of `MyApp` class,
and change it to the following.

```dart
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & Phoenix Channels',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Who\'s online?'),
    );
  }
```

And you're done!

# Let's see the final result! ✨

We've made a few changes.
Let's see them in action!

If we *rebuild and create a new release bundle*,
like so:

```sh
flutter build web --dart-define=SERVER_URL=wss://flutter-phoenix-channels-backend.fly.dev/socket/websocket --dart-define=CHANNEL_NAME=room:lobby
```

> **Note** 
>
> This will create a release bundle for the web
> in `build/web`.
> We are pointing this app release
> to the `Phoenix` server that is deployed in
> `wss://flutter-phoenix-channels-backend.fly.dev/socket/websocket`
> so you don't have to start the `Phoenix` server on your own. 

After this process is complete,
we can navigate into the directory
and start a simple server to 
*serve* these static files 
to our `localhost`.

```sh
cd build/web
python -m http.server 8000
```

This assumes you have 
[`Python`](https://www.python.org/)
installed.
We are running this on port `8000`.

Alternatively, 
you can deploy this to your account on `fly.io`.
Check the [`README.md`](../README.md) for more information.

After running this command,
the app we've just updated should be accesible
in [`localhost:8000`](http://localhost:8000/).

<img width="815" alt="image" src="https://user-images.githubusercontent.com/17494745/219745329-e37596ce-4934-49bd-b7e0-11329c375f3d.png">

You will notice that the 
*favicon* of the app has changed,
as well as the title!

If you try to install the `PWA`,
you will notice that the new logo is being shown,
as well as the name we've defined in the `manifest.json` file!

Congratulations! 🎉
We've made the process of installing our `PWA`
much prettier 🎨
and meaningful! ✍️
