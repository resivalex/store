$ ->
  mySwiper = new Swiper '.swiper-container',
    direction: 'horizontal'
    loop: true
    
    pagination: '.swiper-pagination'
    paginationClickable: true
    
    nextButton: '.swiper-button-next'
    prevButton: '.swiper-button-prev'
    
    scrollbar: '.swiper-scrollbar'
  
    autoplay: 6000
    autoplayDisableOnInteraction: false

  $('#left-menu').slicknav
    label : ''
    prependTo: '#ccc'

$(document).on 'click', '.submenu-title', ->
  $('.submenu').addClass 'hidden'
  $submenu = $(@).parent().find('.submenu')
  $submenu.removeClass 'hidden'
  return false;

$(document).click (event) ->
    unless $(event.target).closest('.submenu').length > 0 || $(event.target).is('.submenu')
      $('.submenu').addClass 'hidden'

$(document).on 'click', '.cart-item-delete .delete', ->
  $(@).closest('.math').find('.line_item_quantity').val(0)
  $(@).closest('form').submit()