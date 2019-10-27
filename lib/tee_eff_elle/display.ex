defmodule TeeEffElle.Display do
  def show() do
    config = TeeEffElle.Application.config()

    result =
      TeeEffElle.ApiClient.get_bus_times(config)
      |> Enum.reduce([], feasible(config.walking_time_in_minutes))
      |> Enum.sort()
      |> Enum.uniq()
      |> Enum.join(" / ")

    ScrollPhatHdEx.Server.scroll_string("390: #{result}")
  end

  def feasible(walking_time_in_minutes) do
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
