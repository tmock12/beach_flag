defmodule BeachFlagTextParser do
  @moduledoc """
  Documentation for `BeachFlagTextParser`.
  """
  def flags do
    beach_flag_sms_xml()
    |> File.stream!()
    |> Stream.map(&parse_row_xml/1)
    |> Stream.reject(&is_nil/1)
    |> Enum.to_list()
  end

  def beach_flag_sms_xml do
    Application.app_dir(:beach_flag_text_parser, "/priv/sms.xml")
  end

  def parse_row_xml(row) do
    regex = ~r/.+:\s(?<color>.+)\sflags.+date_sent="(?<unix_time>\d+)/i
    Regex.named_captures(regex, row)
  end
end
