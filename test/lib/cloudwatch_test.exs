defmodule ExAws.CloudwatchTest do
  use ExUnit.Case, async: true
  alias ExAws.Cloudwatch
  doctest ExAws.Cloudwatch

  test "#describe_alarms" do
    expected = %{"Action" => "DescribeAlarms", "Version" => "2010-08-01"}
    assert expected == Cloudwatch.describe_alarms().params
  end

  test "#put_metric_data" do
    {:ok, timestamp, 0} = DateTime.from_iso8601("2018-06-20T02:51:43Z")
    metric_datum = [
      metric_name: "My Metric Name",
      dimensions: [
        my_dim_1: "dim_1_value",
        my_dim_2: "dim_2_value"
      ],
      timestamp: timestamp,
      unit: "Count",
      storage_resolution: 1,

      # In production, either :statistic_values or :value is required.
      statistic_values: [
        maximum: 6,
        minimum: 4,
        sample_count: 3,
        sum: 15
      ],
      value: 1.0
    ]

    metric_data = [metric_datum, metric_datum, metric_datum]
    expected = %{
      "Action" => "PutMetricData",
      "MetricData.member.1.Dimensions.member.1.Name" => "my_dim_1",
      "MetricData.member.1.Dimensions.member.1.Value" => "dim_1_value",
      "MetricData.member.1.Dimensions.member.2.Name" => "my_dim_2",
      "MetricData.member.1.Dimensions.member.2.Value" => "dim_2_value",
      "MetricData.member.1.MetricName" => "My Metric Name",
      "MetricData.member.1.StatisticValues.Maximum" => 6,
      "MetricData.member.1.StatisticValues.Minimum" => 4,
      "MetricData.member.1.StatisticValues.SampleCount" => 3,
      "MetricData.member.1.StatisticValues.Sum" => 15,
      "MetricData.member.1.StorageResolution" => 1,
      "MetricData.member.1.Timestamp" => "2018-06-20T02:51:43Z",
      "MetricData.member.1.Unit" => "Count",
      "MetricData.member.1.Value" => 1.0,
      "MetricData.member.2.Dimensions.member.1.Name" => "my_dim_1",
      "MetricData.member.2.Dimensions.member.1.Value" => "dim_1_value",
      "MetricData.member.2.Dimensions.member.2.Name" => "my_dim_2",
      "MetricData.member.2.Dimensions.member.2.Value" => "dim_2_value",
      "MetricData.member.2.MetricName" => "My Metric Name",
      "MetricData.member.2.StatisticValues.Maximum" => 6,
      "MetricData.member.2.StatisticValues.Minimum" => 4,
      "MetricData.member.2.StatisticValues.SampleCount" => 3,
      "MetricData.member.2.StatisticValues.Sum" => 15,
      "MetricData.member.2.StorageResolution" => 1,
      "MetricData.member.2.Timestamp" => "2018-06-20T02:51:43Z",
      "MetricData.member.2.Unit" => "Count",
      "MetricData.member.2.Value" => 1.0,
      "MetricData.member.3.Dimensions.member.1.Name" => "my_dim_1",
      "MetricData.member.3.Dimensions.member.1.Value" => "dim_1_value",
      "MetricData.member.3.Dimensions.member.2.Name" => "my_dim_2",
      "MetricData.member.3.Dimensions.member.2.Value" => "dim_2_value",
      "MetricData.member.3.MetricName" => "My Metric Name",
      "MetricData.member.3.StatisticValues.Maximum" => 6,
      "MetricData.member.3.StatisticValues.Minimum" => 4,
      "MetricData.member.3.StatisticValues.SampleCount" => 3,
      "MetricData.member.3.StatisticValues.Sum" => 15,
      "MetricData.member.3.StorageResolution" => 1,
      "MetricData.member.3.Timestamp" => "2018-06-20T02:51:43Z",
      "MetricData.member.3.Unit" => "Count",
      "MetricData.member.3.Value" => 1.0,
      "Namespace" => "My Name Space",
      "Version" => "2010-08-01",
    }
    assert expected == Cloudwatch.put_metric_data(metric_data, "My Name Space").params
  end

end
