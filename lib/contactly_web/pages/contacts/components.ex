defmodule ContactlyWeb.Pages.Contacts.Components do
  use Phoenix.Component

  def contact_form(assigns) do
    ~H"""
    <form phx-submit={@on_submit}>
      <%= if @changeset.data.id do %>
        <input type="hidden" name="contact[id]" value={@changeset.data.id} />
      <% end %>

      <div>
        <label>Name:</label>
        <input
          id="name"
          type="text"
          name="contact[name]"
          value={@changeset.changes[:name] || @changeset.data.name || ""}
        />
        <%= if @changeset.action && @changeset.errors[:name] do %>
          <span class="error-msg">{elem(@changeset.errors[:name], 0)}</span>
        <% end %>
      </div>
      <div>
        <label>Email:</label>
        <input
          id="email"
          type="text"
          name="contact[email]"
          value={@changeset.changes[:email] || @changeset.data.email || ""}
        />
        <%= if @changeset.action && @changeset.errors[:email] do %>
          <span class="error-msg">{elem(@changeset.errors[:email], 0)}</span>
        <% end %>
      </div>
      <div>
        <label>Phone:</label>
        <input
          id="phone"
          type="text"
          name="contact[phone]"
          value={@changeset.changes[:phone] || @changeset.data.phone || ""}
        />
        <%= if @changeset.action && @changeset.errors[:phone] do %>
          <span class="error-msg">{elem(@changeset.errors[:phone], 0)}</span>
        <% end %>
      </div>

      <button type="submit">{@submit_btn_text}</button>
    </form>
    """
  end
end
