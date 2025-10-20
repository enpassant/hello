# hello

Hello World sample maven project with nix flake build, develop and make podman (docker) package.

## Usages

### Build jar artifacts repository package

`nix build github:enpassant/hello#artifacts`

The result is in the `result` package. Eg. one depth folders:

>  aopalliance  asm  com  commons-io  javax  net  org 

### Build hello-world jar artifact package

`nix build github:enpassant/hello`

The result is in the `result` package:

> ./result/share/java/hello-world-1.0.0.jar

### Use developer shell

1. Clone the project
`git clone https://github.com/enpassant/hello.git`
2. Enter into the project folder
`cd hello`
3. Make developer shell
`nix develop github:enpassant/hello`
4. Modify the code, and build with
`build` or `mvn clean package` commands

### Build docker (podman) image and load into docker (podman)

`nix build -v github:enpassant/hello#dockerImage && ./result | podman`

Check the result:

`podman images`

### Use with local (cloned) project

In the hello folder you can use this commands:

`nix build #artifacts`
`nix build`
`nix develop`
`nix build -v #dockerImage && ./result | podman`

