defmodule AppWeb.RoomChannelTest do
  use AppWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      AppWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(AppWeb.RoomChannel, "room:lobby")

    %{socket: socket}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end
end
