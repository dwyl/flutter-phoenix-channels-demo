defmodule AppWeb.Presence do
  use Phoenix.Presence,
    otp_app: :my_app,
    pubsub_server: App.PubSub
end
