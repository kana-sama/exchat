defmodule ExChat.Member.Registry do
  def child_spec(_) do
    Registry.child_spec(keys: :duplicate, name: __MODULE__)
  end

  def register(name) do
    Registry.register(__MODULE__, name, {})
  end

  def dispatch(name, f) do
    Registry.dispatch(__MODULE__, name, fn entries ->
      for {pid, _} <- entries do
        f.(pid)
      end
    end)
  end
end
