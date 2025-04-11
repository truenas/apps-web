let currentImageIndex = 0;
let images = [];

function openLightbox(imageSrc) {
  const lightbox = document.getElementById("lightbox");
  const lightboxImage = document.getElementById("lightbox-image");

  // Move the lightbox to the correct location in the DOM
  const container = document.querySelector("main.container.flex");
  if (container && lightbox.parentNode !== container) {
    container.appendChild(lightbox);
  }

  // Set the current image
  lightboxImage.src = imageSrc;
  lightbox.style.display = "flex";

  // Find the index of the current image
  currentImageIndex = images.indexOf(imageSrc);

  // Add keyboard navigation event listener
  document.addEventListener("keydown", handleKeyNavigation);
}

function closeLightbox() {
  const lightbox = document.getElementById("lightbox");
  lightbox.style.display = "none";

  // Remove keyboard navigation event listener
  document.removeEventListener("keydown", handleKeyNavigation);
}

function prevImage(event) {
  if (event) event.stopPropagation(); // Prevent closing the lightbox
  currentImageIndex = (currentImageIndex - 1 + images.length) % images.length;
  document.getElementById("lightbox-image").src = images[currentImageIndex];
}

function nextImage(event) {
  if (event) event.stopPropagation(); // Prevent closing the lightbox
  currentImageIndex = (currentImageIndex + 1) % images.length;
  document.getElementById("lightbox-image").src = images[currentImageIndex];
}

function handleKeyNavigation(event) {
  if (event.key === "ArrowLeft") {
    prevImage();
  } else if (event.key === "ArrowRight") {
    nextImage();
  } else if (event.key === "Escape") {
    closeLightbox();
  }
}

// Initialize the images array and add event listeners
document.addEventListener("DOMContentLoaded", () => {
  const lightbox = document.getElementById("lightbox");
  const lightboxImage = document.getElementById("lightbox-image");
  const thumbnails = document.querySelectorAll(".screenshot-thumbnail");

  // Check if the required elements exist
  if (!lightbox || !lightboxImage || thumbnails.length === 0) {
    console.warn("Lightbox elements not found on this page. Skipping initialization.");
    return;
  }

  // Initialize the lightbox functionality
  images = Array.from(thumbnails).map((img) => img.src);

  lightbox.addEventListener("click", (event) => {
    if (event.target === lightbox) {
      closeLightbox();
    }
  });

  lightboxImage.addEventListener("click", (event) => {
    event.stopPropagation();
  });
});