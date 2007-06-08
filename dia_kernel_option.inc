% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% kernel option selection dialog.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Some global vars.
%
/kernel_option.list [
  ""
  "noapic"
  "nolapic"
  "acpi=off"
  "acpi=ht"
  "pci=nomsi"
  "pci=nommconf"
  "reboot=b"
] def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Build menu list.
%
% ( ) ==> ( )
%
/kernel_option.init {
  /xmenu.kernel_option .xm_size array def

  /xmenu xmenu.kernel_option def

  xmenu .xm_current 0 put
  xmenu .xm_list kernel_option.list put

  xmenu .xm_title /txt_kernel_option put

  pmenu.init
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Update bit selection menu.
%
% ( ) ==> ( )
%
/kernel_option.update {
  /xmenu xmenu.kernel_option def

  /window.action actRedrawPanel def

  pmenu.update
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Show bit selection menu.
%
% ( ) => ( )
%
/panel.kernel_option {
  "kernel_option" help.setcontext

  window.xmenu
  dup .xmenu xmenu.kernel_option put
  dup .xmenu.update /kernel_option.update put
  dup window.init
      window.show
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Return width of panel entry.
%
% ( ) => ( width )
%
/panel.kernel_option.width {
  /xmenu xmenu.kernel_option def

  pmenu.width
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Redraw panel entry.
%
% ( panel ) => ( )
%
/panel.kernel_option.update {
  /xmenu xmenu.kernel_option def

  pmenu.panel.update
} def


