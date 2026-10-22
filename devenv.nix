{ pkgs, ... }:

{
  # Language server for this repository's own Lua files. See '.nvim.lua'.
  languages.lua.enable = true;

  # Keep the standalone editor configuration aligned with the tools declared in
  # ../nvim.nix. Tree-sitter compiles parsers locally, so it needs a C compiler.
  packages = with pkgs; [
    neovim-unwrapped
    git
    ripgrep
    gcc

    # Language servers
    nil
    bash-language-server
    cmake-language-server
    docker-language-server
    typescript-language-server
    tailwindcss-language-server

    # Tree-sitter and formatters
    tree-sitter
    nixfmt
    prettier
    beautysh
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
