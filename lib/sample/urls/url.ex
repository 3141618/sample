defmodule Sample.Urls.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :url, :string
    field :original_url, :string
    field :short_code, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:original_url, :short_code])
    |> validate_required([:original_url])
    |> validate_url(:original_url)
    |> generate_short_code()
    |> unique_constraint(:short_code)
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn _, value ->
      case URI.parse(value) do
        %URI{scheme: scheme, host: host} when scheme in ["https", "http"] and not is_nil(host) ->
          []

        _ ->
          [{field, "must be valid URL"}]
      end
    end)
  end

  defp generate_short_code(changeset) do
    case get_field(changeset, :short_code) do
      nil ->
        put_change(changeset, :short_code, random_code())

      _ ->
        changeset
    end
  end

  defp random_code do
    :crypto.strong_rand_bytes(6)
    |> Base.url_encode64(padding: false)
    |> String.slice(0, 8)
  end
end
