import consumer from "channels/consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    this.perform("follow")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const questionsList = document.querySelector(".questions-list")
    if (!questionsList) return
    questionsList.insertAdjacentHTML("beforeend", data)
  }
});
