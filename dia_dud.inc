% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Driver update dialog.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Some global vars.
%
/.dud_yes	0 def
/.dud_no	1 def

/dud.default .dud_no def

/dud.options [
  "updatemodules"
  ""
] def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Build driver update menu.
%
% ( ) ==> ( )
%
/dud.init {
  /xmenu.dud .xm_size array def

  /xmenu xmenu.dud def

  xmenu .xm_current dud.default put
  xmenu .xm_list [ /txt_yes /txt_no ] put

  xmenu .xm_title /txt_driver_update put

  pmenu.init
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Update driver update mode.
%
% ( ) ==> ( )
%
/dud.update {
  /xmenu xmenu.dud def

  /window.action actRedrawPanel def

  pmenu.update
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Show driver update menu.
%
% ( ) => ( )
%
/panel.dud {
  "driverupdate" help.setcontext

  window.xmenu
  dup .xmenu xmenu.dud put
  dup .xmenu.update /dud.update put
  dup window.init
      window.show
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Return width of panel entry.
%
% ( ) => ( width )
%
/panel.dud.width {
  /xmenu xmenu.dud def

  pmenu.width
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Redraw panel entry.
%
% ( panel ) => ( )
%
/panel.dud.update {
  /xmenu xmenu.dud def

  pmenu.panel.update
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
/dud.dialog {

  /dia window.dialog def

  dia .text "" put

  xmenu .xm_current get

  pop

  dia .ed.focus 0 put
  dia .ed.width 300 put

  dia .buttons [
    button.ok button.default actNothing button.setaction
    button.cancel button.notdefault actNothing button.setaction
  ] put

  dia window.init
  dia window.show

} def


