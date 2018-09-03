# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :drg_site,
  ecto_repos: [DrgSite.Repo]

# Configures the endpoint
config :drg_site, DrgSiteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EXsk6V1El9JGU/qnMoM+EHc6/BBbQOV76R7MYMt4hzh7ah8lPTL/+YhWUo0to9Oc",
  render_errors: [view: DrgSiteWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DrgSite.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
