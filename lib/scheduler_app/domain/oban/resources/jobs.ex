defmodule SchedulerApp.Domain.Oban.Jobs do
  use Ash.Resource,
    domain: SchedulerApp.Domain.Oban,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  attributes do
    integer_primary_key :id

    attribute :state, :atom,
      constraints: [
        one_of: [:available, :scheduled, :executing, :retryable, :completed, :discarded]
      ]

    attribute :queue, :string
    attribute :worker, :string
    attribute :args, :map
    attribute :errors, {:array, :map}
    attribute :attempt, :integer
    attribute :max_attempts, :integer
    attribute :attempted_by, {:array, :string}
    attribute :priority, :integer
    attribute :tags, {:array, :string}
    attribute :meta, :map

    create_timestamp :inserted_at
    attribute :scheduled_at, :utc_datetime
    attribute :attempted_at, :utc_datetime
    attribute :completed_at, :utc_datetime
    attribute :discarded_at, :utc_datetime
    attribute :cancelled_at, :utc_datetime
  end

  postgres do
    repo SchedulerApp.Repo
    table "oban_jobs"
  end

  json_api do
    type "jobs"

    routes do
      base "/oban/jobs"

      get :read
      index :read
      post :create
      patch :update
      delete :destroy
    end
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
    default_accept [:state, :queue, :worker, :args]
  end
end
