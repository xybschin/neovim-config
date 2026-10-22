{ pkgs, ... }:
{
  # Language server for this repository's own Lua files. See '.nvim.lua'.
  languages.lua.enable = true;

  packages = with pkgs; [
    # Linter for the Nix files in this repository.
    nil
    # Formatter for the Nix files in this repository.
    nixfmt
    # Formatter for the Lua files in this repository. It is also used by
    # 'conform.nvim' (see 'plugin/40_plugins.lua').
    stylua
  ];

  enterShell = ''
    echo "neovim-config dev shell"
    echo "  stylua  - format Lua files"
    echo "  nixfmt  - format Nix files"
    echo "  nil     - lint Nix files"
  '';

  tasks."format:all".exec = ''
    stylua .
    nixfmt devenv.nix
  '';

  tasks."check:all".exec = ''
    stylua --check .
    nixfmt --check devenv.nix
  '';
}
