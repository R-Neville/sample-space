document.addEventListener('turbolinks:load', function() {
  const menu = document.getElementById('menu');
  const hamburger = document.querySelector('header .hamburger');
  let hamburgerLines;
 
  if (hamburger) {
    hamburgerLines = hamburger.querySelectorAll('.line');
  }

  let menuVisible = false;

  if (menu) {
    window.onresize =  function() {
      // Ensure that the menu is hidden when the 
      // page is resized above responsive breakpoint:
      if (window.innerWidth >= 760 && menuVisible) {
        menu.style.display = 'none';
        menuVisible = false;
        horizontaliseHamburger();
        partHambugerLinesVertically();
      }
    };
  
    hamburger.addEventListener('click', handleHamburgerClick);
  }

  function handleHamburgerClick() {
    if (!menuVisible) {
      slideDown(menu, 'flex', 10); // Show menu
      menuVisible = true;
      verticaliseHamburger();
      partHamburgerLinesHorizontally();
    } else {
      slideUp(menu, 10); // Hide menu
      menuVisible = false;
      horizontaliseHamburger();
      partHambugerLinesVertically();
    }
  }

  const MIN_INTERVAL_DURATION = 10;

  // Transitions hamburger lines to a
  // vertical state ready for animation:
  function verticaliseHamburger() {
    hamburgerLines.forEach(line => {
      line.style.display = 'none';
    });

    hamburger.style.flexDirection = 'row';
    
    hamburgerLines.forEach(line => {
      line.style.height = '35px';
      line.style.width = '10px';
      line.style.display = 'block';
    });
  }

  // Animates the separation of hamgurger lines
  // when vertical:
  function partHamburgerLinesHorizontally() {
    const targetWidth = 7;
    let currentWidth = 10;
    const intervalID = setInterval(() => {
      if (currentWidth <= targetWidth) {
        clearInterval(intervalID);
      } else {
        currentWidth -= 0.25;
        hamburgerLines.forEach(line => {
          line.style.width = currentWidth + 'px';
        });
      }
    }, 5);
  }

  // Transitions hamburger lines to a
  // horizontal state ready for animation:
  function horizontaliseHamburger() {
    hamburgerLines.forEach(line => {
      line.style.display = 'none';
    });

    hamburger.style.flexDirection = 'column';
    
    hamburgerLines.forEach(line => {
      line.style.height = '10px';
      line.style.width = '35px';
      line.style.display = 'block';
    });
  }

  // Animates the separation of hamburger lines
  // when horizontal:
  function partHambugerLinesVertically() {
    const targetHeight = 7;
    let currentHeight = 10;
    const intervalID = setInterval(() => {
      if (currentHeight <= targetHeight) {
        clearInterval(intervalID);
      } else {
        currentHeight -= 0.25;
        hamburgerLines.forEach(line => {
          line.style.height = currentHeight + 'px';
        });
      }
    }, 5);
  }

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