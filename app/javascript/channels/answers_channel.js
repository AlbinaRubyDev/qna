import consumer from "channels/consumer"

let subscription_answer

function subscribeToAnswers() {
  const answersList = document.querySelector(".answers-list")
  if (!answersList) return

  if (subscription_answer) {
    consumer.subscriptions.remove(subscription_answer)
  }

  subscription_answer = consumer.subscriptions.create("AnswersChannel", {
    connected() {
      const answersList = document.querySelector(".answers-list")
      if (!answersList) return
      this.perform("follow", {
        question_id: answersList.dataset.questionId
      })
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
  })
}

document.addEventListener("turbo:load", subscribeToAnswers);
