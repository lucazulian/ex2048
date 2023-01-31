defmodule Ex2048Web.GameLive.GridComponent do
  use Ex2048Web, :live_component

  def render(assigns) do
    ~H"""
    <div class="game-grid" phx-window-keyup="update_grid">
      <%= if length(@game.grid) > 0 do %>
        <%= for row <- @game.grid do %>
          <div class="grid-row">
            <%= for cell <- row do %>
              <div class="grid-cell">
                <%= if cell == :o do %>
                  <div class="grid-cell-inner-obstacle"/>
                <% else %>
                  <div class={"grid-cell-inner grid-cell-inner-#{cell}"}>
                    <%= cell %>
                  </div>
                <% end %>
              </div>
            <% end %>
          </div>
        <% end %>
      <% else %>
        Game not found
      <% end %>
    </div>
    """
  end
end
