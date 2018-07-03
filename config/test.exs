use Mix.Config

{port, ""} = Integer.parse(System.get_env("MONITORING_PORT") || "443")

config :ex_aws, :monitoring,
  scheme: System.get_env("MONITORING_SCHEME") || "https",
  host: System.get_env("MONITORING_HOST") || "monitoring.us-east-1.amazonaws.com",
  port: port
