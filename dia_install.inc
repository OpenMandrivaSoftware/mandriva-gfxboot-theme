% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Install mode selection dialog.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Some global vars.
%
/install.option 255 string def

% install types
/.inst_cdrom	0 def
/.inst_other	1 def

/install.last .inst_cdrom def

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Build install mode list.
%
% ( ) ==> ( )
%
/install.init {
  /xmenu.install .xm_size array def

  /xmenu xmenu.install def

  install.option install.last .inst_cdrom eq { "automatic=method:cdrom" } { "" } ifelse strcpy

  xmenu .xm_current install.last put

  % see install types (.inst_*)
  xmenu .xm_list [ is_dvd { "DVD" } { "CD-ROM" } ifelse "Other" ] put

  pmenu.init
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Update install mode.
%
% ( ) ==> ( )
%
/install.update {
  /xmenu xmenu.install def

    /install.last xmenu .xm_current get def

    install.option install.last .inst_cdrom eq { "automatic=method:cdrom" } { "" } ifelse strcpy

    /window.action actRedrawPanel def

    pmenu.update

} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Show install menu.
%
% ( ) => ( )
%
/panel.install {
  "install_src" help.setcontext

  window.xmenu
  dup .xmenu xmenu.install put
  dup .xmenu.update /install.update put
  dup window.init
      window.show
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Return width of panel entry.
%
% ( ) => ( width )
%
/panel.install.width {
  /xmenu xmenu.install def

  pmenu.width
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Redraw panel entry.
%
% ( panel ) => ( )
%
/panel.install.update {
  /xmenu xmenu.install def

  pmenu.panel.update
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -




/install.ok {
  /xmenu xmenu.install def

  window.done

  /install.last xmenu .xm_current get def

  /window.action actRedrawPanel def

  pmenu.update

} def


/install.cancel {
  /xmenu xmenu.install def

  xmenu .xm_current install.last put

%  /window.action actRedrawPanel def
%  pmenu.update
} def

