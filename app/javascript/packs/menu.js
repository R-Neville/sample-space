document.addEventListener('turbolinks:load', function() {
  const menu = document.getElementById('menu');
  const headerHamburger = document.querySelector('header .hamburger');
  let menuVisible = false;

  window.onresize =  function() {
    if (window.innerWidth >= 760 && menuVisible) {
      menu.style.display = 'none';
      menuVisible = false;
    }
  };

  headerHamburger.addEventListener('click', () => {
    if (menuVisible) {
      slideUp(menu, 10);
      menuVisible = false;
    } else {
      slideDown(menu, 'flex', 10);
      menuVisible = true;
    }
  });

  const MIN_INTERVAL_DURATION = 10; 

  function slideDown(element, displayType, durationFactor) {
    if (element.style.display === displayType) {
      // The element is already displayed.
      // Abort transition.
      return;
    }
  
    // Get the elements display height
    // and prepare for transition:
    element.style.visibility = 'hidden';
    const oldOverflow = element.style.overflowY;
    element.style.overflowY = 'hidden';
    element.style.display = displayType;
    const targetHeight = element.getBoundingClientRect().height;
    element.style.height = 0;
    element.style.visibility = 'visible';
  
    // Perform transition:
    const HEIGHT_INCREMENT = targetHeight / durationFactor;
    let currentHeight = 0;
    
    const intervalID = setInterval(() => {
      durationFactor -= 1;
      currentHeight += HEIGHT_INCREMENT;
      element.style.height = currentHeight + 'px';
      if (durationFactor === 0) {
        element.style.height = 'auto';
        element.style.overflowY = oldOverflow;
        clearInterval(intervalID);
      }
    }, MIN_INTERVAL_DURATION);
  }

  function slideUp(element, durationFactor) {
    if (element.style.display === 'none') {
      // The element is already not displayed.
      // Abort transition.
      return;
    }
  
    // Perform transition:
    let currentHeight = element.getBoundingClientRect().height;
    const HEIGHT_INCREMENT = currentHeight / durationFactor;

    const oldOverflow = element.style.overflowY;
    element.style.overflowY = 'hidden';
    
    const intervalID = setInterval(() => {
      durationFactor -= 1;
      currentHeight -= HEIGHT_INCREMENT;
      element.style.height = currentHeight + 'px';
      if (durationFactor === 0) {
        element.style.display = 'none';
        element.style.height = 'auto';
        element.style.overflowY = oldOverflow;
        clearInterval(intervalID);
      }
    }, MIN_INTERVAL_DURATION);
  }
});