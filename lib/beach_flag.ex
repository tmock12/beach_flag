defmodule BeachFlag do
  @moduledoc """
  Documentation for `BeachFlag`.
  """
  def flags do
    beach_flag_sms_xml()
    |> File.stream!()
    |> Stream.map(&parse_row_xml/1)
    |> Stream.map(&convert_unix_time_to_date/1)
    |> Stream.reject(&is_nil/1)
    |> Enum.to_list()
  end

  @doc """
  Find flags in the same month as date
  """
  @spec in_month(list(%{required(String.t()) => Date.t()}), Date.t()) :: list()
  def in_month(flags, %Date{year: year, month: month}) do
    flags
    |> Enum.filter(fn
      %{"date" => %{year: ^year, month: ^month}} -> true
      _ -> false
    end)
  end

  def beach_flag_sms_xml do
    Application.app_dir(:beach_flag, "/priv/sms.xml")
  end

  def parse_row_xml(row) do
    regex = ~r/.+:\s(?<color>.+)\sflags.+date_sent="(?<unix_time>\d+)/i
    Regex.named_captures(regex, row)
  end

  defp convert_unix_time_to_date(%{"unix_time" => unix_time} = row) do
    unix_time
    |> String.to_integer()
    |> DateTime.from_unix(:millisecond)
    |> case do
      {:ok, date_time} -> Map.put(row, "date", DateTime.to_date(date_time))
      {:error, _error} -> nil
    end
  end

  defp convert_unix_time_to_date(_), do: nil
end
