# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.img-del').click (e)->
    $.ajax
      type: 'DELETE',
      url: '/users/delete_img',
      success: res ->
        console.log($(this).html())


