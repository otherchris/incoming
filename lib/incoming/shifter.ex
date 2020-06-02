defmodule Incoming.Shifter do
  @moduledoc false

  use GenServer

  alias Incoming.Now
  alias Incoming.Shift
  alias Incoming.User

  # Client API

  def start_link(initial, opts) do
    GenServer.start_link(__MODULE__, initial, opts)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end


  # Server callbacks

  @impl true
  def init(:ok) do
    Process.send(self(), :tick, [])
    {:ok, %{}}
  end

  def handle_info(:tick, state) do
    if rem(Now.utc_now.minute, 30) == 0 do
      GenServer.cast(self(), :shift)
    end
    Process.send_after(self(), :tick, 60 * 1000, [])
    {:noreply, state}
  end

  def handle_cast(:shift, state) do
    start = 
      Now.utc_now()
      |> DateTime.truncate(:second)
      |> Map.put(:second, 0)
    {:ok, shifts} = Shift.get_by_start(start)
    phones = 
      shifts
      |> Enum.map(&Map.get(&1, :user_id))
      |> Enum.map(&User.get_user(&1))
      |> Enum.map(&Map.get(&1, :phone)) 
    IO.inspect "applying new numbers at #{DateTime.utc_now() |> DateTime.to_string()}"
    pid = Process.whereis(:dialer)
    IncomingDialer.set_incoming_numbers(pid, phones)
    {:noreply, state}
  end
end