defmodule AppWeb.RoomChannel do
  use AppWeb, :channel
  alias AppWeb.Presence

  @impl true
  def join("room:lobby", payload, socket) do
    username = Map.get(payload, "username", "")
    user_id = UUID.uuid1()

    # Sending the process to `:after_join` function
    # and adding `username` and `user_id` to socket
    send(self(), :after_join)
    {:ok, assign(socket, %{username: username, user_id: user_id})}
  end

  @impl true
  def handle_info(:after_join, socket) do

    # Track user with Presence
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      username: socket.assigns.username,
      online_at: inspect(System.system_time(:millisecond))
    })

    # The current presence information for the socket's topic is pushed to the client as a "presence_state" event.
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end
