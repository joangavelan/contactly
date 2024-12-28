defmodule ContactlyWeb.Pages.Contacts.Components do
  use Phoenix.Component

  def contact_form(assigns) do
    ~H"""
    <form phx-submit="save">
      <div>
        <label>Name:</label>
        <input id="name" type="text" name="contact_form[name]" />
      </div>
      <div>
        <label>Email:</label>
        <input id="email" type="email" name="contact_form[email]" />
      </div>
      <div>
        <label>Phone:</label>
        <input id="phone" type="text" name="contact_form[phone]" />
      </div>

      <button type="submit">Save contact</button>
    </form>
    """
  end
end
