defmodule TeeEffElle.ApiClient do
  @moduledoc false

  def get_bus_times(%{
        bus_stop: bus_stop,
        bus_line: bus_line,
        tfl_app_id: tfl_app_id,
        tfl_app_key: tfl_app_key
      }) do
    %{body: body} =
      HTTPotion.get("https://api.tfl.gov.uk/StopPoint/#{bus_stop}/Arrivals",
        query: %{
          app_id: tfl_app_id,
          app_key: tfl_app_key
        }
      )

    body
    |> process_response(bus_line)
  end

  defp process_response(data, bus_line) do
    data
    |> Jason.decode!()
    |> Enum.filter(interesting_lines(bus_line))
    |> IO.inspect()
    |> Enum.map(&expected_minutes/1)
  end

  defp interesting_lines(bus_line) do
    fn
      %{"lineId" => line} ->
        line == bus_line

      _ ->
        false
    end
  end

  defp expected_minutes(%{"expectedArrival" => expectedArrival, "timestamp" => timestamp}) do
    {:ok, expected, _} = DateTime.from_iso8601(expectedArrival)
    {:ok, now, _} = DateTime.from_iso8601(timestamp)
    div(DateTime.diff(expected, now), 60)
  end
end
