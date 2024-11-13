{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [ ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;
  languages.javascript = {
    enable = true;
    corepack.enable = true;
    pnpm.enable = true;
    package = pkgs.nodejs_20;
  };

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres = {
  #   enable = true;
  #   package = pkgs.postgresql_16;
  #   initialDatabases = [{
  #     user = "postgres";
  #     pass = "password";
  #     name = "postgres";
  #   }];
  # };

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
  '';

  enterShell = ''
  '';

  # https://devenv.sh/tasks/
  tasks = {
    # "myproj:setup".exec = "mytool build";
    # "devenv:enterShell".after = [ "myproj:setup" ];
  };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
