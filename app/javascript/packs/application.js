// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application.scss"
import '@fortawesome/fontawesome-free/js/all'

Rails.start()
Turbolinks.start()
ActiveStorage.start()


// フォローボタンクリック時の連打によるバグを防ぐため、フォローボタン押下後画面遷移までアニメーションを挿入。
$(function() {
    $('.btn-follow').on('click', function() {
        $('.btn-follow').hide();
        $('.loading').show();

    });
});

// タブ機能の非同期化のための記述。全投稿を持ってきた後でタブにより表示するものを変化させる。
// turbolinksの無効化
$(document).on('turbolinks:load', function() {
  $(function() {
    // .tabがクリックされたときを指定
    $('.tab').click(function(){
      // 今ある.tab-activeを削除
      $('.tab-active').removeClass('tab-active');
      // クリックされた.tabに.tab-activeを追加
      $(this).addClass('tab-active');
      // 今ある.box-showを削除
      $('.box-show').removeClass('box-show');
      // indexに.tabのindex番号を代入
      const index = $(this).index();
      // .tabboxとindexの番号が同じ要素に.box-showを追加
      $('.tabbox').eq(index).addClass('box-show');
    });
  });
});
