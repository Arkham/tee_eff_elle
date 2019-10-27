defmodule TeeEffElle.Times do
  def get_feasible_times() do
    config = TeeEffElle.Application.config()

    TeeEffElle.ApiClient.get_bus_times(config)
    |> Enum.reduce(feasible(config.walking_time_in_minutes))
    |> Enum.uniq()
    |> Enum.sort()
  end

  def display_times(times) do
    config = TeeEffElle.Application.config()
    "#{config.bus_line}: #{Enum.join(times, " / ")}"
  end

  defp feasible(walking_time_in_minutes) do
    fn elem, acc ->
      time_left = elem - walking_time_in_minutes

      if time_left > 0 do
        [time_left | acc]
      else
        acc
      end
    end
  end
end
