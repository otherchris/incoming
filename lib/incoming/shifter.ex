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
    Process.send(self(), :shift, [])
    {:ok, %{}}
  end

  def handle_info(:shift, state) do
    now =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> Map.put(:second, 0)

    {:ok, start_shifts} = Shift.get_by_start(now)
    {:ok, stop_shifts} = Shift.get_by_stop(now)

    start_phones =
      start_shifts
      |> Enum.map(&Map.get(&1, :phone))

    stop_phones =
      stop_shifts
      |> Enum.map(&Map.get(&1, :phone))

    IO.inspect(
      "adding #{start_phones} and removing #{stop_phones} at #{
        DateTime.utc_now() |> DateTime.to_string()
      }"
    )

    d = Process.whereis(:dialer)

    start_phones
    |> Enum.each(&IncomingDialer.add_incoming_number(d, &1))

    stop_phones
    |> Enum.each(&IncomingDialer.remove_incoming_number(d, &1))

    Process.send_after(self(), :shift, 60_000, [])

    {:noreply, state}
  end
end
