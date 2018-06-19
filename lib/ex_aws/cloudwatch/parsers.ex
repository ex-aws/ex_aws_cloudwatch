if Code.ensure_loaded?(SweetXml) do
  defmodule ExAws.Cloudwatch.Parsers do
    use ExAws.Operation.Query.Parser

    def parse({:ok, %{body: xml} = resp}, :describe_alarms) do
      parsed_body =
        xml
        |> SweetXml.xpath(
             ~x"//DescribeAlarmsResponse",
             alarms: alarm_xml_description(),
             next_token: ~x"./DescribeAlarmsResult/NextToken/text()"s,
             request_id: ~x"./ResponseMetadata/RequestId/text()"s
           )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :describe_alarm_history) do
      parsed_body =
        xml
        |> SweetXml.xpath(
             ~x"//DescribeAlarmHistoryResponse",
             alarm_history: alarm_history_xml_description(),
             next_token: ~x"./DescribeAlarmHistoryResult/NextToken/text()"s,
             request_id: ~x"./ResponseMetadata/RequestId/text()"s
           )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :get_dashboard) do
      parsed_body =
        xml
        |> SweetXml.xpath(
             ~x"//GetDashboardResponse",
             dashboard_arn: ~x"./GetDashboardResult/DashboardArn/text()"s,
             dashboard_body: ~x"./GetDashboardResult/DashboardBody/text()"s,
             dashboard_name: ~x"./GetDashboardResult/DashboardName/text()"s,
             request_id: ~x"./ResponseMetadata/ReqeustId/text()"s
           )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :get_metric_statistics) do
      parsed_body =
        xml
        |> SweetXml.xpath(
             ~x"//GetMetricStatisticsResponse",
             metric_statistics: metric_statistics_description(),
             label: ~x"./GetMetricStatisticsResult/Label/text()"s,
             request_id: ~x"./ResponseMetadata/RequestId/text()"s
           )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :list_dashboards) do
      parsed_body =
        xml
        |> SweetXml.xpath(
             ~x"//ListDashboardsResponse",
             dashboards: dashboards_description(),
             next_token: ~x"./ListDashboardsResult/NextToken/text()"s,
             request_id: ~x"./ResponseMetadata/RequestId/text()"s
           )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :list_metrics) do
      parsed_body =
        xml
        |> SweetXml.xpath(
             ~x"//ListMetricsResponse",
             metrics: metrics_description(),
             next_token: ~x"./ListMetricsResult/NextToken/text()"s,
             request_id: ~x"./ResponseMetadata/RequestId/text()"s
           )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:ok, %{body: xml} = resp}, :put_dashboard) do
      parsed_body =
        xml
        |> SweetXml.xpath(
             ~x"//PutDashboardResponse",
             dashboard_messages: dashboard_messages_description(),
             request_id: ~x"./ResponseMetadata/RequestId/text()"s
           )

      {:ok, Map.put(resp, :body, parsed_body)}
    end

    def parse({:error, %{body: xml} = resp}, _) do
      parsed_body = 
        xml
        |> SweetXml.xpath(
          ~x"//ErrorResponse",
          code: ~x"./Error/Code/text()"s,
          message: ~x"./Error/Message/text()"s,
        )
      {:error, Map.put(resp, :body, parsed_body)}
    end

    def parse(val, _), do: val

    defp alarm_xml_description do
      [
        ~x"./DescribeAlarmsResult/MetricAlarms/member"l,
        alarm_name: ~x"./AlarmName/text()"s,
        metric_name: ~x"./MetricName/text()"s,
        alarm_description: ~x"./AlarmDescription/text()"s,
        evaluation_periods: ~x"./EvaluationPeriods/text()"i,
        actions_enabled: ~x"./ActionsEnabled/text()"s |> to_boolean(),
        namespace: ~x"./Namespace/text()"s,
        alarm_arn: ~x"./AlarmArn/text()"s,
        state_value: ~x"./StateValue/text()"s,
        threshold: ~x"./Threshold/text()"f,
        period: ~x"./Period/text()"i,
        statistic: ~x"./Statistic/text()"s,
        comparison_operator: ~x"./ComparisonOperator/text()"s,
        state_reason: ~x"./StateReason/text()"s,
        state_reason_data: ~x"./StateReasonData/text()"s,
        insufficient_data_actions: ~x"./InsufficientDataActions/member/text()"ls,
        ok_actions: ~x"./OKActions/member/text()"ls,
        alarm_actions: ~x"./AlarmActions/member/text()"ls,
        state_updated_timestamp: ~x"./StateUpdatedTimestamp/text()"s,
        alarm_configuration_updated_timestamp: ~x"./AlarmConfigurationUpdatedTimestamp/text()"s,
        dimensions: [
          ~x"./Dimensions/member"l,
          name: ~x"./Name/text()"s,
          value: ~x"./Value/text()"s
        ]
      ]
    end

    defp alarm_history_xml_description do
      [
        ~x"./DescribeAlarmHistoryResult/AlarmHistoryItems/member"l,
        alarm_name: ~x"./AlarmName/text()"s,
        history_data: ~x"./HistoryData/text()"s,
        history_item_type: ~x"./HistoryItemType/text()"s,
        history_summary: ~x"./HistorySummary/text()"s,
        timestamp: ~x"./Timestamp/text()"s
      ]
    end

    defp metric_statistics_description do
      [
        ~x"./GetMetricStatisticsResult/Datapoints/member"l,
        average: ~x"./Average/text()"f,
        # TODO probably fix this
        extended_statistics: ~x"./ExtendedStatistics/text()"m,
        maximum: ~x"./Maximum/text()"f,
        minimum: ~x"./Minimum/text()"f,
        sample_count: ~x"./SampleCount/text()"f,
        sum: ~x"./Sum/text()"f,
        timestamp: ~x"./Timestamp/text()"s,
        unit: ~x"./Unit/text()"s
      ]
    end

    defp dashboards_description() do
      [
        ~x"./ListDashboardsResult/DashboardEntries/member"l,
        dashboard_arn: ~x"./DashboardArn/text()"s,
        dashboard_name: ~x"./DashboardName/text()"s,
        last_modified: ~x"./LastModified/text()"s,
        size: ~x"./Size/text()"i
      ]
    end

    defp metrics_description() do
      [
        ~x"./ListMetricsResult/Metrics/member"l,
        dimensions: [
          ~x"./Dimensions/member"l,
          name: ~x"./Name/text()"s,
          value: ~x"./Value/text()"s
        ],
        metric_name: ~x"./MetricName/text()"s,
        namespace: ~x"./Namespace/text()"s
      ]
    end

    defp dashboard_messages_description() do
      [
        ~x"./PutDashboardResult/DashboardValidationMessages/member"l,
        data_path: ~x"./DataPath/text()"s,
        message: ~x"./Message/text()"s
      ]
    end

    defp to_boolean(xpath) do
      xpath |> SweetXml.transform_by(&(&1 == "true"))
    end
  end
else
  defmodule ExAws.Cloudwatch.Parsers do
    def parse(val, _), do: val
  end
end
