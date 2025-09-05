(function ($) {
	"use strict";

	// Sticky Navbar
	$(window).scroll(function () {
		if ($(this).scrollTop() > 30) {
			$('.header-nav').addClass('nav-sticky');
		} else {
			$('.header-nav').removeClass('nav-sticky');
		}
	});
	if ($(window).scrollTop() > 30) {
		$('.header-nav').addClass('nav-sticky');
	}
	var new_width = $('.header-nav').width();
	$('.navbar').width(new_width - 32);


	// Smooth scrolling on the navbar links
	$(".navbar-nav a").on('click', function (event) {
		if (this.hash !== "") {
			event.preventDefault();

			$('html, body').animate({
				scrollTop: $(this.hash).offset().top - 50
			}, 1500, 'easeInOutExpo');

			if ($(this).parents('.navbar-nav').length) {
				$('.navbar-nav .active').removeClass('active');
				$(this).closest('a').addClass('active');
			}
		}
	});

})(jQuery);

Array.from(document.querySelectorAll(".btn-launch-modal")).map(function(x) {
	x.onclick = function () {
		MathJax.typesetPromise([".math-table"]);
	}
})

// document.getElementById("one-sem-practise-btn").onclick = function () {
// 	const mathContainer = document.getElementById('one-sem-practise-table');
// 	MathJax.typesetPromise([mathContainer]).then(() => {
// 		console.log('MathJax typesetting complete for one-sem-practise-table container.');
// 	}).catch((err) => console.log('Typeset failed:', err.message));
// };

// document.getElementById("two-sem-practise-btn").onclick = function () {
// 	const mathContainer = document.getElementById('two-sem-practise-table');
// 	MathJax.typesetPromise([mathContainer]).then(() => {
// 		console.log('MathJax typesetting complete for two-sem-practise-table container.');
// 	}).catch((err) => console.log('Typeset failed:', err.message));
// };
