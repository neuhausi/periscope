# fw_create_header

    <header class="main-header">
      <span class="logo">
        <div class="periscope-busy-ind">
          Working
          <img alt="Working..." hspace="5px" src="img/loader.gif"/>
        </div>
      </span>
      <nav class="navbar navbar-static-top" role="navigation">
        <span style="display:none;">
          <i class="fas fa-bars" role="presentation" aria-label="bars icon"></i>
        </span>
        <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
          <span class="sr-only">Toggle navigation</span>
        </a>
        <div class="navbar-custom-menu">
          <ul class="nav navbar-nav"></ul>
        </div>
      </nav>
    </header>

# fw_create_sidebar no sidebar

    <aside id="sidebarCollapsed" class="main-sidebar" data-collapsed="true">
      <section id="sidebarItemExpanded" class="sidebar">
        <script>$("<div class='periscope-title'> Set using set_app_parameters() in program/global.R </div>").insertAfter($("a.sidebar-toggle"));</script>
        <script>$('[class~="sidebar-toggle"]').remove();</script>
      </section>
    </aside>

# fw_create_sidebar empty

    <aside id="sidebarCollapsed" class="main-sidebar" data-collapsed="false">
      <section id="sidebarItemExpanded" class="sidebar">
        <script>$("<div class='periscope-title'> Set using set_app_parameters() in program/global.R </div>").insertAfter($("a.sidebar-toggle"));</script>
      </section>
    </aside>

# fw_create_sidebar only basic

    <aside id="sidebarCollapsed" class="main-sidebar" data-collapsed="false">
      <section id="sidebarItemExpanded" class="sidebar">
        <script>$("<div class='periscope-title'> Set using set_app_parameters() in program/global.R </div>").insertAfter($("a.sidebar-toggle"));</script>
        <div class="notab-content">
          <p></p>
        </div>
      </section>
    </aside>

# fw_create_sidebar only advanced

    <aside id="sidebarCollapsed" class="main-sidebar" data-collapsed="false">
      <section id="sidebarItemExpanded" class="sidebar">
        <script>$("<div class='periscope-title'> Set using set_app_parameters() in program/global.R </div>").insertAfter($("a.sidebar-toggle"));</script>
        <div class="notab-content">
          <p></p>
          <div align="center">
            <button id="appResetId-resetButton" style="width:90%;" type="button" class="btn sbs-toggle-button btn-warning btn-sm btn-block">Reset Application</button>
            <span class="invisible">
              <button id="appResetId-resetPending" type="button" class="btn btn-default sbs-toggle-button"></button>
            </span>
          </div>
        </div>
      </section>
    </aside>

# fw_create_body app_info

    <div class="content-wrapper">
      <section class="content">
        <script>$('.navbar-custom-menu').on('click',
                                               function() {
                                                   main_width = $('.main-sidebar').css('width');
                                                   if ($('.control-sidebar-open').length != 0) {
                                                       $('.control-sidebar-open').css('width', main_width);
                                                       $('.control-sidebar-bg').css('width', main_width);
                                                       $('.control-sidebar-bg').css('right', '0px' );
                                                       $('.control-sidebar').css('right', '0px');
                                                   } else {
                                                      $('.control-sidebar-bg').css('right', '-' + main_width);
                                                      $('.control-sidebar').css('right', '-' +  main_width);
                                                      $('.control-sidebar').css('width', '-' +  main_width);
                                                   }
                                               });</script>
        <script>$('.logo').css('background-color', $('.navbar').css('background-color'))</script>
        <div class="modal sbs-modal fade" id="titleinfobox" tabindex="-1" data-sbs-trigger="titleinfobox_trigger">
          <div class="modal-dialog modal-lg">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                  <span>&times;</span>
                </button>
                <h4 class="modal-title">Set using set_app_parameters() in program/global.R</h4>
              </div>
              <div class="modal-body"><b>app_info</b></div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>
        <div class="col-sm-12">
          <div class="box collapsed-box">
            <div class="box-header">
              <h3 class="box-title">User Action Log</h3>
              <div class="box-tools pull-right">
                <button class="btn btn-box-tool" data-widget="collapse">
                  <i class="fas fa-plus" role="presentation" aria-label="plus icon"></i>
                </button>
              </div>
            </div>
            <div class="box-body" id="footerId-userlog">
              <div id="footerId-dt_userlog" class="shiny-html-output"></div>
            </div>
          </div>
        </div>
      </section>
    </div>

# fw_create_body no log

    <div class="content-wrapper">
      <section class="content">
        <script>$('.navbar-custom-menu').on('click',
                                               function() {
                                                   main_width = $('.main-sidebar').css('width');
                                                   if ($('.control-sidebar-open').length != 0) {
                                                       $('.control-sidebar-open').css('width', main_width);
                                                       $('.control-sidebar-bg').css('width', main_width);
                                                       $('.control-sidebar-bg').css('right', '0px' );
                                                       $('.control-sidebar').css('right', '0px');
                                                   } else {
                                                      $('.control-sidebar-bg').css('right', '-' + main_width);
                                                      $('.control-sidebar').css('right', '-' +  main_width);
                                                      $('.control-sidebar').css('width', '-' +  main_width);
                                                   }
                                               });</script>
        <script>$('.logo').css('background-color', $('.navbar').css('background-color'))</script>
      </section>
    </div>

# ui_tooltip

    <span class="periscope-input-label-with-tt">
      mylabel
      <img id="id" src="img/tooltip.png" height="16px" width="16px"/>
      <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('id', 'tooltip', {'placement': 'top', 'trigger': 'hover', 'title': 'mytext'})}, 500)});</script>
    </span>

# fw_create_header_plus

    <header class="main-header">
      <span class="logo">
        <div class="periscope-busy-ind">
          Working
          <img alt="Working..." hspace="5px" src="img/loader.gif"/>
        </div>
      </span>
      <nav class="navbar navbar-static-top" role="navigation">
        <span style="display:none;">
          <i class="fas fa-bars" role="presentation" aria-label="bars icon"></i>
        </span>
        <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
          <span class="sr-only">Toggle navigation</span>
        </a>
        <div class="navbar-custom-menu" style="float: left; margin-left: 10px;">
          <ul class="nav navbar-nav"></ul>
        </div>
        <div class="navbar-custom-menu">
          <ul class="nav navbar-nav">
            <li>
              <a href="#" data-toggle="control-sidebar">
                <i class="fas fa-gears" role="presentation" aria-label="gears icon"></i>
              </a>
            </li>
          </ul>
        </div>
      </nav>
    </header>

# fw_create_right_sidebar

    <aside id="controlbarId" data-collapsed="true" data-overlay="true" data-show="true" class="control-sidebar control-sidebar-dark" style="width: 230px;">
      <div class="sbs-alert" id="sidebarRightAlert"> </div>
    </aside>
    <div class="control-sidebar-bg"></div>

# fw_create_right_sidebar SDP>=2

    <aside id="controlbarId" data-collapsed="true" data-overlay="true" data-show="true" class="control-sidebar control-sidebar-dark" style="width: 230px;">
      <div class="sbs-alert" id="sidebarRightAlert"> </div>
    </aside>
    <div class="control-sidebar-bg"></div>

