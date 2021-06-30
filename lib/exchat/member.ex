defmodule ExChat.Member do
  def notify_login(member, logined_name) do
    send_json(member, %{login: logined_name})
  end

  def notify_logout(member, logouted_name) do
    send_json(member, %{logout: logouted_name})
  end

  def notify_post(member, author, content) do
    send_json(member, %{author: author, content: content})
  end

  defp send_json(member, value) do
    ExChat.Member.Registry.dispatch(member, fn pid ->
      send(pid, {:send_json, value})
    end)
  end

  defmodule Handler do
    @behaviour :cowboy_websocket

    @impl :cowboy_websocket
    def init(request, _) do
      %{:name => name} = :cowboy_req.match_qs([:name], request)
      {:cowboy_websocket, request, name, %{:idle_timeout => 60_000 * 30}}
    end

    @impl :cowboy_websocket
    def websocket_init(name) do
      ExChat.Member.Registry.register(name)
      members = ExChat.Room.login(name)
      {[{:text, Poison.encode!(%{members: members})}], name}
    end

    @impl :cowboy_websocket
    def websocket_handle({:text, message}, name) do
      ExChat.Room.post(name, message)
      {[], name}
    end

    @impl :cowboy_websocket
    def websocket_info({:send_json, value}, name) do
      {[{:text, Poison.encode!(value)}], name}
    end

    @impl :cowboy_websocket
    def terminate(_, _, name) do
      ExChat.Room.logout(name)
    end
  end
end
