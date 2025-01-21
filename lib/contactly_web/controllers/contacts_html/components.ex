defmodule ContactlyWeb.MVC.Components do
  use Phoenix.Component

  attr :action, :string, required: true
  attr :method, :string, default: "post"
  attr :changeset, :map, required: true
  attr :submit_btn_text, :string, default: "Save Contact"

  def contact_form(assigns) do
    ~H"""
    <form action={@action} method="post">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <input type="hidden" name="_method" value={@method} />

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

  slot :inner_block, required: true
  slot :trigger, required: true

  def modal(assigns) do
    ~H"""
    <div class="modal hidden">
      <div class="modal-content">
        <div>{render_slot(@inner_block)}</div>

        <div style="display: flex; gap: 6px; width: max-content; margin: 0 auto; margin-top: 30px;">
          <button id="close-modal-btn">Cancel</button>
          {render_slot(@trigger)}
        </div>
      </div>
    </div>
    """
  end

  def delete_contact_modal(assigns) do
    ~H"""
    <.modal>
      <p>Are you sure you want to delete this contact?</p>

      <:trigger>
        <form id="delete-contact-form" method="post">
          <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
          <input type="hidden" name="_method" value="delete" />
          <button type="submit">Delete</button>
        </form>
      </:trigger>
    </.modal>
    """
  end
end
