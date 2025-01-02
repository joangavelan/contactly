export default OpenDeleteContactModalConfirmation = {
  mounted() {
    const modal = document.querySelector(".delete-contact-modal");
    const hiddenContactIdInput = modal.querySelector(
      "#contact-id-hidden-input"
    );

    function openModal(contactId) {
      modal.classList.remove("hidden");
      hiddenContactIdInput.value = contactId;
    }

    this.el.addEventListener("click", (e) => {
      const contactId = e.target.dataset.contactId;
      openModal(contactId);
    });
  },
};
