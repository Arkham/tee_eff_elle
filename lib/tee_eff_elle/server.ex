defmodule TeeEffElle.Server do
  @moduledoc false

  @boot_delay 1_000
  @update_interval 60_000
  @render_interval 500

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    Process.send_after(self(), :update_times, @boot_delay)
    Process.send_after(self(), :display_times, @boot_delay)
    {:ok, %{last_times: []}}
  end

  @impl true
  def handle_info(:update_times, _state) do
    times = TeeEffElle.Times.get_feasible_times()
    Process.send_after(self(), :update_times, @update_interval)
    {:noreply, %{last_times: times}}
  end

  @impl true
  def handle_info(:display_times, state) do
    scroll_times(state.last_times)
    Process.send_after(self(), :display_times, @render_interval)
    {:noreply, state}
  end

  @impl true
  def handle_info(message, state) do
    IO.puts("Received message #{inspect(message)}")
    {:noreply, state}
  end

  defp scroll_times([]), do: :ok

  defp scroll_times(times) do
    times
    |> TeeEffElle.Times.display_times()
    |> ScrollPhatHdEx.Server.scroll_string()
  end
end
