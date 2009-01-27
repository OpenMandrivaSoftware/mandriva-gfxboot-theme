% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Video mode selection dialog.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Some global vars.
%
% video mode array fields
/video.default 2 def
/video.modes.list [ 0 785 788 791 ] def
/video.modes.text [ "Text" "640 x 480" "800 x 600" "1024 x 768" ] def

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Build video mode list.
%
% ( ) ==> ( )
%
/video.init {
  /xmenu.video .xm_size array def

  /xmenu xmenu.video def

  xmenu .xm_list video.modes.text put
  xmenu .xm_title .undef put
  xmenu .xm_current video.default put
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Update video mode.
%
% ( ) ==> ( )
%
/video.update {
  /xmenu xmenu.video def

  /window.action actRedrawPanel def
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Show video menu.
%
% ( ) => ( )
%
/panel.video {
  "videomode" help.setcontext

  window.xmenu
  dup .xmenu xmenu.video put
  dup .xmenu.update /video.update put
  dup window.init
      window.show
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Return width of video entry.
%
% ( ) => ( width )
%
/panel.video.width {
  /xmenu xmenu.video def

  pmenu.width
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Redraw panel entry.
%
% ( panel ) => ( )
%
/panel.video.update {
  /xmenu xmenu.video def

  pmenu.panel.update
} def
