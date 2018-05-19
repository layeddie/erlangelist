defmodule SiteEncrypt.Phoenix do
  def child_spec(endpoint) do
    %{id: __MODULE__, type: :supervisor, start: {__MODULE__, :start_link, [endpoint]}}
  end

  def start_link(endpoint) do
    certbot_config = endpoint.certbot_config()

    Supervisor.start_link(
      [
        Supervisor.child_spec(endpoint, id: :endpoint),
        {SiteEncrypt.Certifier, {endpoint, certbot_config}}
      ],
      name: name(certbot_config),
      strategy: :rest_for_one
    )
  end

  def restart_endpoint(certbot_config) do
    Supervisor.terminate_child(name(certbot_config), :endpoint)
    Supervisor.restart_child(name(certbot_config), :endpoint)
  end

  defp name(certbot_config),
    do: SiteEncrypt.Registry.via_tuple({__MODULE__, certbot_config.domain})
end