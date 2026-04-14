_: {
  files = {
    ".config/glide/glide.ts".text = ''
      const autohide_main_toolbar = css`
          :root {
              --uc-navbar-transform: -40px;
              --uc-autohide-toolbar-delay: 1.8s;
              --uc-autohide-toolbar-duration: 400ms;
          }
          :root[uidensity='compact'] {
              --uc-navbar-transform: -34px;
          }

          #navigator-toolbox > div {
              display: contents;
          }

          #navigator-toolbox::before {
              content: '\';
              position: fixed;
              top: 0;
              left: 0;
              right: 0;
              height: 16px;
              background: transparent;
              z-index: 1;
              pointer-events: auto;
          }

          #TabsToolbar,
          #nav-bar,
          #PersonalToolbar {
              position: relative;
              z-index: 2;
          }

          #navigator-toolbox:is(:hover, :focus-within) #TabsToolbar {
              z-index: 10002;
              transform: none !important;
              opacity: 1 !important;
          }
          #navigator-toolbox:is(:hover, :focus-within) :is(#nav-bar, #PersonalToolbar) {
              z-index: 10001;
          }
          #navigator-toolbox:is(:hover, :focus-within) :is(#PanelUI-button, #PanelUI-menu-button) {
              position: relative;
              z-index: 10003;
          }
          :root
              :where(
                  #nav-bar,
                  #PersonalToolbar,
                  #tab-notification-deck,
                  .global-notificationbox,
                  #notifications-toolbar
              ) {
              transform: translateY(var(--uc-navbar-transform));
          }
          :root:is([customizing], [chromehidden*='toolbar'])
              :where(
                  #nav-bar,
                  #PersonalToolbar,
                  #tab-notification-deck,
                  .global-notificationbox,
                  #notifications-toolbar
              ) {
              transform: none !important;
              opacity: 1 !important;
          }

          #nav-bar:not([customizing]) {
              opacity: 0;
              transition:
                  transform var(--uc-autohide-toolbar-duration) ease var(--uc-autohide-toolbar-delay),
                  opacity var(--uc-autohide-toolbar-duration) ease var(--uc-autohide-toolbar-delay) !important;
              position: relative;
              z-index: 2;
          }

          #navigator-toolbox,
          #sidebar-box,
          #sidebar-main,
          #sidebar-splitter,
          #tabbrowser-tabbox {
              z-index: auto !important;
          }
          #navigator-toolbox:focus-within > :is(#nav-bar, #PersonalToolbar) {
              transform: translateY(0);
              opacity: 1;
              transition-duration:
                  var(--uc-autohide-toolbar-duration), var(--uc-autohide-toolbar-duration) !important;
              transition-delay: 0s !important;
          }
          .browser-titlebar:hover ~ :is(#nav-bar, #PersonalToolbar),
          #TabsToolbar:hover ~ :is(#nav-bar, #PersonalToolbar),
          #navigator-toolbox:hover :is(#nav-bar, #PersonalToolbar),
          #nav-bar:hover,
          #nav-bar:hover + #PersonalToolbar {
              transform: translateY(0);
              opacity: 1;
              transition-duration:
                  var(--uc-autohide-toolbar-duration), var(--uc-autohide-toolbar-duration) !important;
              transition-delay: 500ms !important;
          }
          :root #urlbar[popover] {
              opacity: 0;
              pointer-events: none;
              transition:
                  transform var(--uc-autohide-toolbar-duration) ease var(--uc-autohide-toolbar-delay),
                  opacity var(--uc-autohide-toolbar-duration) ease var(--uc-autohide-toolbar-delay);
              transform: translateY(var(--uc-navbar-transform));
          }
          #mainPopupSet:has(
                  > [panelopen]:not(
                          #ask-chat-shortcuts,
                          #selection-shortcut-action-panel,
                          #chat-shortcuts-options-panel,
                          #tab-preview-panel
                      )
              )
              ~ toolbox
              #urlbar[popover],
          #navigator-toolbox:hover #urlbar[popover],
          #TabsToolbar:hover ~ #nav-bar #urlbar[popover],
          .browser-titlebar:is(:hover, :focus-within) ~ #nav-bar #urlbar[popover],
          #nav-bar:is(:hover, :focus-within) #urlbar[popover],
          #urlbar-container > #urlbar[popover]:is([focused], [open]) {
              opacity: 1;
              pointer-events: auto;
              transition-delay: 0ms;
              transform: translateY(0);
          }
          :where(:root) #urlbar-container > #urlbar[popover]:is([focused], [open]) {
              transition-duration: 100ms; /* Faster when focused */
          }
          #mainPopupSet:has(
                  > [panelopen]:not(
                          #ask-chat-shortcuts,
                          #selection-shortcut-action-panel,
                          #chat-shortcuts-options-panel,
                          #tab-preview-panel
                      )
              )
              ~ #navigator-toolbox
              > :is(#nav-bar, #PersonalToolbar) {
              transition-delay: 33ms !important;
              transform: translateY(0);
              opacity: 1;
          }
          #nav-bar.browser-titlebar {
              background: inherit;
          }
          #toolbar-menubar:not([autohide='true'], [autohide='\']) ~ #nav-bar.browser-titlebar {
              background-position-y: -28px; /* best guess, could vary */
              border-top: none !important;
          }

          #PersonalToolbar {
              transition: transform var(--uc-autohide-toolbar-duration) ease
                  var(--uc-autohide-toolbar-delay) !important;
              position: relative;
              z-index: 1;
          }

          :root:not([chromehidden~='toolbar']) > body > #browser {
              margin-top: var(--uc-navbar-transform);
          }
          @media -moz-pref('browser.fullscreen.autohide') {
              :root[sizemode='fullscreen'] > body > #browser {
                  margin-top: revert;
              }
          }
          @media -moz-pref('userchrome.autohide-main-toolbar.tabs-on-bottom-patch.enabled') {
              #nav-bar {
                  margin-bottom: var(--uc-navbar-transform);
              }
              #TabsToolbar:not([customizing]) {
                  transition: transform var(--uc-autohide-toolbar-duration) ease
                      var(--uc-autohide-toolbar-delay) !important;
                  position: relative;
                  z-index: 1;
                  background: inherit !important;
              }
              #mainPopupSet:has(
                      > [panelopen]:not(
                              #ask-chat-shortcuts,
                              #selection-shortcut-action-panel,
                              #chat-shortcuts-options-panel,
                              #tab-preview-panel
                          )
                  )
                  ~ #navigator-toolbox
                  > #TabsToolbar,
              #navigator-toolbox:is(:hover, :focus-within) > #TabsToolbar {
                  transform: translateY(calc(var(--uc-navbar-transform) * -1)) !important;
                  transition-duration:
                      var(--uc-autohide-toolbar-duration), var(--uc-autohide-toolbar-duration) !important;
                  transition-delay: 0s !important;
              }
              :root[sizemode] > body > #browser {
                  margin-top: revert;
              }
          }
      `;
      glide.styles.add(autohide_main_toolbar);
    '';
  };
}
