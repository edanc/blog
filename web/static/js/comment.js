let Comment = {
  init(socket, element){
    if(!element){ return }
    socket.connect();
    let postId = element.getAttribute("data-id");
    this.onReady(postId, socket);
  },

  onReady(postId, socket ){
    let post = postId;
    let msgContainer = document.getElementById("msg-container")
    let msgInput     = document.getElementById("msg-input")
    let postButonn   = document.getElementById("msg-submit")
    let commentChannel   = socket.channel("posts:" + postId)

    postButonn.addEventListener("click", e => {
      let payload = {content: msgInput.value }
      commentChannel.push("new_comment", payload)
        .receive("error", e => console.log(e))
      msgInput.value = ""
    })

    commentChannel.on("new_comment", (resp) => {
      this.renderComments(msgContainer, [resp])
    })

    //join the vid channel
    commentChannel.join()
      .receive("ok", (resp) => {
        this.renderComments(msgContainer, resp.comments)
      })
      .receive("error", reason => console.log("join failed", reason))
  },

  renderComments(msgContainer, comments,){
    comments.map((comment) => {
      let template = document.createElement("div")
      template.innerHTML = `
        <td>
          ${comment.content}
        </td>
        `
      msgContainer.appendChild(template)
    })
  },
}
export default Comment
