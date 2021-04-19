defmodule BeachFlagTest do
  use ExUnit.Case
  doctest BeachFlag

  test "flags/0" do
    [first | _rest] = BeachFlag.flags()

    assert first["color"] == "Yellow"
    assert first["unix_time"] == "1579364503000"
  end

  describe "parse_row_xml/1" do
    test "parsing double red flag message" do
      row =
        ~s[<sms protocol="0" address="31279" date="1581092316254" type="1" subject="null" body="Today's beach condition in South Walton is: Double Red Flags - Water Closed to Public.&#10;Rply STOP to stop" toa="null" sc_toa="null" service_center="6502531234" read="1" status="-1" locked="0" date_sent="1581092313000" sub_id="1" readable_date="Feb 7, 2020 10:18:36 AM" contact_name="(Unknown)" />]

      assert %{
               "color" => "Double Red",
               "unix_time" => "1581092313000"
             } = BeachFlag.parse_row_xml(row)
    end

    test "parsing yellow flag message" do
      row =
        ~s[<sms protocol="0" address="31279" date="1580660311489" type="1" subject="null" body="Today's beach condition in South Walton is: Yellow Flags - Medium Hazard - Moderate Surf and/or Currents.&#10;Rply STOP to stop" toa="null" sc_toa="null" service_center="6502531234" read="1" status="-1" locked="0" date_sent="1580660308000" sub_id="1" readable_date="Feb 2, 2020 10:18:31 AM" contact_name="(Unknown)" />]

      assert %{
               "color" => "Yellow",
               "unix_time" => "1580660308000"
             } = BeachFlag.parse_row_xml(row)
    end

    test "parsing covid message" do
      row =
        ~s[<sms protocol="0" address="31279" date="1585754759933" type="1" subject="null" body="Walton County Beaches temporarily closed to the public as part of efforts to stop COVID-19. Surf conditions are: double red flags.&#10;Rply STOP to stop" toa="null" sc_toa="null" service_center="6502531234" read="1" status="-1" locked="0" date_sent="1585754759000" sub_id="1" readable_date="Apr 1, 2020 10:25:59 AM" contact_name="(Unknown)" />]

      assert %{
               "color" => "double red",
               "unix_time" => "1585754759000"
             } = BeachFlag.parse_row_xml(row)
    end
  end
end
