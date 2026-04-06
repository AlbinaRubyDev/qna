import consumer from "channels/consumer"

let subscription_comment

function subscribeToComments() {
  const commentsList = document.querySelector(".comments")
  if (!commentsList) return

  if (subscription_comment) {
    consumer.subscriptions.remove(subscription_comment)
  }

  subscription_comment = consumer.subscriptions.create("CommentsChannel", {
    connected() {
      const comments = document.querySelector(".comments")
      if (!comments) return
      this.perform("follow", {
        commentable_type: comments.dataset.commentableType,
        commentable_id: comments.dataset.commentableId
      })
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const comments = document.querySelector(".comments")
      if (!comments) return

      comments.insertAdjacentHTML(
          "beforeend",
          `<p>${data.body}</p>`
      )
    }
  })
}

document.addEventListener("turbo:load", subscribeToComments);
