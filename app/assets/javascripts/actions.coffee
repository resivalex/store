$(document).ready ->
  mySwiper = new Swiper '.swiper-container',
    direction: 'vertical'
    loop: true,
    
    pagination: '.swiper-pagination'
    
    nextButton: '.swiper-button-next'
    prevButton: '.swiper-button-prev'
    
    scrollbar: '.swiper-scrollbar'
  
    autoplay: 3000
    autoplayDisableOnInteraction: false

    $('#left-menu').slicknav
        label : ''
        prependTo: '#ccc'
