export default OpenDeleteContactModalConfirmation = {
  mounted() {
    const modal = document.querySelector(".modal");
    const hiddenContactIdInput = modal.querySelector(
      "#contact-id-hidden-input"
    );

    this.el.addEventListener("click", (e) => {
      const contactId = e.target.dataset.contactId;
      modal.classList.remove("hidden");
      hiddenContactIdInput.value = contactId;
    });

    this.handleEvent("contact_deleted", () => {
      modal.classList.add("hidden");
    });
  },
};
