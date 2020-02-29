function contactForm() {
  div = document.getElementById('expandable');
  legend = document.getElementById('legend');
  div.removeAttribute('class');
  legend.removeAttribute('class');
}

document.getElementById('contact').addEventListener("click", contactForm);
