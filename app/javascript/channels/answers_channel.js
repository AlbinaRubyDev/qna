import consumer from "channels/consumer"

consumer.subscriptions.create("AnswersChannel", {
  connected() {
    const answersList = document.querySelector(".answers-list")
    if (!answersList) return
    this.perform("follow", { question_id: answersList.dataset.questionId })
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const answersList = document.querySelector(".answers-list")
    if (!answersList) return

    answersList.insertAdjacentHTML(
      "beforeend",
      `<turbo-frame id = "answer_${data.id}">
         <p>${data.body}</p>
       </turbo-frame>`
    )
  }
});
