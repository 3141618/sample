defmodule Sample.UrlsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sample.Urls` context.
  """

  @doc """
  Generate a url.
  """
  def url_fixture(attrs \\ %{}) do
    {:ok, url} =
      attrs
      |> Enum.into(%{
        url: "some url"
      })
      |> Sample.Urls.create_url()

    url
  end
end
