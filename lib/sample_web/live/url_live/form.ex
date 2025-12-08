defmodule SampleWeb.UrlLive.Form do
  use SampleWeb, :live_view

  alias Sample.Urls
  alias Sample.Urls.Url

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage url records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="url-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:url]} type="text" label="Url" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Url</.button>
          <.button navigate={return_path(@return_to, @url)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    url = Urls.get_url!(id)

    socket
    |> assign(:page_title, "Edit Url")
    |> assign(:url, url)
    |> assign(:form, to_form(Urls.change_url(url)))
  end

  defp apply_action(socket, :new, _params) do
    url = %Url{}

    socket
    |> assign(:page_title, "New Url")
    |> assign(:url, url)
    |> assign(:form, to_form(Urls.change_url(url)))
  end

  @impl true
  def handle_event("validate", %{"url" => url_params}, socket) do
    changeset = Urls.change_url(socket.assigns.url, url_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"url" => url_params}, socket) do
    save_url(socket, socket.assigns.live_action, url_params)
  end

  defp save_url(socket, :edit, url_params) do
    case Urls.update_url(socket.assigns.url, url_params) do
      {:ok, url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Url updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, url))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_url(socket, :new, url_params) do
    case Urls.create_url(url_params) do
      {:ok, url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Url created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, url))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _url), do: ~p"/urls"
  defp return_path("show", url), do: ~p"/urls/#{url}"
end
