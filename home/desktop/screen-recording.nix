{pkgs, ...}: {
  home.packages = with pkgs; [
    wf-recorder # screenrec
    # gpu-screen-recorder # experimental screenrec
    hyprshot # ss
    grimblast # ss
    slurp # region select
    flameshot # better ss maybe?
  ];

  programs.obs-studio.enable = true;
}
