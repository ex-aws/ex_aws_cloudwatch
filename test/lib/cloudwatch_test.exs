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
    one_value_metric_datum = [
      metric_name: "My Metric Name",
      dimensions: [
        my_dim_1: "dim_1_value",
        my_dim_2: "dim_2_value"
      ],
      timestamp: timestamp,
      unit: "Count",
      storage_resolution: 1,

      value: 1.0
    ]
    multiple_values_metric_datum = [
      metric_name: "My Multi Metric Name",
      dimensions: [
        my_multi_dim_1: "multi_dim_1_value",
        my_multi_dim_2: "multi_dim_2_value"
      ],
      timestamp: timestamp,
      unit: "Milliseconds",
      storage_resolution: 1,

      values: [1, 2, 3.5, 4.2],
      counts: [10, 1, 5, 188],
    ]
    statistics_metric_datum = [
      metric_name: "My Statistics Metric Name",
      dimensions: [
        my_statistics_dim_1: "statistics_dim_1_value",
        my_statistics_dim_2: "statistics_dim_2_value"
      ],
      timestamp: timestamp,
      unit: "Count",
      storage_resolution: 1,

      statistic_values: [
        maximum: 6,
        minimum: 4,
        sample_count: 3,
        sum: 15
      ],
    ]

    metric_data = [
      one_value_metric_datum,
      multiple_values_metric_datum,
      statistics_metric_datum
    ]
    expected = %{
      "Action" => "PutMetricData",
      "MetricData.member.1.Dimensions.member.1.Name" => "my_dim_1",
      "MetricData.member.1.Dimensions.member.1.Value" => "dim_1_value",
      "MetricData.member.1.Dimensions.member.2.Name" => "my_dim_2",
      "MetricData.member.1.Dimensions.member.2.Value" => "dim_2_value",
      "MetricData.member.1.MetricName" => "My Metric Name",
      "MetricData.member.1.StorageResolution" => 1,
      "MetricData.member.1.Timestamp" => "2018-06-20T02:51:43Z",
      "MetricData.member.1.Unit" => "Count",
      "MetricData.member.1.Value" => 1.0,
      "MetricData.member.2.Counts.member.1" => 10,
      "MetricData.member.2.Counts.member.2" => 1,
      "MetricData.member.2.Counts.member.3" => 5,
      "MetricData.member.2.Counts.member.4" => 188,
      "MetricData.member.2.Dimensions.member.1.Name" => "my_multi_dim_1",
      "MetricData.member.2.Dimensions.member.1.Value" => "multi_dim_1_value",
      "MetricData.member.2.Dimensions.member.2.Name" => "my_multi_dim_2",
      "MetricData.member.2.Dimensions.member.2.Value" => "multi_dim_2_value",
      "MetricData.member.2.MetricName" => "My Multi Metric Name",
      "MetricData.member.2.StorageResolution" => 1,
      "MetricData.member.2.Timestamp" => "2018-06-20T02:51:43Z",
      "MetricData.member.2.Unit" => "Milliseconds",
      "MetricData.member.2.Values.member.1" => 1,
      "MetricData.member.2.Values.member.2" => 2,
      "MetricData.member.2.Values.member.3" => 3.5,
      "MetricData.member.2.Values.member.4" => 4.2,
      "MetricData.member.3.Dimensions.member.1.Name" => "my_statistics_dim_1",
      "MetricData.member.3.Dimensions.member.1.Value" => "statistics_dim_1_value",
      "MetricData.member.3.Dimensions.member.2.Name" => "my_statistics_dim_2",
      "MetricData.member.3.Dimensions.member.2.Value" => "statistics_dim_2_value",
      "MetricData.member.3.MetricName" => "My Statistics Metric Name",
      "MetricData.member.3.StatisticValues.Maximum" => 6,
      "MetricData.member.3.StatisticValues.Minimum" => 4,
      "MetricData.member.3.StatisticValues.SampleCount" => 3,
      "MetricData.member.3.StatisticValues.Sum" => 15,
      "MetricData.member.3.StorageResolution" => 1,
      "MetricData.member.3.Timestamp" => "2018-06-20T02:51:43Z",
      "MetricData.member.3.Unit" => "Count",
      "Namespace" => "My Name Space",
      "Version" => "2010-08-01",
    }
    assert expected == Cloudwatch.put_metric_data(metric_data, "My Name Space").params
  end

end
