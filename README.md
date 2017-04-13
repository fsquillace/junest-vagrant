# JuNest build image via Vagrant

## Setup

Create the file for to `aws-config` and `aws-credentials` for pushing the image
to S3.

Example file for `aws-config`:

    [default]
    region=eu-west-1
    output=json

Example file for `aws-credentials`:

    [default]
    aws_access_key_id=ABCDEF
    aws_secret_access_key=12345


Follow the procedure below according to the JuNest architecture to build.

### x86\_64
```sh
ARCH=x86_64
PROVIDER=virtualbox
VAGRANT_VAGRANTFILE=Vagrantfile-$ARCH vagrant up --provider=$PROVIDER
```

### ARM
```sh
ARCH=arm
PROVIDER=scaleway
VAGRANT_VAGRANTFILE=Vagrantfile-$ARCH vagrant up --provider=$PROVIDER
```

## Build image

```sh
vagrant ssh -c /vagrant/build_junest.sh
```
