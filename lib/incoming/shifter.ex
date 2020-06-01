defmodule Incoming.Shifter do
  @moduledoc false

  use GenServer

  alias Incoming.Shift

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
    IO.inspect "tick"
    Process.send_after(self(), :tick, 5000, [])
    {:noreply, state}
  end

  def handle_info(:shift, state) do
    {start, delay} = time_and_delay()
    {:ok, shifts} = Shift.get_by_start(start)
    phones 
    |> Enum.map(&Map.get(&1, :user_id))
    |> Enum.map(&User.get_user(&1))
    |> Enum.map(%Map.get(&1, :phone)) 
    Process.send_after(self(), {:numbers, phones}, delay, [])
    Process.send_after(self(), :shift, 30 * 60 * 60 * 1000)
    {:noreply, state}
  end

  defp time_and_delay do
    now = DateTime.utc_now
    next = DateTime.utc_now
    if now.minute > 30 do
      next.minute = 0
      next.hour = DateTime.add(now, 60 * 60, :second).hour 
    else
      next.minute = 30
    end
    next = DateTime.truncate(next, :second)
    delta = DateTime.diif(next, now, :millisecond)
    {next, delta}
  end
end