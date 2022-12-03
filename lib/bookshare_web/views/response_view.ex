defmodule BookshareWeb.ResponseView do
  use BookshareWeb, :view
  alias BookshareWeb.ResponseView

  def render("index.json", %{responses: responses}) do
    %{data: render_many(responses, ResponseView, "response_list.json")}
  end

  def render("show.json", %{response: response}) do
    %{data: render_one(response, ResponseView, "response.json")}
  end

  def render("response_list.json", %{response: response}) do
    %{
      id: response.id,
      text: response.text,
      response_author_id: response.user_id,
      review: response.review_id
    }
  end

  def render("response.json", %{response: response}) do
    %{
      id: response.id,
      text: response.text,
      response_author_id: response.user_id,
      review: response.review_id
    }
  end
end
