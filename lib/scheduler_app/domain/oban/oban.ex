defmodule SchedulerApp.Domain.Oban do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  resources do
    resource SchedulerApp.Domain.Oban.Jobs
  end
end
