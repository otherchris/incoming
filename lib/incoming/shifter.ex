defmodule Incoming.Shifter do
  @moduledoc false

  use GenServer

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
    Process.send(self(), :shift, [])
    {:ok, %{}}
  end

  def handle_info(:shift, state) do
    {start, delay} = time_and_delay()
    {:ok, shifts} = Shift.get_by_start(start)
    phones = 
      shifts
      |> Enum.map(&Map.get(&1, :user_id))
      |> Enum.map(&User.get_user(&1))
      |> Enum.map(&Map.get(&1, :phone)) 
    Process.send_after(self(), {:numbers, phones}, 5, [])
    Process.send_after(self(), :shift, 30 * 60 * 60 * 1000)
    {:noreply, state}
  end

  def handle_info({:numbers, phones}, state) do
    IO.inspect "applying new numbers at #{DateTime.utc_now() |> DateTime.to_string()}"
    pid = Process.whereis(:dialer)
    IncomingDialer.set_incoming_numbers(pid, phones)
    {:noreply, state}
  end

  defp time_and_delay do
    now = DateTime.utc_now
    next = DateTime.utc_now
    next = 
      if now.minute > 30 do
        next
        |> Map.put(:second, 0)
        |> Map.put(:minute, 0)
        |> Map.put(:hour, DateTime.add(now, 60 * 60, :second).hour)
      else
        Map.put(next, :minute, 30)
      end
    next = DateTime.truncate(next, :second)
    delta = DateTime.diff(next, now, :millisecond)
    {next, delta}
  end
end