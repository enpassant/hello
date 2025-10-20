# Hello

Sample “Hello World” Maven project with Nix flake build, development environment, and Podman (Docker) packaging.

## Usage

### Build JAR artifacts repository package

```bash
nix build github:enpassant/hello#artifacts
```

The result will be in the `result` directory.  
Example of top-level folders:

> aopalliance  asm  com  commons-io  javax  net  org

### Build the hello-world JAR package

```bash
nix build github:enpassant/hello
```

The resulting file can be found at:

> `./result/share/java/hello-world-1.0.0.jar`

### Use the developer shell

1. Clone the project:
   ```bash
   git clone https://github.com/enpassant/hello.git
   ```
2. Enter the project folder:
   ```bash
   cd hello
   ```
3. Start the developer shell:
   ```bash
   nix develop github:enpassant/hello
   ```
4. Modify the code and build it using:
   ```bash
   build
   # or
   mvn clean package
   ```

### Build and load the Podman (Docker) image

```bash
nix build -v github:enpassant/hello#dockerImage && ./result | podman
```

Check the result with:

```bash
podman images
```

### Use with a local (cloned) project

In the `hello` folder, you can run the following commands:

```bash
nix build #artifacts
nix build
nix develop
nix build -v #dockerImage && ./result | podman
```
