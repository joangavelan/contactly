const openModalBtns = document?.querySelectorAll(
  ".btn-open-delete-contact-confirmation-modal"
);
const modal = document?.querySelector(".modal");
const form = modal?.querySelector("#delete-contact-form");
const closeModalButton = modal?.querySelector("#close-modal-btn");

openModalBtns?.forEach((button) => {
  button.addEventListener("click", (e) => {
    const contactId = e.target.dataset.contactId;

    modal.classList.remove("hidden");
    form.action = `/mvc/contacts/${contactId}`;
  });
});

closeModalButton?.addEventListener("click", () => {
  modal.classList.add("hidden");
});
