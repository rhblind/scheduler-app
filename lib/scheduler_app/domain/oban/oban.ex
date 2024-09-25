defmodule SchedulerApp.Domain.Oban do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  resources do
    resource SchedulerApp.Domain.Oban.Jobs
    resource SchedulerApp.Domain.Oban.Event
  end
end
