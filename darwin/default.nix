{
  imports = [
    ./fonts.nix
    ./nix.nix
    ./nixpkgs.nix
    ./programs/gnupg.nix
    ./system.nix
    ./time.nix
  ];

  programs = {
    vim.enable = true;
    zsh.enable = true;
  };
}