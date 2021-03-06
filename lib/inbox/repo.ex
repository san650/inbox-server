defmodule Inbox.Repo do
  use Ecto.Repo, otp_app: :inbox
  alias Inbox.Tag

  def find_or_create(Tag, tag_names) do
    tag_names
    |> Enum.reject(& &1 == nil)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&find_or_create_tags/1)
  end

  defp find_or_create_tags(tag_name) do
    case get_by(Tag, name: tag_name) do
      nil -> insert!(Tag.changeset(%Tag{}, %{name: tag_name}))
      tag -> tag
    end
  end
end
