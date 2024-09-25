defmodule SchedulerApp.Domain.Oban.Event do
  use Ash.Resource,
    domain: SchedulerApp.Domain.Oban,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource, AshOban]

  attributes do
    uuid_primary_key :id

    attribute :timestamp, :utc_datetime
    attribute :frequency, :string
  end

  postgres do
    repo SchedulerApp.Repo
    table "oban_events"
  end

  json_api do
    type "events"

    routes do
      base "/oban/event"

      get :read
      index :read
      post :create
      patch :update
      delete :destroy
    end
  end

  oban do
    triggers do
      trigger :check_for_jobs do
        action :send_api_request
        where expr(true)
        queue :default
        scheduler_cron "* * * * *"
      end
    end
  end

  actions do
    defaults [:read, :destroy, update: :*]
    default_accept [:timestamp, :frequency]

    create :create do
      primary? true
      accept [:timestamp, :frequency]
    end

    update :send_api_request do
      require_atomic? false

      change fn changeset, context ->
        IO.inspect("Sending API request!")
        changeset
      end
    end
  end
end
