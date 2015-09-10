defmodule Erlangelist do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok, cache_opts} = Application.fetch_env(:erlangelist, :articles_cache)
    children = [
      worker(ConCache, [cache_opts, [name: :articles]]),
      # Start the endpoint when the application starts
      supervisor(Erlangelist.Endpoint, []),
      # Here you could define other workers and supervisors as children
      # worker(Erlangelist.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Erlangelist.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Erlangelist.Endpoint.config_change(changed, removed)
    :ok
  end
end
