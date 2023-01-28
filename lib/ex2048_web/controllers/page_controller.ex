defmodule Ex2048Web.PageController do
  use Ex2048Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
