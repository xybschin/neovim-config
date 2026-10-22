{ pkgs, ... }:

{
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
    lua-language-server
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
}
