defmodule BookshareWeb.ResponseController do
  use BookshareWeb, :controller

  alias Bookshare.Comments
  alias Bookshare.Comments.Response

  def add_response(conn, %{"id" => id, "response" => response_params}) do
    response_author = conn.assigns.current_user

    with review                        <- Comments.get_review!(id),
         true                          <- Comments.check_if_user_can_leave_response(review.id, response_author.id),
         {:ok, %Response{} = response} <- Comments.create_response(response_author, review, response_params) do
      conn
      |> put_status(:created)
      |> render("response.json", response: response)
    else
         nil -> conn
                |> put_status(:forbidden)
                |> json(%{message: "You can't leave response to review that is not about you or you aren't its author"})

         {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
    end
  end

  def delete(conn, %{"id" => id}) do
    review_author = conn.assigns.current_user

    with response           <- Comments.get_response!(id),
         true               <- response.user_id == review_author.id,
         {:ok, %Response{}} <- Comments.delete_response(response) do
      send_resp(conn, :no_content, "")
    end
  end
end
