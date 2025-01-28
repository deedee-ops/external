{
  description = "external services";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      pre-commit-hooks,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        inherit (nixpkgs) lib;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            check-case-conflicts.enable = true;
            check-executables-have-shebangs.enable = true;
            check-merge-conflicts.enable = true;
            check-shebang-scripts-are-executable.enable = true;
            end-of-file-fixer.enable = true;
            fix-byte-order-marker.enable = true;
            mixed-line-endings.enable = true;
            pre-commit-hook-ensure-sops = {
              enable = true;
              files = ".+\.sops\..*";
            };
            trim-trailing-whitespace.enable = true;

            deadnix.enable = true;
            flake-checker.enable = true;
            statix.enable = true;
            nixfmt-rfc-style.enable = true;

            check-json.enable = true;
            terraform-format.enable = true;
            tflint.enable = true;
            yamllint.enable = true;

            actionlint.enable = true;
            commitizen.enable = true;

            # custom hooks
            gitleaks = {
              enable = true;
              name = "gitleaks";
              package = pkgs.gitleaks;
              entry = "${lib.getExe pkgs.gitleaks} protect --verbose --redact --staged";
            };
          };
        };

        devShells.default =
          let
            tofuWrapper = pkgs.writeShellScriptBin "tofu" ''
              cleanup() {
                rm -rf terraform.tfstate || true
                rm -rf terraform.tfvars || true
              }
              trap cleanup EXIT

              if [ -f terraform.sops.tfstate ]; then
                ${lib.getExe pkgs.sops} -d terraform.sops.tfstate > terraform.tfstate
              fi
              if [ -f terraform.sops.tfvars ]; then
                ${lib.getExe pkgs.sops} -d terraform.sops.tfvars > terraform.tfvars
              fi

              ${lib.getExe pkgs.opentofu} "$@"

              ${lib.getExe pkgs.sops} -e terraform.tfstate > terraform.sops.tfstate
              cleanup
            '';
          in
          pkgs.mkShell {
            SOPS_AGE_KEY_FILE = "/persist/etc/age/keys.txt";

            buildInputs = self.checks.${system}.pre-commit-check.enabledPackages ++ [
              pkgs.sops
            ];

            packages = [ tofuWrapper ];

            shellHook =
              self.checks.${system}.pre-commit-check.shellHook
              + ''
                ${lib.getExe pkgs.git} pull origin master:master --rebase

                ${lib.getExe pkgs.sops} -d terraform.sops.tfstate > terraform.tfstate
                ${lib.getExe pkgs.sops} -d terraform.sops.tfvars > terraform.tfvars
                ${lib.getExe tofuWrapper} init -upgrade

                rm -rf terraform.tfstate || true
                rm -rf terraform.tfvars || true
              '';
          };
      }
    );
}
