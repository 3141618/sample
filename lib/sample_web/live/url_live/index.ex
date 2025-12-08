defmodule SampleWeb.UrlLive.Index do
  use SampleWeb, :live_view

  alias Sample.Urls

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Urls
        <:actions>
          <.button variant="primary" navigate={~p"/urls/new"}>
            <.icon name="hero-plus" /> New Url
          </.button>
        </:actions>
      </.header>

      <.table
        id="urls"
        rows={@streams.urls}
        row_click={fn {_id, url} -> JS.navigate(~p"/urls/#{url}") end}
      >
        <:col :let={{_id, url}} label="Url">{url.url}</:col>
        <:action :let={{_id, url}}>
          <div class="sr-only">
            <.link navigate={~p"/urls/#{url}"}>Show</.link>
          </div>
          <.link navigate={~p"/urls/#{url}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, url}}>
          <.link
            phx-click={JS.push("delete", value: %{id: url.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Urls")
     |> stream(:urls, list_urls())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    url = Urls.get_url!(id)
    {:ok, _} = Urls.delete_url(url)

    {:noreply, stream_delete(socket, :urls, url)}
  end

  defp list_urls() do
    Urls.list_urls()
  end
end
