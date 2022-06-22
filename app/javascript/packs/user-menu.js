document.addEventListener('turbolinks:load', function() {
  const menuIcon = document.querySelector('header .user-menu')
  const dropdown = document.querySelector('header .user-menu .dropdown');
  let menuVisible = false;

  if (dropdown) {
    menuIcon.addEventListener('click', () => {
      if (menuVisible) {
        dropdown.style.display = 'none';
        menuVisible = false;
      } else {
        dropdown.style.display = 'flex';
        menuVisible = true;
      }
    });
  }

  document.addEventListener('click', (event) => {
    if (menuVisible && !event.target.closest('header .user-menu')) {
      dropdown.style.display = 'none';
      menuVisible = false;
    }
  });
});