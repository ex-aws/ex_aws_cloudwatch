defmodule ExAws.Cloudwatch do
  @moduledoc """
  Operations on AWS CloudWatch

  AWS CloudWatch provides a reliable, scalable, and flexible monitoring solution
  for your AWS resources.

  More information:
  * [CloudWatch User Guide][User_Guide]
  * [CloudWatch API][API_Doc]
  * [Amazon Resource Names (ARNs)][ARN_Doc]
  * [Cloud Watch Region Endpoints][CW_Regions]

  [User_Guide]: http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html
  [API_Doc]: http://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/
  [ARN_Doc]: http://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
  [CW_Regions]: http://docs.aws.amazon.com/general/latest/gr/rande.html#cw_region
  """
  use ExAws.Utils,
    format_type: :xml,
    non_standard_keys: %{}

  # version of the AWS API
  @version "2010-08-01"

  @type param :: {key :: atom, value :: binary}
  @type action :: [
          type: binary,
          target_group_arn: binary
        ]
  @type dimension :: {name :: binary | atom, value :: binary}
  @type metric_datum :: [
          dimensions: [dimension, ...],
          metric_name: binary,
          statistic_values: statistic_set,
          storage_resolution: integer,
          timestamp: %DateTime{},
          unit: binary,
          value: float
        ]
  @type statistic_set :: [
          maximum: float,
          minimum: float,
          sample_count: float,
          sum: float
        ]

  @doc """
  Deletes the specified alarms.

  You may specify up to 100 alarms to delete. In the event of an error,
  no alarms are deleted.

  ## Examples:
      iex> ExAws.Cloudwatch.delete_alarms(["alarm1", "alarm2"])
      %ExAws.Operation.Query{action: :delete_alarms,
      params: %{"Action" => "DeleteAlarms", "AlarmNames.member.1" => "alarm1",
        "AlarmNames.member.2" => "alarm2", "Version" => "2010-08-01"},
      parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @spec delete_alarms(alarm_names :: [binary, ...]) :: ExAws.Operation.Query.t()
  def delete_alarms(alarm_names) do
    [{:alarm_names, alarm_names}]
    |> build_request(:delete_alarms)
  end

  @doc """
  Deletes all dashboards that you specify.

  You may specify up to 100 dashboards to delete. If there is an error,
  no dashboards are deleted.

  ## Examples:
      iex> ExAws.Cloudwatch.delete_dashboards(["dash1", "dash2"])
      %ExAws.Operation.Query{action: :delete_dashboards,
      params: %{"Action" => "DeleteDashboards", "DashboardNames.member.1" => "dash1",
      "DashboardNames.member.2" => "dash2", "Version" => "2010-08-01"},
      parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @spec delete_dashboards(dashboard_names :: [binary, ...]) :: ExAws.Operation.Query.t()
  def delete_dashboards(dashboard_names) do
    [{:dashboard_names, dashboard_names}]
    |> build_request(:delete_dashboards)
  end

  @doc """
  Retrieves the history for the specified alarm.

  You can filter the results by date range or item type. If an alarm name
  is not specified, the histories for all alarms are returned.

  CloudWatch retains the history of an alarm even if you delete the alarm.

  ## Examples:
        iex> ExAws.Cloudwatch.describe_alarm_history()
        %ExAws.Operation.Query{action: :describe_alarm_history,
        params: %{"Action" => "DescribeAlarmHistory", "Version" => "2010-08-01"},
        parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @type describe_alarm_history_opts :: [
          alarm_name: binary,
          history_item_type: binary,
          start_date: %DateTime{},
          end_date: %DateTime{},
          max_records: integer,
          next_token: binary
        ]
  @spec describe_alarm_history() :: ExAws.Operation.Query.t()
  @spec describe_alarm_history(opts :: describe_alarm_history_opts) :: ExAws.Operation.Query.t()
  def describe_alarm_history(opts \\ []) do
    opts |> build_request(:describe_alarm_history)
  end

  @doc """
  Retrieves the specified alarms.

  If no alarms are specified, all alarms are returned. Alarms can be retrieved by
  using only a prefix for the alarm name, the alarm state, or a prefix for any action.

  ## Examples:
        iex> ExAws.Cloudwatch.describe_alarms()
        %ExAws.Operation.Query{action: :describe_alarms,
        params: %{"Action" => "DescribeAlarms", "Version" => "2010-08-01"},
        parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @type describe_alarm_opts :: [
          alarm_names: [binary, ...],
          alarm_name_prefix: binary,
          state_value: binary,
          action_prefix: binary,
          max_records: integer,
          next_token: binary
        ]
  @spec describe_alarms() :: ExAws.Operation.Query.t()
  @spec describe_alarms(opts :: describe_alarm_opts) :: ExAws.Operation.Query.t()
  def describe_alarms(opts \\ []) do
    opts |> build_request(:describe_alarms)
  end

  @doc """
  Retrieves the alarms for the specified metric.

  To filter the results, specify a statistic, period, or unit.

  ## Examples:
        iex> ExAws.Cloudwatch.describe_alarms_for_metric(
        ...> "metric_name",
        ...> "namespace")
        %ExAws.Operation.Query{action: :describe_alarms_for_metric,
        params: %{"Action" => "DescribeAlarmsForMetric", "MetricName" => "metric_name",
        "Namespace" => "namespace", "Version" => "2010-08-01"},
        parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @type describe_alarms_for_metric_opts :: [
          statistic: binary,
          extended_statistic: binary,
          dimensions: [dimension, ...],
          period: integer,
          unit: binary
        ]
  @spec describe_alarms_for_metric(
          metric_name :: binary,
          namespace :: binary
        ) :: ExAws.Operation.Query.t()
  @spec describe_alarms_for_metric(
          metric_name :: binary,
          namespace :: binary,
          opts :: describe_alarms_for_metric_opts
        ) :: ExAws.Operation.Query.t()
  def describe_alarms_for_metric(metric_name, namespace, opts \\ []) do
    [
      {:metric_name, metric_name},
      {:namespace, namespace} | opts
    ]
    |> build_request(:describe_alarms_for_metric)
  end

  @doc """
  Disables the actions for the specified alarms.

  When an alarm's actions are disabled, the alarm actions do not execute when
  the alarm state changes.

  ## Examples:
      iex> ExAws.Cloudwatch.disable_alarm_actions(alarm_names: ["alarm1", "alarm2"])
      %ExAws.Operation.Query{action: :disable_alarm_actions,
      params: %{"Action" => "DisableAlarmActions",
      "AlarmNames.member.AlarmNames.1" => "alarm1",
      "AlarmNames.member.AlarmNames.2" => "alarm2", "Version" => "2010-08-01"},
      parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @spec disable_alarm_actions(alarm_names :: [binary, ...]) :: ExAws.Operation.Query.t()
  def disable_alarm_actions(alarm_names) do
    [{:alarm_names, alarm_names}]
    |> build_request(:disable_alarm_actions)
  end

  @doc """
  Enables the actions for the specified alarms.

  ## Examples:
      iex> ExAws.Cloudwatch.enable_alarm_actions(alarm_names: ["alarm1", "alarm2"])
      %ExAws.Operation.Query{action: :enable_alarm_actions,
      params: %{"Action" => "EnableAlarmActions",
        "AlarmNames.member.AlarmNames.1" => "alarm1",
        "AlarmNames.member.AlarmNames.2" => "alarm2", "Version" => "2010-08-01"},
      parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @spec enable_alarm_actions(alarm_names :: [binary, ...]) :: ExAws.Operation.Query.t()
  def enable_alarm_actions(alarm_names) do
    [{:alarm_names, alarm_names}]
    |> build_request(:enable_alarm_actions)
  end

  @doc """
  Displays the details of the dashboard that you specify.

  To copy an existing dashboard, use get_dashboard/0, and then use the data
  returned within dashboard_body as the template for the new dashboard
  when you call put_dashboard/2 to create the copy.

  ## Examples:
      iex> ExAws.Cloudwatch.get_dashboard([dashboard_name: "dashboard_name"])
      %ExAws.Operation.Query{action: :get_dashboard,
      params: %{"Action" => "GetDashboard", "DashboardName" => "dashboard_name",
        "Version" => "2010-08-01"},
      parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @type get_dashboard_opts :: [
          dashboard_name: binary
        ]
  @spec get_dashboard() :: ExAws.Operation.Query.t()
  @spec get_dashboard(opts :: get_dashboard_opts) :: ExAws.Operation.Query.t()
  def get_dashboard(opts \\ []) do
    opts |> build_request(:get_dashboard)
  end

  @doc """
  Gets statistics for the specified metric.

  The maximum number of data points returned from a single call is 1,440. If
  you request more than 1,440 data points, CloudWatch returns an error. To
  reduce the number of data points, you can narrow the specified time range
  and make multiple requests across adjacent time ranges, or you can increase
  the specified period. Data points are not returned in chronological order.

  CloudWatch aggregates data points based on the length of the period that
  you specify. For example, if you request statistics with a one-hour period,
  CloudWatch aggregates all data points with time stamps that fall within each
  one-hour period. Therefore, the number of values aggregated by CloudWatch
  is larger than the number of data points returned.

  CloudWatch needs raw data points to calculate percentile statistics. If you
  publish data using a statistic set instead, you can only retrieve percentile
  statistics for this data if one of the following conditions is true:

  The sample_count value of the statistic set is 1.
  The Min and the Max values of the statistic set are equal.

  Amazon CloudWatch retains metric data as follows:

  * Data points with a period of less than 60 seconds are available for 3
    hours. These data points are high-resolution metrics and are available
    only for custom metrics that have been defined with a StorageResolution
    of 1.
  * Data points with a period of 60 seconds (1-minute) are available for
    15 days.
  * Data points with a period of 300 seconds (5-minute) are available for
    63 days.
  * Data points with a period of 3600 seconds (1 hour) are available for
    455 days (15 months).
  * Data points that are initially published with a shorter period are
    aggregated together for long-term storage. For example, if you collect
    data using a period of 1 minute, the data remains available for 15 days
    with 1-minute resolution. After 15 days, this data is still available,
    but is aggregated and retrievable only with a resolution of 5 minutes.
    After 63 days, the data is further aggregated and is available with a
    resolution of 1 hour.

  CloudWatch started retaining 5-minute and 1-hour metric data as of
  July 9, 2016.

  ## Examples:
      iex> {:ok, start_time, 0} = DateTime.from_iso8601("2017-01-23T23:50:07Z")
      iex> {:ok, end_time, 0} = DateTime.from_iso8601("2017-02-23T23:50:07Z")
      iex> ExAws.Cloudwatch.get_metric_statistics("namespace", "metric_name", start_time, end_time, 1)
      %ExAws.Operation.Query{action: :get_metric_statistics,
      params: %{"Action" => "GetMetricStatistics",
        "EndTime" => "2017-02-23T23:50:07Z", "MetricName" => "metric_name",
        "Namespace" => "namespace", "Period" => 1,
        "StartTime" => "2017-01-23T23:50:07Z", "Version" => "2010-08-01"},
      parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @type get_metric_statistics_opts :: [
          dimensions: [dimension, ...],
          statistics: [binary, ...],
          extended_statistics: [binary, ...],
          unit: binary
        ]
  @spec get_metric_statistics(
          namespace :: binary,
          metric_name :: binary,
          start_time :: %DateTime{},
          end_time :: %DateTime{},
          period :: integer
        ) :: ExAws.Operation.Query.t()
  @spec get_metric_statistics(
          namespace :: binary,
          metric_name :: binary,
          start_time :: %DateTime{},
          end_time :: %DateTime{},
          period :: integer,
          opts :: get_metric_statistics_opts
        ) :: ExAws.Operation.Query.t()
  def get_metric_statistics(namespace, metric_name, start_time, end_time, period, opts \\ []) do
    [
      {:namespace, namespace},
      {:metric_name, metric_name},
      {:start_time, start_time},
      {:end_time, end_time},
      {:period, period} | opts
    ]
    |> build_request(:get_metric_statistics)
  end

  @doc """
  Returns a list of the dashboards for your account.

  If you include dashboard_name_prefix, only those dashboards with names
  starting with the prefix are listed. Otherwise, all dashboards in
  your account are listed.

  ## Examples:
        iex> ExAws.Cloudwatch.list_dashboards()
        %ExAws.Operation.Query{action: :list_dashboards,
        params: %{"Action" => "ListDashboards", "Version" => "2010-08-01"},
        parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @type list_dashboards_opts :: [
          dashboard_name_prefix: binary,
          next_token: binary
        ]
  @spec list_dashboards() :: ExAws.Operation.Query.t()
  @spec list_dashboards(opts :: list_dashboards_opts) :: ExAws.Operation.Query.t()
  def list_dashboards(opts \\ []) do
    opts |> build_request(:list_dashboards)
  end

  @doc """
  List the specified metrics.

  You can use the returned metrics with `get_metric_statistics/1` to obtain
  statistical data. Up to 500 results are returned for any one call.
  To retrieve additional results, use the returned token with subsequent
  calls.

  After you create a metric, allow up to fifteen minutes before the metric
  appears. Statistics about the metric, however, are available sooner
  using `get_metric_statistics/1`

  ## Examples:
        iex> ExAws.Cloudwatch.list_metrics(
        ...> [namespace: "namespace",
        ...> metric_name: "metric_name"])
        %ExAws.Operation.Query{action: :list_metrics,
        params: %{"Action" => "ListMetrics", "MetricName" => "metric_name",
          "Namespace" => "namespace", "Version" => "2010-08-01"},
        parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @type list_metrics_opts :: [
          namespace: binary,
          metric_name: binary,
          dimensions: [dimension, ...],
          next_token: binary
        ]
  @spec list_metrics() :: ExAws.Operation.Query.t()
  @spec list_metrics(opts :: list_metrics_opts) :: ExAws.Operation.Query.t()
  def list_metrics(opts \\ []) do
    opts |> build_request(:list_metrics)
  end

  @doc """
  Creates a dashboard if it does not already exist, or updates an existing
  dashboard.

  If you update a dashboard, the entire contents are replaced with what
  you specify here.

  You can have up to 500 dashboards per account. All dashboards in your
  account are global, not region-specific.

  A simple way to create a dashboard using put_dashboard/2 is to copy an
  existing dashboard. To copy an existing dashboard using the console, you
  can load the dashboard and then use the View/edit source command in the
  Actions menu to display the JSON block for that dashboard. Another way to
  copy a dashboard is to use `get_dashboard/1`, and then use the data
  returned within dashboard_body as the template for the new dashboard
  when you call `put_dashboard/2`.

  When you create a dashboard with put_dashboard/2 , a good practice is to add a text widget at the top of the
  dashboard with a message that the dashboard was created by script and should not be changed in the console.
  This message could also point console users to the location of the dashboard_body script or the CloudFormation
  template used to create the dashboard.

  ## Examples:
      iex> ExAws.Cloudwatch.put_dashboard("dashboard_name", "dashboard_body")
      %ExAws.Operation.Query{action: :put_dashboard,
      params: %{"Action" => "PutDashboard", "DashboardBody" => "dashboard_body",
        "DashboardName" => "dashboard_name", "Version" => "2010-08-01"},
      parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @spec put_dashboard(dashboard_name :: binary, dashboard_body :: binary) ::
          ExAws.Operation.Query.t()
  def put_dashboard(dashboard_name, dashboard_body) do
    [{:dashboard_name, dashboard_name}, {:dashboard_body, dashboard_body}]
    |> build_request(:put_dashboard)
  end

  @doc """
  Creates or updates an alarm and associates it with the specified metric.

  Optionally, this operation can associate one or more Amazon SNS resources
  with the alarm.

  When this operation creates an alarm, the alarm state is immediately set
  to INSUFFICIENT_DATA . The alarm is evaluated and its state is set
  appropriately. Any actions associated with the state are then executed.

  When you update an existing alarm, its state is left unchanged, but the
  update completely overwrites the previous configuration of the alarm.

  If you are an IAM user, you must have Amazon EC2 permissions for some operations:

  ec2:DescribeInstanceStatus and ec2:DescribeInstances for all alarms on EC2 instance status metrics
  ec2:StopInstances for alarms with stop actions
  ec2:TerminateInstances for alarms with terminate actions
  ec2:DescribeInstanceRecoveryAttribute and ec2:RecoverInstances for alarms with recover actions
  If you have read/write permissions for Amazon CloudWatch but not for Amazon EC2, you can still
  create an alarm, but the stop or terminate actions are not performed. However, if you are later granted
  the required permissions, the alarm actions that you created earlier are performed.

  If you are using an IAM role (for example, an EC2 instance profile), you cannot stop or terminate the
  instance using alarm actions. However, you can still see the alarm state and perform any other actions
  such as Amazon SNS notifications or Auto Scaling policies.

  If you are using temporary security credentials granted using AWS STS, you cannot stop or terminate an
  EC2 instance using alarm actions.

  You must create at least one stop, terminate, or reboot alarm using either the Amazon EC2 or CloudWatch
  consoles to create the EC2ActionsAccess IAM role. After this IAM role is created, you can create stop,
  terminate, or reboot alarms using a command-line interface or API.

  ## Examples:
        iex> ExAws.Cloudwatch.put_metric_alarm(
        ...> "alarm_name",
        ...> "greater_than",
        ...> 1,
        ...> "metric_name",
        ...> "namespace",
        ...> 2,
        ...> 3.1,
        ...> "sum")
        %ExAws.Operation.Query{action: :put_metric_alarm,
        params: %{"Action" => "PutMetricAlarm", "AlarmName" => "alarm_name",
          "ComparisonOperator" => "greater_than", "EvaluationPeriods" => 1,
          "MetricName" => "metric_name", "Namespace" => "namespace", "Period" => 2,
          "Statistic" => "sum", "Threshold" => 3.1, "Version" => "2010-08-01"},
        parser: &ExAws.Cloudwatch.Parsers.parse/2, path: "/", service: :monitoring}
  """
  @type put_metric_alarm_opts :: [
          actions_enabled: boolean,
          alarm_actions: [binary, ...],
          alarm_description: binary,
          dimensions: [dimension, ...],
          evaluate_low_sample_count_percentile: binary,
          extended_statistic: binary,
          insufficient_data_actions: [binary, ...],
          ok_actions: [binary, ...],
          treat_missing_data: binary,
          unit: binary
        ]
  @spec put_metric_alarm(
          alarm_name :: binary,
          comparison_operator :: binary,
          evaluation_periods :: integer,
          metric_name :: binary,
          namespace :: binary,
          period :: integer,
          threshold :: float,
          statistic :: binary
        ) :: ExAws.Operation.Query.t()
  @spec put_metric_alarm(
          alarm_name :: binary,
          comparison_operator :: binary,
          evaluation_periods :: integer,
          metric_name :: binary,
          namespace :: binary,
          period :: integer,
          threshold :: float,
          statistic :: binary,
          opts :: put_metric_alarm_opts
        ) :: ExAws.Operation.Query.t()
  def put_metric_alarm(
        alarm_name,
        comparison_operator,
        evaluation_periods,
        metric_name,
        namespace,
        period,
        threshold,
        statistic,
        opts \\ []
      ) do
    [
      {:alarm_name, alarm_name},
      {:comparison_operator, comparison_operator},
      {:evaluation_periods, evaluation_periods},
      {:metric_name, metric_name},
      {:namespace, namespace},
      {:period, period},
      {:threshold, threshold},
      {:statistic, statistic} | opts
    ]
    |> build_request(:put_metric_alarm)
  end

  @doc """
  Publishes metric data points to Amazon CloudWatch.

  CloudWatch associates the data points with the specified metric.
  If the specified metric does not exist, CloudWatch creates the metric.
  When CloudWatch creates a metric, it can take up to fifteen minutes for
  the metric to appear in calls to ListMetrics .

  Each PutMetricData request is limited to 40 KB in size for HTTP POST requests.

  Although the Value parameter accepts numbers of type Double, CloudWatch rejects
  values that are either too small or too large. Values must be in the range
  of 8.515920e-109 to 1.174271e+108 (Base 10) or 2e-360 to 2e360 (Base 2).
  In addition, special values (for example, NaN, +Infinity, -Infinity) are
  not supported.

  You can use up to 10 dimensions per metric to further clarify what data the
  metric collects. For more information about specifying dimensions, see
  Publishing Metrics in the Amazon CloudWatch User Guide.

  Data points with time stamps from 24 hours ago or longer can take at least
  48 hours to become available for GetMetricStatistics from the time they are
  submitted.

  CloudWatch needs raw data points to calculate percentile statistics. If you
  publish data using a statistic set instead, you can only retrieve percentile
  statistics for this data if one of the following conditions is true:

  * The SampleCount value of the statistic set is 1
  * The Min and the Max values of the statistic set are equal


  """
  @spec put_metric_data(metric_data :: [metric_datum, ...], namespace :: binary) ::
          ExAws.Operation.Query.t()
  def put_metric_data(metric_data, namespace) do
    [
      {:metric_data, metric_data},
      {:namespace, namespace}
    ]
    |> build_request(:put_metric_data)
  end

  ####################
  # Helper Functions #
  ####################

  defp build_request(opts, action) do
    opts
    |> Enum.flat_map(&format_param/1)
    |> request(action)
  end

  defp request(params, action) do
    action_string = action |> Atom.to_string() |> Macro.camelize()

    %ExAws.Operation.Query{
      path: "/",
      params:
        params
        |> filter_nil_params
        |> Map.put("Action", action_string)
        |> Map.put("Version", @version),
      service: :monitoring,
      action: action,
      parser: &ExAws.Cloudwatch.Parsers.parse/2
    }
  end

  defp format_param({:alarm_actions, alarm_actions}) do
    alarm_actions |> format(prefix: "AlarmActions.member")
  end

  defp format_param({:alarm_names, alarm_names}) do
    alarm_names |> format(prefix: "AlarmNames.member")
  end

  defp format_param({:dashboard_names, dashboard_names}) do
    dashboard_names |> format(prefix: "DashboardNames.member")
  end

  defp format_param({:dimensions, dimensions}) do
    dimensions
    |> Enum.map(fn {key, value} -> [name: maybe_stringify(key), value: value] end)
    |> format(prefix: "Dimensions.member")
  end

  defp format_param({:end_time, end_time}) do
    end_time
    |> DateTime.to_iso8601()
    |> format(prefix: "EndTime")
  end

  defp format_param({:extended_statistics, extended_statistics}) do
    extended_statistics |> format(prefix: "ExtendedStatistics.member")
  end

  defp format_param({:insufficient_data_actions, insufficient_data_actions}) do
    insufficient_data_actions |> format(prefix: "InsufficientDataActions.member")
  end

  defp format_param({:metric_data, metric_data}) do
    metric_data
    |> Enum.flat_map(&format_param/1)
    |> ExAws.Utils.format(prefix: "MetricData.member")
  end

  defp format_param({:ok_actions, ok_actions}) do
    ok_actions |> format(prefix: "OKActions.member")
  end

  defp format_param({:start_time, start_time}) do
    start_time
    |> DateTime.to_iso8601()
    |> format(prefix: "StartTime")
  end

  defp format_param({:statistics, statistics}) do
    statistics |> format(prefix: "Statistics.member")
  end

  defp format_param({key, parameters}) do
    format([{key, parameters}])
  end
end
