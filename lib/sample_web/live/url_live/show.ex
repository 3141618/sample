defmodule SampleWeb.UrlLive.Show do
  use SampleWeb, :live_view

  alias Sample.Urls

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Url {@url.id}
        <:subtitle>This is a url record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/urls"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/urls/#{@url}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit url
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Url">{@url.url}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Url")
     |> assign(:url, Urls.get_url!(id))}
  end
end
