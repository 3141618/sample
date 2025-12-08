defmodule SampleWeb.UrlController do
  use SampleWeb, :controller

  alias Sample.Urls
  alias Sample.Urls.Url

  def new(conn, _params) do
    changeset = Urls.change_url(%Url{})
    render(conn, :new, changeset: changeset, short_url: nil)
  end

  def create(conn, %{"url" => url_params}) do
    case Urls.create_url(url_params) do
      {:ok, url} ->
        short_url = url(~p"/s/#{url.short_code}")
        changeset = Urls.change_url(%Url{})
        render(conn, :new, changeset: changeset, short_url: short_url)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, short_url: nil)
    end
  end

  def redirect_to_url(conn, %{"code" => code}) do
    case Urls.get_url_by_code(code) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(html: SampleWeb.ErrorHTML)
        |> render(:"404")

      url ->
        redirect(conn, external: url.original_url)
    end
  end
end
