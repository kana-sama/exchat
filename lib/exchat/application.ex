defmodule ExChat.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExChat.Member.Registry,
      ExChat.Room.Server,
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: ExChat.Router,
        options: [dispatch: dispatch(), port: 8081]
      )
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ExChat.Supervisor)
  end

  defp dispatch() do
    [
      {:_,
       [
         {"/ws", ExChat.Member.Handler, {}},
         {"/", :cowboy_static, {:priv_file, :exchat, "/index.html"}},
         {"/[...]", :cowboy_static, {:priv_dir, :exchat, "/"}}
       ]}
    ]
  end
end
