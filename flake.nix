{
  description = "Build Maven project using Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
      jdk = pkgs.openjdk11;
      jre = pkgs.jre11_minimal;
      pname = "hello-world";
      version = "1.0.0";
    in {
      artifacts = pkgs.stdenv.mkDerivation {
        name = "maven-repository";
        buildInputs = [ pkgs.maven ];
        src = ./.; # or fetchFromGitHub, cleanSourceWith, etc
        buildPhase = ''
          mvn clean package -Dmaven.repo.local=$out
        '';

        # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
        installPhase = ''
          find $out -type f \
            -name \*.lastUpdated -or \
            -name resolver-status.properties -or \
            -name _remote.repositories \
            -delete
        '';

        # don't do any fixup
        dontFixup = true;
        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
        # replace this with the correct SHA256
        # outputHash = lib.fakeSha256;
        outputHash = "sha256-Ja32fkF/l+Lx3Wkxaac4vY+86AMkIe/Pw4vf+ZrtiZ4=";
      };

      packages.${system}.default = let
        repository = self.artifacts;
      in pkgs.stdenv.mkDerivation {
        inherit pname;
        inherit version;
        src = ./.;
        # src = lib.cleanSource ./.;

        nativeBuildInputs = [ pkgs.maven jdk ];
        buildInputs = [
          jdk
          # pkgs.fetchMavenDeps
        ];
      
        buildPhase = ''
          export JAVA_HOME=${jdk.home}
          echo "Building Maven project..."
          mvn --offline -Dmaven.repo.local=${repository} -DskipScm=true -DskipTests clean package
        '';

        installPhase = ''
          install -Dm644 -t $out/share/java target/*.jar || echo "No JARs found in target/"
        '';

        meta = with pkgs.lib; {
          description = "Maven project built with Nix flakes";
          license = licenses.mit;
        };
      };

      devShells.${system}.default = let
        repository = self.artifacts;
      in pkgs.mkShell {
        buildInputs = [ pkgs.maven jdk ];
        shellHook = ''
          export JAVA_HOME=${jdk.home}
          alias mvn='mvn -Dmaven.repo.local=${repository}'
          alias build='mvn clean package'
          echo "Maven dev shell ready. Run 'mvn package' manually if needed."
        '';
      };

      # Usage: nix build -v ~/projects/java/hello#dockerImage -o res && ./res | podman load
      dockerImage = pkgs.dockerTools.streamLayeredImage {
        name = "hello";
        tag = "latest";
        created = "2025-10-19T10:00:01Z";
        contents = [
          jre
          self.packages.x86_64-linux.default
          pkgs.dockerTools.binSh
        ];
        config = {
          Cmd = [ "/bin/java" "-jar" "/share/java/${pname}-${version}.jar" ];
        };
      };
    };
}
