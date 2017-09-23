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
To build JuNest for the arm arch you need to use scaleway as provider.
Scaleway requires `scaleway_data.json` file to work properly. The file must
contain the name of the organization, the token
(can be generate from the scaleway website) and the private key used to access via SSH:

```json
{
  "organization": "5555555-4444-3333-2222-111111111",
  "token": "1111111-2222-3333-4444-55555",
  "private_key_path": "~/.ssh/scaleway_rsa"
}
```


```sh
ARCH=arm
PROVIDER=scaleway
VAGRANT_VAGRANTFILE=Vagrantfile-$ARCH vagrant up --provider=$PROVIDER
```

## Build image

```sh
VAGRANT_VAGRANTFILE=Vagrantfile-$ARCH vagrant ssh -c /vagrant/build_junest.sh
```
