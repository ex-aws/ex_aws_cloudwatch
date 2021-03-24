defmodule ExAws.Cloudwatch.ParserTest do
  use ExUnit.Case, async: true

  defp to_success(doc) do
    {:ok, %{body: doc}}
  end

  alias ExAws.Cloudwatch.Parsers

  test "#parsing a describe_alarms response" do
    rsp =
      """
        <DescribeAlarmsResponse xmlns="http://monitoring.amazonaws.com/doc/2010-08-01/">
          <DescribeAlarmsResult>
            <NextToken>next-token</NextToken>
            <MetricAlarms>
              <member>
                <MetricName>metric-name</MetricName>
                <AlarmConfigurationUpdatedTimestamp>2017-01-01T01:01:01.000Z</AlarmConfigurationUpdatedTimestamp>
                <StateValue>OK</StateValue>
                <Threshold>2.0</Threshold>
                <StateReason>a-state-reason</StateReason>
                <InsufficientDataActions>
                  <member>a</member>
                </InsufficientDataActions>
                <AlarmDescription>alarm-description</AlarmDescription>
                <AlarmActions>
                  <member>c</member>
                </AlarmActions>
                <StateUpdatedTimestamp>2017-01-01T00:00:00.000Z</StateUpdatedTimestamp>
                <Period>20</Period>
                <Statistic>Sum</Statistic>
                <ComparisonOperator>LessThanThreshold</ComparisonOperator>
                <AlarmName>alarm-name</AlarmName>
                <EvaluationPeriods>1</EvaluationPeriods>
                <StateReasonData>some-state-reason-data</StateReasonData>
                <ActionsEnabled>true</ActionsEnabled>
                <Namespace>a-namespace</Namespace>
                <OKActions>
                  <member>b</member>
                </OKActions>
                <AlarmArn>alarm-arn</AlarmArn>
                <Dimensions>
                  <member>
                    <Name>dimension-name</Name>
                    <Value>dimension-value</Value>
                  </member>
                </Dimensions>
              </member>
            </MetricAlarms>
          </DescribeAlarmsResult>
          <ResponseMetadata>
            <RequestId>3f1478c7-33a9-11df-9540-99d0768312d3</RequestId>
          </ResponseMetadata>
        </DescribeAlarmsResponse>
      """
      |> to_success

    {:ok, %{body: parsed_doc}} = Parsers.parse(rsp, :describe_alarms)

    assert Enum.count(parsed_doc[:alarms]) == 1
    assert parsed_doc[:next_token] == "next-token"
    assert parsed_doc[:request_id] == "3f1478c7-33a9-11df-9540-99d0768312d3"

    alarm = List.first(parsed_doc[:alarms])

    assert alarm[:metric_name] == "metric-name"
    assert alarm[:alarm_name] == "alarm-name"
    assert alarm[:alarm_description] == "alarm-description"
    assert alarm[:evaluation_periods] == 1
    assert alarm[:actions_enabled] == true
    assert alarm[:namespace] == "a-namespace"
    assert alarm[:alarm_arn] == "alarm-arn"
    assert alarm[:state_value] == "OK"
    assert alarm[:threshold] == 2.0
    assert alarm[:period] == 20
    assert alarm[:statistic] == "Sum"
    assert alarm[:comparison_operator] == "LessThanThreshold"
    assert alarm[:state_reason] == "a-state-reason"
    assert alarm[:state_reason_data] == "some-state-reason-data"
    assert alarm[:insufficient_data_actions] == ["a"]
    assert alarm[:ok_actions] == ["b"]
    assert alarm[:alarm_actions] == ["c"]
    assert alarm[:state_updated_timestamp] == "2017-01-01T00:00:00.000Z"
    assert alarm[:alarm_configuration_updated_timestamp] == "2017-01-01T01:01:01.000Z"

    assert alarm[:dimensions] == [%{name: "dimension-name", value: "dimension-value"}]
  end

  test "parsing a get metric statistics response" do
    rsp =
      "<GetMetricStatisticsResponse xmlns=\"http://monitoring.amazonaws.com/doc/2010-08-01/\">\n  <GetMetricStatisticsResult>\n    <Datapoints>\n      <member>\n        <Average>0.016666666666666666</Average>\n        <Unit>Percent</Unit>\n        <Timestamp>2019-07-16T15:54:00Z</Timestamp>\n      </member>\n      <member>\n        <Average>0.0</Average>\n        <Unit>Percent</Unit>\n        <Timestamp>2019-07-16T18:54:00Z</Timestamp>\n      </member>\n      <member>\n        <Average>0.0</Average>\n        <Unit>Percent</Unit>\n        <Timestamp>2019-07-16T13:54:00Z</Timestamp>\n      </member>\n      <member>\n        <Average>0.0</Average>\n        <Unit>Percent</Unit>\n        <Timestamp>2019-07-16T00:54:00Z</Timestamp>\n      </member>\n      </Datapoints>\n    <Label>CPUUtilization</Label>\n  </GetMetricStatisticsResult>\n  <ResponseMetadata>\n    <RequestId>aba280d4-ac9c-11e9-b6ee-ff0676301ff5</RequestId>\n  </ResponseMetadata>\n</GetMetricStatisticsResponse>\n"
      |> to_success

    {:ok, %{body: parsed_doc}} = Parsers.parse(rsp, :get_metric_statistics)

    assert Enum.count(parsed_doc[:metric_statistics]) == 4

    assert parsed_doc[:label] == "CPUUtilization"
    assert parsed_doc[:request_id] == "aba280d4-ac9c-11e9-b6ee-ff0676301ff5"

    stat = parsed_doc[:metric_statistics] |> List.first()

    assert stat[:average] == 0.016666666666666666
    assert stat[:maximum] == nil
  end
end
