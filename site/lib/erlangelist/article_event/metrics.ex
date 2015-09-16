defmodule Erlangelist.ArticleEvent.Metrics do
  use GenEvent

  alias Erlangelist.OneOff
  alias Erlangelist.GeoIp
  alias Erlangelist.PersistentCounterServer

  def handle_event(:invalid_article, state) do
    OneOff.run(fn -> Metrics.inc_spiral([:article, :invalid_article, :requests]) end)
    PersistentCounterServer.inc("article_view", "invalid_article")
    {:ok, state}
  end

  def handle_event({:article_visited, article, data}, state) do
    OneOff.run(fn -> GeoIp.report_metric(data[:remote_ip]) end)
    PersistentCounterServer.inc("article_view", "all")
    PersistentCounterServer.inc("article_view", article.id)

    {:ok, state}
  end

  def handle_event(_event, state) do
    {:ok, state}
  end
end