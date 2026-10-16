{
    description = "LOEVI NixVim Config";

    #nixvim packages
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixvim = {
            url = "github:nix-community/nixvim/nixos-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        automkdir-nvim = { url = "github:mateuszwieloch/automkdir.nvim"; flake = false; };
        visimatch-nvim = { url = "github:wurli/visimatch.nvim";          flake = false; };
        vs2022-nvim    = { url = "github:loevi-art/vs2022.nvim";         flake = false; };
    };

    outputs = { self, nixpkgs, nixvim, ... }@inputs:
    let
        systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        forAllSystems = nixpkgs.lib.genAttrs systems;

        #one module used by both the package and the home-manager export
        nixvimModule = {
            imports = [ ./config ];
            _module.args.pluginSrcs = {
                inherit (inputs) automkdir-nvim visimatch-nvim vs2022-nvim;
            };
        };
    in {
        #main package
        packages = forAllSystems (system:
            let
                pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
                nixvim' = nixvim.legacyPackages.${system};
            in
            {
                default = nixvim'.makeNixvimWithModule {
                    inherit pkgs;
                    module = nixvimModule;
                };
            }
        );

        #nixos module setup
        nixosModules.default = { config, lib, pkgs, ... }:
            let
                cfg = config.programs.loevi-nixvim;
            in {
                options.programs.loevi-nixvim = {
                    enable = lib.mkEnableOption "LOEVI NixVim Config";
                };

                config = lib.mkIf cfg.enable {
                    environment.systemPackages = [
                        self.packages.${pkgs.system}.default
                    ];
                };
            };
        
        #home manager
        nixvimModules.default = nixvimModule;
    };
}
