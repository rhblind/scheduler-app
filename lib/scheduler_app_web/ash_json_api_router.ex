defmodule SchedulerAppWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [SchedulerApp.Domain.Oban],
    open_api: "/open_api"
end
