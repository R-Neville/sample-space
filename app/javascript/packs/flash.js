document.addEventListener('turbolinks:load', function() {
  const flashMessages = document.querySelectorAll('.flash');
  flashMessages.forEach((message) => {
    message.querySelector('button').addEventListener('click', () => {
      message.remove();
    });
  });
});