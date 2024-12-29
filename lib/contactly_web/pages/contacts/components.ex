defmodule ContactlyWeb.Pages.Contacts.Components do
  use Phoenix.Component

  def contact_form(assigns) do
    ~H"""
    <form phx-submit="save">
      <div>
        <label>Name:</label>
        <input
          id="name"
          type="text"
          name="contact_form[name]"
          value={@changeset.changes[:name] || ""}
        />
        <%= if @changeset.action == :insert && @changeset.errors[:name] do %>
          <span class="error-msg">{elem(@changeset.errors[:name], 0)}</span>
        <% end %>
      </div>
      <div>
        <label>Email:</label>
        <input
          id="email"
          type="email"
          name="contact_form[email]"
          value={@changeset.changes[:email] || ""}
        />
        <%= if @changeset.action == :insert && @changeset.errors[:email] do %>
          <span class="error-msg">{elem(@changeset.errors[:email], 0)}</span>
        <% end %>
      </div>
      <div>
        <label>Phone:</label>
        <input
          id="phone"
          type="text"
          name="contact_form[phone]"
          value={@changeset.changes[:phone] || ""}
        />
        <%= if @changeset.action == :insert && @changeset.errors[:phone] do %>
          <span class="error-msg">{elem(@changeset.errors[:phone], 0)}</span>
        <% end %>
      </div>

      <button type="submit">Save contact</button>
    </form>
    """
  end
end
