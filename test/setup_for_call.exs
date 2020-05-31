pid = Process.whereis(:dialer)
IncomingDialer.set_incoming_numbers(pid, ["5029097551"])
:sys.get_state(pid) |> IO.inspect