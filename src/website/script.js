const boxes = document.querySelectorAll('.box'); // Select all elements with class 'box'
window.addEventListener('scroll', checkBoxes); // Add scroll event listener
var modal = document.getElementById('myModal'); // Get the modal
copyrightFooter = document.getElementById('copyright');

// Get the image and insert it inside the modal - use its "alt" text as a caption
var modalImg = document.getElementById("img01");
var captionText = document.getElementById("caption");

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

function checkBoxes() {
    const triggerBottom = window.innerHeight / 5 * 4; // Animation Trigger point at 80% of viewport height
    boxes.forEach(box => {
        const boxTop = box.getBoundingClientRect().top; // Get the top position of the box relative to viewport
        if (boxTop < triggerBottom) {
            box.classList.add('show'); // Add 'show' class to trigger animation
        } else {
            box.classList.remove('show'); // Remove 'show' class to reset animation
        }
    });
}

function showModalPopup(src, alt) {
    modal.style.display = "block";
    modalImg.src = src;
    captionText.innerHTML = alt;
    document.body.style.overflowY = 'hidden';
}

// When the user clicks on <span> (x), close the modal
span.onclick = function () {
    modal.style.display = "none";
    document.body.style.overflowY = 'auto';
}

function UpdateCopyrightFooter() {
    copyrightFooter.innerHTML = `&copy;R&R ShutterWorks ${new Date().getFullYear()}`;
}
UpdateCopyrightFooter();