defmodule Incoming.Shifter do
  @moduledoc false

  use GenServer
  require Logger

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

  @impl true
  def handle_info(:tick, state) do
    next =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> Map.put(:second, 0)
    if DateTime.diff(DateTime.utc_now, next) > 50 do
      Process.send(self(), {:shift, DateTime.add(next, 60, :second)}, [])
    end
    Process.send_after(self(), :tick, 6000, [])
    {:noreply, state}
  end

  @impl true
  def handle_info({:shift, now}, state) do
    Logger.info("Processing shifts for #{now} at #{DateTime.utc_now()}")
    {:ok, start_shifts} = Shift.get_by_start(now)
    {:ok, stop_shifts} = Shift.get_by_stop(now)

    start_phones =
      start_shifts
      |> Enum.map(&Map.get(&1, :phone))

    stop_phones =
      stop_shifts
      |> Enum.map(&Map.get(&1, :phone))

    d = Process.whereis(:dialer)

    start_phones
    |> Enum.each(&IncomingDialer.add_incoming_number(d, &1))

    stop_phones
    |> Enum.each(&IncomingDialer.remove_incoming_number(d, &1))

    Logger.info("Phones added: #{start_phones}, Phones removed: #{stop_phones}")

    {:noreply, state}
  end
end
