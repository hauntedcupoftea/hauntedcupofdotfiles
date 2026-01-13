{
  lib,
  pkgs,
  ...
}: {
  programs.rio = {
    enable = true;
    settings = {
      shell = {
        program = lib.getExe pkgs.fish;
        args = ["--login"];
      };
      editor.program = lib.getExe pkgs.helix;
      navigation = {
        mode = "Plain";
        use-split = false;
      };
      window = {
        decorations = "enabled";
        blur = true;
      };
      # testing config from wiki (is broken)
      # hints = {
      #   alphabet = "jfkdls;ahgurieowpq";
      #   # Characters used for hint labels
      #   rules = [
      #     {
      #       regex = ''(https://|http://)[^\u{0000}-\u{001F}\u{007F}-\u{009F}<>\"\\s{-}\\^⟨⟩`\\\\]+'';
      #       hyperlinks = true;
      #       post-processing = true;
      #       persist = false;
      #       action = {
      #         command = "xdg-open";
      #       };
      #       binding = {
      #         key = "O";
      #         mods = ["Control" "Shift"];
      #       };
      #     }
      #   ];
      # };
    };
  };
}
