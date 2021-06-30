defmodule ExChat.Room do
  def login(name) do
    GenServer.call(__MODULE__.Server, {:login, name})
  end

  def logout(name) do
    GenServer.cast(__MODULE__.Server, {:logout, name})
  end

  def post(author, content) do
    GenServer.cast(__MODULE__.Server, {:post, author, content})
  end

  defmodule Server do
    use GenServer

    def start_link(_) do
      GenServer.start_link(__MODULE__, {}, name: __MODULE__)
    end

    @impl GenServer
    def init({}) do
      {:ok, MapSet.new()}
    end

    @impl GenServer
    def handle_call({:login, name}, _, members) do
      for member <- members do
        ExChat.Member.notify_login(member, name)
      end

      members = MapSet.put(members, name)
      {:reply, members, members}
    end

    @impl GenServer
    def handle_cast({:logout, name}, members) do
      members = MapSet.delete(members, name)

      for member <- members do
        ExChat.Member.notify_logout(member, name)
      end

      {:noreply, members}
    end

    @impl GenServer
    def handle_cast({:post, author, content}, members) do
      for member <- members do
        ExChat.Member.notify_post(member, author, content)
      end

      {:noreply, members}
    end
  end
end
