defmodule ContactlyWeb.Live.Components do
  alias Phoenix.LiveView.JS
  use Phoenix.Component

  attr :on_submit, :string, required: true
  attr :changeset, :map, required: true
  attr :submit_btn_text, :string, default: "Save Contact"
  attr :submitting_btn_text, :string, default: "Saving..."

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

      <button type="submit" phx-disable-with={@submitting_btn_text}>{@submit_btn_text}</button>
    </form>
    """
  end

  def delete_contact_modal(assigns) do
    ~H"""
    <div class="modal hidden">
      <div class="modal-content">
        <p>Are you sure you want to delete this contact?</p>

        <div class="modal-buttons">
          <button phx-click={JS.add_class("hidden", to: ".modal")}>
            Cancel
          </button>

          <form phx-submit="delete_contact">
            <input type="hidden" name="contact_id" id="contact-id-hidden-input" />
            <button id="delete-confirmation-btn" phx-disable-with="Deleting...">Delete</button>
          </form>
        </div>
      </div>
    </div>
    """
  end
end
